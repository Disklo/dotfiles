function venv-activate --wraps='source venv/bin/activate.fish' --description 'alias venv-activate=source venv/bin/activate.fish'
    source venv/bin/activate.fish $argv
end
