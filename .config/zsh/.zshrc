#!/usr/bin/env zsh

###################
# INSTANT PROMPT  #
###################
# Enable Powerlevel10k instant prompt (must stay at top of zshrc)
# Makes the prompt appear immediately while the rest of configs load
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#######################
# PERFORMANCE TWEAKS  #
#######################
# Reduce startup time by disabling features until needed
skip_global_compinit=1          # Skip global compinit
DISABLE_MAGIC_FUNCTIONS=true    # Disable zsh magic functions
ZSH_DISABLE_COMPFIX=true       # Disable completion fixing

# Additional optimizations for faster startup
CASE_SENSITIVE="false"         # Case-insensitive completion
HYPHEN_INSENSITIVE="true"     # Treat - and _ as same in completion
DISABLE_AUTO_UPDATE="true"    # Disable auto-updates for faster startup
COMPLETION_WAITING_DOTS="true" # Show dots during completion

###################
# HISTORY CONFIG  #
###################
# History settings for better command line navigation
# Usage: 
# - Up/Down arrows to navigate history
# - Ctrl+R to search history
# - Type command with space prefix to exclude from history
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt BANG_HIST                # Enable ! history expansion
setopt EXTENDED_HISTORY        # Save timestamp and duration
setopt INC_APPEND_HISTORY      # Immediate history saving
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST  # Remove duplicates first when trimming
setopt HIST_IGNORE_DUPS        # Don't save immediate duplicates
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries
setopt HIST_FIND_NO_DUPS       # Don't show duplicates in search
setopt HIST_IGNORE_SPACE       # Don't save commands starting with space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt HIST_VERIFY            # Show command before executing from history

########################
# DIRECTORY NAVIGATION #
########################
# Enhanced directory movement features
# Usage:
# - Just type directory name to cd into it
# - cd - to go back to previous directory
# - dirs -v to see directory stack
setopt AUTO_CD                  
setopt AUTO_PUSHD              
setopt PUSHD_IGNORE_DUPS       
setopt PUSHD_MINUS             

##################
# PATH SETTINGS  #
##################
# Fast path setup with common development directories
typeset -U PATH path
path=(
  $HOME/.local/bin             # Local binaries
  $HOME/.cargo/bin             # Rust binaries
  /usr/local/bin               # Homebrew binaries
  $HOME/.npm/bin               # NPM global binaries
  $HOME/.poetry/bin            # Poetry binaries
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $HOME/go/bin                 # Go binaries
  $HOME/.deno/bin              # Deno binaries
  $path
)

#############
# EXPORTS   #
#############
# Essential environment variables
export PATH EDITOR='nvim' VISUAL='nvim' \
  DOCKER_HOST=unix:///Users/willlane/.docker/run/docker.sock

####################
# PLUGIN MANAGER   #
####################
# Fast zinit setup for plugin management
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || { 
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}
source "${ZINIT_HOME}/zinit.zsh"

# Load essential plugins in turbo mode for faster startup
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Git integration plugins
zinit wait lucid for \
  OMZ::lib/git.zsh \
  OMZ::plugins/git/git.plugin.zsh

# Directory jumping plugin
zinit wait"1" lucid light-mode for \
  agkozak/zsh-z

####################
# AUTOSUGGESTIONS  #
####################
# Settings for command suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_MANUAL_REBIND=true
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

#############
# FUNCTIONS #
#############
# Create directory and cd into it
# Usage: mcdir my/new/directory
mcdir() { mkdir -p "$@" && cd "$@" }

#############
# ALIASES   #
#############
# Quick shortcuts for common commands
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias :q='exit'
alias :o='nvim'
alias :e='vim'
alias vim='nvim'
alias vi='nvim'
alias rm='trash'  # Safer alternative to rm

##################
# GIT & HUB      #
##################
# Hub integration for GitHub features
# Usage: hub commands work automatically with git
git() {
  unfunction git
  eval "$(hub alias -s)"
  git "$@"
} 

# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit -S'        # Signed commits
alias gp='git push'
alias gpu='git pull'
alias gs='git status -sb'       # Short status
alias gd='git diff'

# GitHub-specific commands through hub
alias gh='git browse'           # Open repo in browser
alias gpr='git pull-request'    # Create PR
alias gf='git fork'            # Fork repo

unalias gp gpu 2>/dev/null     # Prevent conflicts

##################
# FILE LISTING   #
##################
# Modern ls replacement with eza
# Usage: ls, ll, la, lt
alias ls='eza --group-directories-first --color=always --color-scale size \
-a \
--git \
-l \
--time-style=long-iso \
--group \
--header \
--binary \
--classify \
--color-scale-mode=gradient'

alias ll='ls'
alias lt='ls --tree'

export EZA_COLORS="di=34:ex=31:ur=33:uw=31:ux=32:ue=32:gr=33:gw=31:gx=32:tr=33:tw=31:tx=32"

##################
# PYENV CONFIG   #
##################
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
function pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}

#################
# COMPLETIONS   #
#################
FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"

# Fast completion initialization
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion settings
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' menu select
_comp_options+=(globdots)

#######################
# SEARCH FUNCTIONS    #
#######################
# Fast file search with fd
# Usage: f pattern
f() { fd --color always "$@" }

# Fast content search with ripgrep
# Usage: r "search pattern"
r() { rg --color always --smart-case --line-number "$@" }

