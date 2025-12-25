function weather --wraps='curl wttr.in' --description 'alias wheather=curl wttr.in'
    curl wttr.in $argv
end
