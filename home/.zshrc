#@IgnoreInspection BashAddShebang
zmodload zsh/zprof

################
# Path Changes #
################

if type brew &>/dev/null; then
# Use zsh-completions
    chmod -R go-w '/opt/homebrew/share'
    BREW_PREFIX=$(brew --prefix)
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    # Use brew coreutils
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

    # Use brew curl
    export PATH="$BREW_PREFIX/opt/curl/bin:$PATH"

    # Use brew findutils
    export PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"

    # Use brew grep
    export PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"

fi

# pipx installs
export PATH="$PATH:$HOME/.local/bin"

# rust installs
export PATH="$PATH:$HOME/.cargo/bin"

# conda installs - dont touch, conda wll overwrite this
# >>> conda initialize >>>
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

########################
# znap package manager #
########################

# Path to your Zsh config home (optional, for neatness)
export ZDOTDIR="${HOME}"

if [[ ! -f "${ZDOTDIR}/.zsh/znap/znap.zsh" ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "${ZDOTDIR}/.zsh/znap"
fi
source "${ZDOTDIR}/.zsh/znap/znap.zsh"

# Load plugins
znap source romkatv/powerlevel10k # Powerlevel10k theme
znap source zsh-users/zsh-autosuggestions # Autosuggestions
znap source zsh-users/zsh-completions # Completions
znap source zsh-users/zsh-history-substring-search # History substring search
znap source zsh-users/zsh-syntax-highlighting # Syntax highlighting

# Completion (lazy load for performance)
autoload -Uz compinit
znap eval _compinit 'compinit'

##################
# Theme Settings #
##################

# Enable Powerlevel10k if configuration exists and is readable
[[ -r "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"

##################
# Alias Settings #
##################

# these fancy headers are getting silly for these one-liners
[[ -r ~/.aliases.zsh ]] && source ~/.aliases.zsh

####################
# History Settings #
####################

# If a new command line being added to the history list duplicates an older one, 
# the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Remove the history (fc -l) command from the history list when invoked. 
# Note that the command lingers in the internal history until the next command is 
# entered before it vanishes, allowing you to briefly reuse or edit the line.
setopt HIST_NO_STORE

# When searching for history entries in the line editor, do not display duplicates
# of a line previously found, even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS

# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# Save each command’s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file. The format of this prefixed data is:
# ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt EXTENDED_HISTORY

# Saves each command to history as soon as it’s run, not just at shell exit.
setopt INC_APPEND_HISTORY

# Shares history across terminals in real time.
setopt SHARE_HISTORY

# Set history size limits
HISTSIZE=10000
SAVEHIST=10000

# Where to store history
HISTFILE=~/.zsh_history

###############################
# Performance Troubleshooting #
###############################
# Show profiling results
# Uncomment the following line to enable profiling
# zprof