# Quick directory jumping with z
# Usage: j partial-dirname
j() { z "$@" }

# Fuzzy file opening
# Usage: fo (then select file)
fo() { ${EDITOR:-nvim} "$(fd --type file --hidden --exclude .git --exclude node_modules . | fzf)" }

#######################
# PRODUCTIVITY        #
#######################
# Quick note taking
# Usage: note "Something to remember"
note() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" >> ~/notes.md
}

# Quick timer
# Usage: timer 5m
timer() {
  local time=$1
  shift
  sleep $time && terminal-notifier -message "${*:-Timer is done!}"
}

#######################
# KEYBOARD SHORTCUTS  #
#######################
# Add after your current key bindings
# macOS compatible key bindings
# Alacritty specific key bindings
bindkey "\e[1;3D" backward-word      # Alt + Left
bindkey "\e[1;3C" forward-word       # Alt + Right
bindkey "\e[H"    beginning-of-line  # Home
bindkey "\e[F"    end-of-line       # End
bindkey "\e[3~"   delete-char       # Delete
bindkey "^?"      backward-delete-char    # Backspace
bindkey "^[[A"    history-beginning-search-backward # Up arrow
bindkey "^[[B"    history-beginning-search-forward  # Down arrow

# Additional Alacritty conveniences
bindkey "^U"      kill-whole-line      # Ctrl + U
bindkey "^K"      kill-line            # Ctrl + K
bindkey "^W"      backward-kill-word   # Ctrl + W
bindkey "^A"      beginning-of-line    # Ctrl + A
bindkey "^E"      end-of-line         # Ctrl + E

###################
# BAT CONFIG      #
###################

# Set bat as the default pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_PAGER="less -RF"

# Bat theme and style settings
export BAT_STYLE="numbers,changes,header"

# Bat aliases for different use cases
alias cat='bat --paging=never'              # Replace cat with bat
alias less='bat --paging=always'            # Use bat instead of less
alias bathelp='bat --plain --language=help' # Special help viewing
alias batdiff='git diff --name-only --relative | xargs bat --diff'  # Show git changes

# Preview function using bat
# Usage: preview file.txt
preview() {
    fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window=right:60%
}

#######################
# HELP FUNCTION       #
#######################
# Show command categories and their usage
# Usage: help [category]
help() {
    local category=${1}
    
    print_category() {
        echo "\033[1;34m${1}\033[0m"
        echo "\033[90m${(r:40::-:)}\033[0m"
    }

    # If no category specified, show available categories
    if [[ -z $category ]]; then
        print_category "Available Categories"
        echo "\033[33mfiles\033[0m    - File operations and listings"
        echo "\033[33mgit\033[0m      - Git and GitHub commands"
        echo "\033[33mnav\033[0m      - Directory navigation"
        echo "\033[33msearch\033[0m   - File and content search tools"
        echo "\033[33mutils\033[0m    - Utility functions"
        echo
        echo "Usage: \033[32mhelp\033[0m \033[33m<category>\033[0m"
        return
    fi

    case $category in
        "files")
            print_category "File Operations"
            echo "\033[33mls\033[0m               - Enhanced file listing with git status"
            echo "\033[33mll\033[0m               - Same as ls"
            echo "\033[33mla\033[0m               - List all files including hidden"
            echo "\033[33mlt\033[0m               - Tree view of directory"
            echo "\033[33mcat\033[0m              - Better cat with syntax highlighting"
            echo "\033[33mless\033[0m             - Enhanced file viewer"
            echo "\033[33mbathelp\033[0m          - Show help pages with highlighting"
            echo "\033[33mbatdiff\033[0m          - Show git changes with syntax highlighting"
            echo "\033[33mpreview\033[0m          - Preview files with fzf and bat"
            ;;
        "git")
            print_category "Git Commands"
            echo "\033[33mga\033[0m               - git add"
            echo "\033[33mgc\033[0m               - git commit (signed)"
            echo "\033[33mgp\033[0m               - git push"
            echo "\033[33mgpu\033[0m              - git pull"
            echo "\033[33mgs\033[0m               - git status (short format)"
            echo "\033[33mgd\033[0m               - git diff"
            echo "\033[33mgh\033[0m               - Open repo in browser"
            echo "\033[33mgpr\033[0m              - Create pull request"
            echo "\033[33mgf\033[0m               - Fork repository"
            ;;
        "nav")
            print_category "Navigation"
            echo "\033[33mmcdir\033[0m            - Create directory and cd into it"
            echo "\033[33mj\033[0m                - Jump to frequently used directory"
            echo "\033[33m..\033[0m               - Go up one directory"
            echo "\033[33m...\033[0m              - Go up two directories"
            echo "\033[33m....\033[0m             - Go up three directories"
            ;;
        "search")
            print_category "Search Tools"
            echo "\033[33mf\033[0m                - Fast file search (fd)"
            echo "\033[33mr\033[0m                - Fast content search (ripgrep)"
            echo "\033[33mfo\033[0m               - Fuzzy find and open file"
            ;;
        "utils")
            print_category "Utilities"
            echo "\033[33mnote\033[0m             - Quick note taking (saves to ~/notes.md)"
            echo "\033[33mtimer\033[0m            - Set countdown timer with notification"
            echo "\033[33mpreview\033[0m          - Preview files with syntax highlighting"
            ;;
    esac
}

alias h='help'


#################
# THEME         #
#################
# Load powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
