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

#########
# Iterm #
#########

# Copy Iterm Configs
cp -r .iterm2/ ~/.iterm2/
cp .iterm2_* ~/

# Install Iterm Tab Setter
npm install -g iterm2-tab-set

##########
# Mac OS #
##########

# Don't write DS_Store files to nfs volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Change default screenshot directory
mkdir ~/Documents/Screenshots
defaults write com.apple.screencapture location ~/Documents/Screenshots
killall SystemUIServer

###############
# Shell Stuff #
###############

# Suppress osx motd
touch ~/.hushlogin

# Fix Bash to default to bash 4
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
chsh -s /usr/local/bin/bash;

# Install powerline fonts
unzip ../fonts/Inconsolata.zip -d /Library/Fonts

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Downloading latest iterm integration files for bash"
curl -sL https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

echo "Downloading latest iterm integration files for zsh"
curl -sL https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

######################
# Visual-studio-code #
######################

# Install extensions
while IFS='' read -r line || [[ -n "$extension" ]]; do
    code --install-extension $extension
done < "../generic/vscode/extensions"
