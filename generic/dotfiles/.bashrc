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

source ~/.bash_profile;