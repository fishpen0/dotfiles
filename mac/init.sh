#! /bin/sh

# Enable xcode clt
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Setup mas
brew install mas

# Install brewfile
brew bundle 

# Don't write DS_Store files to nfs volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
