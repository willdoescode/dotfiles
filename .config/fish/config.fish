#!/usr/bin/env fish

set fish_cursor_default line
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
set -U __done_min_cmd_duration 5000  

alias valgrind='leaks -atExit --'
alias :o='nvim'
alias git='hub'
alias tf='terraform'
alias :e='vim'
alias b='brew'
alias c='clear'
alias ping='prettyping'
alias :q='exit'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias brewup='brew update; brew upgrade; brew upgrade --cask; brew cleanup; brew doctor'
alias nat='natls -lgn'
alias ls='nat'
alias l='ls -h'
alias vim='nvim'
alias vi='nvim'
alias rm='trash'
alias brave='open -a "/Applications/Brave Browser Dev.app/"'
alias startmongo='brew services start mongodb-community@4.4'
alias stopmongo='brew services stop mongodb-community@4.4'
alias icat="kitty +kitten icat"
alias neofetch="neofetch --size 30%"
alias natcpp="natcpp -gs"
alias nnn='nnn -ed'
alias star='star-it-all'
alias torvalds="git blame-someone-else \"Linus Torvalds <torvalds@linux-foundation.org>\""
alias ga="git add"
alias gc="git commit -S"
alias gp="git push"
alias gpu="git pull"
alias gs="git status"
alias gd="git diff"
alias zephyrnet="ssh w@zephyrnet.hackclub.com"
alias hide-icons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias show-icons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias gg="git commit -m \"empty\" --allow-empty"

function manpdf
	man -tpdf $argv | open -fa /System/Applications/Preview.app
end

function zig-build-small
	zig build-exe $argv -O ReleaseSmall --strip
end

function latexpdfopen
	pdflatex $argv && open (basename $argv tex)pdf
end

function mcdir
  mkdir $argv && cd $argv
end

function cat
  if [ (determine-extension $argv) = "md" ]
    mdcat $argv
  else
    bat --theme=gruvbox $argv
  end
end

export RUST_SRC_PATH=(rustc --print sysroot)/lib/rustlib/src/rust/library

source $HOME/.cargo/env
export LEIN_JVM_OPTS="-XX:TieredStopAtLevel=1"

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux HAXE_STD_PATH "/usr/local/lib/haxe/std"

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
kitty + complete setup fish | source
zoxide init fish | source
starship init fish | source

thefuck --alias | source
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

status is-interactive; and pyenv init --path | source
pyenv init - | source

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /Users/willlane/.ghcup/bin # ghcup-env
