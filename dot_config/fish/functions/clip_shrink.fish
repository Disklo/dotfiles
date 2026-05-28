function clip_shrink --description "Process, resize, and compress an image from clipboard/file to clipboard/file"
    argparse 'i/input=' 'o/output=' 's/max-size=' 'w/max-width=' 'f/filter=' \
             'skip-resize' 'skip-pngquant' 'skip-iterative' \
             'only-resize' 'only-pngquant' 'only-iterative' 'r/raw' 'h/help' -- $argv
    or return 1

    if set -ql _flag_help
        echo "Usage: clip_shrink [options]"
        echo ""
        echo "Options:"
        echo "  -i, --input=PATH      Input image file path (if omitted, uses clipboard)"
        echo "  -o, --output=PATH     Output image file path (if omitted, copies to clipboard)"
        echo "  -s, --max-size=MB     Target max file size in MB (default: 8)"
        echo "  -w, --max-width=PX    Target max width in pixels (default: 1080)"
        echo "  -f, --filter=NAME     Resampling filter for ImageMagick (default: Lanczos)"
        echo "  -r, --raw             Skip all processing; extract/copy image completely untouched"
        echo "  --skip-resize         Skip the resizing step"
        echo "  --skip-pngquant       Skip the pngquant compression step"
        echo "  --skip-iterative      Skip the iterative quality reduction step"
        echo "  --only-resize         Only perform resizing"
        echo "  --only-pngquant       Only perform pngquant compression"
        echo "  --only-iterative      Only perform iterative quality reduction"
        echo "  -h, --help            Show this help message"
        echo ""
        echo "Common Filters (-f):"
        echo "  Lanczos (default), Cubic, Triangle, Point (Nearest Neighbor)."
        echo "  Run 'magick -list filter' to see the complete list."
        return 0
    end

    set -l max_size_mb 8
    set -ql _flag_max_size; and set max_size_mb $_flag_max_size
    set -l max_size_bytes (math "$max_size_mb * 1024 * 1024")

    set -l max_width 1080
    set -ql _flag_max_width; and set max_width $_flag_max_width

    set -l filter "Lanczos"
    set -ql _flag_filter; and set filter $_flag_filter

    set -l run_resize 1
    set -l run_pngquant 1
    set -l run_iter 1

    if set -ql _flag_skip_resize; set run_resize 0; end
    if set -ql _flag_skip_pngquant; set run_pngquant 0; end
    if set -ql _flag_skip_iterative; set run_iter 0; end

    if set -ql _flag_only_resize
        set run_resize 1; set run_pngquant 0; set run_iter 0
    else if set -ql _flag_only_pngquant
        set run_resize 0; set run_pngquant 1; set run_iter 0
    else if set -ql _flag_only_iterative
        set run_resize 0; set run_pngquant 0; set run_iter 1
    end

    if set -ql _flag_raw
        set run_resize 0
        set run_pngquant 0
        set run_iter 0
    end

    set -l tmp_in (mktemp /tmp/clip_in.XXXXXX.png)
    set -l tmp_out (mktemp /tmp/clip_out.XXXXXX.png)
    set -l tmp_lossy (mktemp /tmp/clip_lossy.XXXXXX.webp)

    function _cleanup_clip -V tmp_in -V tmp_out -V tmp_lossy
        rm -f $tmp_in $tmp_out $tmp_lossy
    end

    if set -ql _flag_input
        if test -f "$_flag_input"
            echo "Processing local file: $_flag_input"
            cp "$_flag_input" $tmp_in
        else
            echo "Error: Input file '$_flag_input' not found."
            _cleanup_clip
            return 1
        end
    else
        if not wl-paste --type image/png > $tmp_in 2>/dev/null
            if not wl-paste --type image/jpeg > $tmp_in 2>/dev/null
                echo "Error: No image found in clipboard or wl-paste failed."
                _cleanup_clip
                return 1
            end
        end
        echo "Processing image from clipboard..."
    end

    cp $tmp_in $tmp_out
    set -l current_size (stat -c %s $tmp_out)

    set -l output_mode "clipboard"
    if set -ql _flag_output
        set output_mode "file"
    end

    if set -ql _flag_raw; or test $current_size -le $max_size_bytes
        if set -ql _flag_raw
            echo "Raw mode active. Bypassing all processing."
        else
            echo "Image is already under $max_size_mb MB ("(math -s 2 "$current_size / 1024 / 1024")" MB)."
        end

        if test "$output_mode" = "file"
            echo "Saving untouched image to file: $_flag_output"
            cp $tmp_out "$_flag_output"
        else
            echo "Copying untouched image to clipboard."
            wl-copy --type image/png < $tmp_out
        end
        _cleanup_clip
        return 0
    end

    echo "Initial image size: "(math -s 2 "$current_size / 1024 / 1024")" MB. Processing..."

    if test $run_resize -eq 1
        set -l current_width (magick identify -format "%w" $tmp_out 2>/dev/null)
        if test $current_width -gt $max_width
            echo "-> Resizing to width $max_width using $filter filter..."
            magick $tmp_out -filter $filter -resize "$max_widthx>" $tmp_out
            set current_size (stat -c %s $tmp_out)
        end
    end

    set -l img_format (magick identify -format "%m" $tmp_out 2>/dev/null)

    if test $run_pngquant -eq 1; and test $current_size -gt $max_size_bytes; and test "$img_format" = "PNG"
        echo "-> Image > $max_size_mb MB. Running pngquant compression..."
        pngquant --force --ext .png --speed 1 $tmp_out 2>/dev/null
        set current_size (stat -c %s $tmp_out)
    end

    if test $run_iter -eq 1; and test $current_size -gt $max_size_bytes
        echo "-> Image still > $max_size_mb MB. Iteratively reducing quality..."
        set -l quality 100
        set -l step 5

        while test $current_size -gt $max_size_bytes; and test $quality -ge 10
            set quality (math "$quality - $step")
            echo "   Testing quality $quality%..."
            
            magick $tmp_out -quality $quality $tmp_lossy
            magick $tmp_lossy $tmp_out
            
            set current_size (stat -c %s $tmp_out)
        end
    end

    if test $current_size -le $max_size_bytes
        echo "-> Success! Final size: "(math -s 2 "$current_size / 1024 / 1024")" MB."
    else
        echo "-> Warning: Reached minimum quality bounds. Final size: "(math -s 2 "$current_size / 1024 / 1024")" MB."
    end
    
    if test "$output_mode" = "file"
        echo "Saving output to: $_flag_output"
        cp $tmp_out "$_flag_output"
    else
        echo "Copying output to clipboard."
        wl-copy --type image/png < $tmp_out
    end

    _cleanup_clip
end
