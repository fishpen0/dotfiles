#! /bin/sh

echo "Running MacOs Tasks"

# Enable xcode clt
xcode-select --install

############
# Homebrew #
############

# Install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Disable Tracking
brew analytics off

# Setup mas
brew install mas

# Install brewfile
brew bundle 

# Install Iterm Tab Setter
npm install -g iterm2-tab-set

# Don't write DS_Store files to nfs volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Change default screenshot directory
defaults write com.apple.screencapture location ~/Documents/Screenshots
