function sudo-gui --description 'Open any GUI application as root with environment preserved'
    if test (count $argv) -eq 0
        echo "Usage: sudo-gui <program_name> [arguments]"
        return 1
    end
    sudo -EH $argv
end
