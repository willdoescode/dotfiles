#!/usr/bin/env fish
set fish_greeting ""

fish_vi_key_bindings
set fish_cursor_default line
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
set -U __done_min_cmd_duration 5000  

alias :o='nvim'
alias git='hub'
alias :e='vim'
alias b='brew'
alias c='cargo'
alias ping='gping'
alias :q='exit'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias brewup='brew update; brew upgrade; brew upgrade --cask; brew cleanup; brew doctor'
alias cat='bat'
alias nat='natls --gdf -ln'
alias ls='nat'
alias l='ls -h'
alias wclock='watch -n1 "date '+%D%n%T'|figlet -k"'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias rm='trash'

set -x PATH $HOME/bin /usr/local/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin $HOME/.cargo/bin $HOME/.projects/bin $HOME/Library/Python/2.7/bin
source $HOME/.cargo/env
thefuck --alias | source
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
starship init fish | source
