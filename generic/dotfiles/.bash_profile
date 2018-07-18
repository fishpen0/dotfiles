# Use Gnuutils commands by default
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

###############
# iTerm setup #
###############

# load iterm integration
source ~/.iterm2_shell_integration.bash

###########
# Aliases #
###########


alias ll="ls -lah"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

###########
# History #
###########

# Keep a reasonably long history.
export HISTSIZE=4096;

# Keep even more history lines inside the file, so we can still look up
# previous commands without needlessly cluttering the current shell's history.
export HISTFILESIZE=16384;

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL=ignoredups;

# Keep track of the time the commands were executed.
# The xterm colour escapes require special care when piping; e.g. "| less -R".
export HISTTIMEFORMAT="${FG_BLUE}${FONT_BOLD}%Y-%m-%d %H:%M:%S${FONT_RESET}  ";

##############
# Completion #
##############

# Do not autocomplete when accidentally pressing Tab on an empty line. (It takes
# forever and yields "Display all 15 gazillion possibilites?")
shopt -s no_empty_cmd_completion;