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

# Setup cask for applications
brew tap caskroom/cask

# Setup mas for app store support
brew install mas

# Install Brewfile
brew bundle 

# Done
brew upgrade
brew cleanup
brew cask cleanup

#########
# Iterm #
#########

# Install Iterm Tab Setter
npm install -g iterm2-tab-set

##########
# Mac OS #
##########

# Don't write DS_Store files to nfs volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Change default screenshot directory
defaults write com.apple.screencapture location ~/Documents/Screenshots
