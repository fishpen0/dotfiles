#@IgnoreInspection BashAddShebang

################
# Path Changes #
################

# Setup Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Use zsh-completions
chmod -R go-w '/usr/local/share/zsh'
autoload -Uz compinit
compinit

# Use brew coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Use brew curl
export PATH="/usr/local/opt/curl/bin:$PATH"

# Use brew findutils
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

# Use bre grep
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# Use brew sqlite
export PATH="/usr/local/opt/sqlite/bin:$PATH"

# Use brew unzip
export PATH="/usr/local/opt/unzip/bin:$PATH"

# Setup ruby path to point to --user-install path
if which ruby >/dev/null && which gem >/dev/null; then                                                                                                    127 ↵  4389  11:46:41
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

#######################
# Environment Changes #
#######################
export AWS_DEFAULT_PROFILE="default"

###############
# iTerm setup #
###############

# load iterm integration
source ~/.iterm2_shell_integration.zsh

#########################
# zplug package manager #
#########################

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

#############
# oh-my-zsh #
#############

# Path to your oh-my-zsh installation.
export ZSH="/Users/lstuart/.antigen/bundles/robbyrussell/oh-my-zsh/"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"

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

##################
# PowerLevel 10k #
##################

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
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
    context=$(kubectl config current-context | awk -F\. '{print $1}')
    namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    local color='%F{68}'
    echo -n "\ufd31 ${context} | ${namespace}"
  fi
}

zsh_randicon(){ 
  randicons=(
    "\uf1a8" # Pied Piper
    "\uf2cd" # Bathtub
    "\ue286" # Biohazard
    "\ue28d" # Bread
    "\ue28c" # Brain
    "\ue29f" # Chicken
    "\ue260" # king
    "\ue273" # donut
    "\ue24b" # intestines
    "\ue231" # poison
    "\ue238" # radioactive
    "\uf614" # hundo
    "\uf64e" # clippy
    "\uf6e4" # duck
    "\uf79f" # ghost
    "\ue36a" # meteor
    "\ue36e" # alien
    "\ue000" # japanese arch
    "\ue006" # palm tree
    "\uf483" #squirrel
    "\uf427" # rocket
    "\uf490" # fire
    "\uf499" # beaker
    "\uf7b3" # controller
    "\ufa2a" # traffic light
    "\ufa28" # tooth
    "\ufb67" # test tube
    "\ue219" # taco
    "\ue251" # hotdog
    "\ufb8a" # skull
    "\ufb08" # saxophone
    "\uf901" # pill
    "\uf872" # creeper
    "\uf855" # martini
    "\ufcd3" # lava lamp
    "\ue24d" # burger
    "\uf7a4" # glass flute
    "\uf7a5" # mug
    "\uf699" # cow
  )
  random=$(($[$$$(date +%s) % ${#randicons[@]}] + 1))
  echo -n "${randicons[$random]}"
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

# Random Icon Segment
POWERLEVEL9K_CUSTOM_RANDICON="zsh_randicon"
POWERLEVEL9K_CUSTOM_RANDICON_BACKGROUND=000
POWERLEVEL9K_CUSTOM_RANDICON_FOREGROUND=011

# Terraform Segment
POWERLEVEL9K_CUSTOM_TERRAFORM="zsh_terraform"
POWERLEVEL9K_CUSTOM_TERRAFORM_BACKGROUND=057
POWERLEVEL9K_CUSTOM_TERRAFORM_FOREGROUND=015

# Time Segment
POWERLEVEL9K_TIME_ICON=''

# Virtualenv Segment
POWERLEVEL9K_VIRTUALENV_BACKGROUND=green
POWERLEVEL9K_PYTHON_ICON="\uf81f"

# VCS Segment
POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''

# Segments Config
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_randicon dir custom_aws custom_kubernetes custom_terraform virtualenv rbenv vcs)
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