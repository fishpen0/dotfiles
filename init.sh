#! /bin/sh

##########
# Warmup #
##########

echo "Running Setup Tasks"

# Copy dotfiles to home
echo "Copying Configuration files"
cp -av dotfiles/. ~/

# Enable xcode clt
if [ $(xcode-select -p) ] ; then
    echo "Skipping xcode installation.  Already Installed"
else
    echo "Installing xcode"
    xcode-select --install
fi

############
# Homebrew #
############

# Install
which -s brew
if [[ $? == 0 ]] ; then
    echo "Skipping Brew installation.  Already Installed"
else
    echo "Installing Brew"
    # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Disable Tracking
brew analytics off

# Setup cask for applications
brew tap caskroom/cask

# Setup mas for app store support
brew install mas

# Install Brewfile
brew bundle --file=~/Brewfile

# Done
brew upgrade
brew cleanup

##################
# Other Packages #
##################

# Update pip
pip install --upgrade pip setuptools

# Color ls
gem install colorls --user-install

# Lolcat
gem install lolcat --user-install

#########
# Iterm #
#########

# TODO: Copy Iterm Configs
# cp -r .iterm2/ ~/.iterm2/
# cp .iterm2_* ~/

# Install Iterm Tab Setter
npm install -g iterm2-tab-set

##########
# Mac OS #
##########

# Execute Mac OS configuration tasks
source ~/.macos

###############
# Shell Stuff #
###############

# Fix Bash to default to bash 4
if ! grep -Fxq "/usr/local/bin/bash" /etc/shells
then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
fi

# Make ZSH default shell
if ! grep -Fxq "/usr/local/bin/zsh" /etc/shells
then
    echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
fi
chsh -s /usr/local/bin/zsh;

# Install powerline fonts
echo "Installing powerline fonts"
unzip fonts/Inconsolata.zip -d /Library/Fonts

# Install oh-my-zsh
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Downloading latest iterm integration files for bash"
curl -sL https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

echo "Downloading latest iterm integration files for zsh"
curl -sL https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

###########
# crontab #
###########

echo "Installing crontab"
crontab ~/.cron

################
# Applications #
################

# visual-studio-code

## Install extensions
echo "Installing vscode extensions"
while IFS='' read -r extension || [[ -n "$extension" ]]; do
    code --install-extension $extension
done < "vscode/extensions"

# Steermouse

## Ensure System settings is killed, then copy settings over
osascript -e 'tell application "System Preferences" to quit'
cp steermouse/Device.smsetting ~/Library/Application\ Support/SteerMouse\ \&\ CursorSense/