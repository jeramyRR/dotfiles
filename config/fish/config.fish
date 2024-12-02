# Disable the fish greeting message
set fish_greeting ""


source ~/.asdf/asdf.fish
#mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
starship init fish | source
source "$HOME/.cargo/env.fish"
source ~/.asdf/plugins/golang/set-env.fish

fastfetch

# Aliases
alias ls="eza"
alias la="eza -a"
alias ll="eza -lag --header"
alias cat="bat"
alias goland="open -na /Applications/Goland.app --args $argv" 

function cd -w='cd'
    builtin cd $argv || return
    check_directory_for_new_repository
end

function check_directory_for_new_repository
    set current_repository (git rev-parse --show-toplevel 2> /dev/null)
    if [ "$current_repository" ] && [ "$current_repository" != "$last_repository" ]
        onefetch
    end
    set -gx last_repository $current_repository
end