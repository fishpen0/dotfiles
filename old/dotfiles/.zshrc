#@IgnoreInspection BashAddShebang
zmodload zsh/zprof

################
# Path Changes #
################

if type brew &>/dev/null; then
# Use zsh-completions
    chmod -R go-w '/opt/homebrew/share'
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit

    # Use brew coreutils
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

    # Use brew curl
    export PATH="/usr/local/opt/curl/bin:$PATH"

    # Use brew findutils
    export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

    # use brew Krew
    export PATH="${PATH}:${HOME}/.krew/bin"

    # Use brew grep
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

    # Use brew antidote
    source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
fi

# load custom aliases
source $HOME/.aliases.zsh

# load 1password completions
eval "$(op completion zsh)"; compdef _op op

##############
# zplug package manager #
#########################

export ZPLUG_HOME=$(brew --prefix zplug)
source $ZPLUG_HOME/init.zsh

# zsh-users plugins
zplug "zsh-users/zsh-apple-touchbar"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# oh-my-zsh plugins
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

# theme
zplug romkatv/powerlevel10k, as:theme, depth:1

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Bind up and down to zsh history
if zplug check zsh-users/zsh-history-substring-search; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

##################
# PowerLevel 10k #
##################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#######################
# Powerlevel9k Config #
#######################

# Font Mode
POWERLEVEL9K_MODE='nerdfont-complete'

# Basic Config
POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

# Context Config
DEFAULT_USER=$USER
POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
POWERLEVEL9K_CONTEXT_TEMPLATE=%n

# Dir Config
# POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_folder_marker
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
# POWERLEVEL9K_SHORTEN_FOLDER_MARKER=(.git|.hg|.terraform)

# AWS Segment
POWERLEVEL9K_CUSTOM_AWS="zsh_aws"
POWERLEVEL9K_CUSTOM_AWS_BACKGROUND=202
POWERLEVEL9K_CUSTOM_AWS_FOREGROUND=015

# AWS Segment
POWERLEVEL9K_CUSTOM_KUBERNETES="zsh_kubernetes"
POWERLEVEL9K_CUSTOM_KUBERNETES_BACKGROUND=099
POWERLEVEL9K_CUSTOM_KUBERNETES_FOREGROUND=015

# Random Icon Segment
POWERLEVEL9K_CUSTOM_RANDICON="zsh_randicon"
POWERLEVEL9K_CUSTOM_RANDICON_BACKGROUND=000
POWERLEVEL9K_CUSTOM_RANDICON_FOREGROUND=011

# Terraform Segment
POWERLEVEL9K_CUSTOM_TERRAFORM="zsh_terraform"
POWERLEVEL9K_CUSTOM_TERRAFORM_BACKGROUND=057
POWERLEVEL9K_CUSTOM_TERRAFORM_FOREGROUND=015

# Virtualenv Segment
POWERLEVEL9K_VIRTUALENV_BACKGROUND=green
POWERLEVEL9K_PYTHON_ICON="\uf81f"

# Segments Config
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_randicon dir custom_aws custom_kubernetes custom_terraform virtualenv rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status gcloud root_indicator background_jobs history time)

##################
# Aliases Config #
##################

# Force zsh to autocomplete custom aliases
setopt COMPLETE_ALIASES

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

# Uncomment to run startup diagnostics
# zprof