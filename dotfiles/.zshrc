#@IgnoreInspection BashAddShebang

################
# Path Changes #
################

# Setup Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Use Gnuutils commands by default
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

#######################
# Environment Changes #
#######################
export AWS_DEFAULT_PROFILE="default"

###############
# iTerm setup #
###############

# load iterm integration
source ~/.iterm2_shell_integration.zsh

#############
# oh-my-zsh #
#############

# Path to your oh-my-zsh installation.
export ZSH="/Users/lstuart/.antigen/bundles/robbyrussell/oh-my-zsh/"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )


# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.zsh_customizations

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

#######################
# Powerlevel9k Config #
#######################

# Basic Config
POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

# Context Config
DEFAULT_USER=$USER
POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
POWERLEVEL9K_CONTEXT_TEMPLATE=%n

# Dir Config
# POWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_folder_marker
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_FOLDER_MARKER=(.git|.hg|.terraform)

# Custom functions
zsh_aws() {
  if [ "$AWS_DEFAULT_PROFILE" != "default" ]; then
    local color='%F{208}'
    echo -n "\ue7ad ${AWS_DEFAULT_PROFILE}"
  fi
}

zsh_kubernetes() {
  if [[ ${KUBERNETES_DISPLAY} ]]; then
    context=$(kubectl config current-context)
    local color='%F{68}'
    echo -n "\ufd31 ${context}"
  fi
}

zsh_terraform() {
  # break if there is no .terraform directory
  if [[ -d .terraform ]]; then
    local tf_workspace=$(/usr/local/bin/terraform workspace show)
    local tf_short_workspace=${tf_workspace:0:1:u}
    local tf_region=$(readlink backend.tf | awk -F. '{print $3}')

    if [[ $tf_short_workspace == "P" ]]
    then
      local color='%F{red}'
    else
      local color='%F{white}'
    fi 

    case $tf_region in
      us-west-2)
        local tf_short_region="UW2"
        ;;
      us-west-2)
        local tf_short_region="UE2"
        local color='%F{red}'
        ;;
      *)
        local tf_short_region=$tf_region
        local color='%F{yellow}'
        ;;
    esac

    echo -n "%{$color%}\ufbdf $tf_short_workspace:$tf_short_region%{%f%}"
  fi
}

# AWS Segment
POWERLEVEL9K_CUSTOM_AWS="zsh_aws"
POWERLEVEL9K_CUSTOM_AWS_BACKGROUND=202
POWERLEVEL9K_CUSTOM_AWS_FOREGROUND=015

# AWS Segment
POWERLEVEL9K_CUSTOM_KUBERNETES="zsh_kubernetes"
POWERLEVEL9K_CUSTOM_KUBERNETES_BACKGROUND=099
POWERLEVEL9K_CUSTOM_KUBERNETES_FOREGROUND=015

# Terraform Segment
POWERLEVEL9K_CUSTOM_TERRAFORM="zsh_terraform"
POWERLEVEL9K_CUSTOM_TERRAFORM_BACKGROUND=057
POWERLEVEL9K_CUSTOM_TERRAFORM_FOREGROUND=015

# Virtualenv Segment
POWERLEVEL9K_VIRTUALENV_BACKGROUND=green
POWERLEVEL9K_PYTHON_ICON="\uf81f"

# VCS Segment
POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''

# Segments Config
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir custom_aws custom_kubernetes custom_terraform virtualenv rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

##################
# Aliases Config #
##################

# Force zsh to autocomplete custom aliases
setopt COMPLETE_ALIASES

###########################
# Antigen Package Manager #
###########################

# Import antigen
source /usr/local/share/antigen/antigen.zsh

# Goto .antigenrc for antigen config
source ~/.antigenrc

############################
# Antibody Package Manager #
############################

# Import antibody
# source <(antibody init)
# antibody bundle < ~/.antibodyrc


########################
# asdf version manager #
########################

source /usr/local/opt/asdf/asdf.sh

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