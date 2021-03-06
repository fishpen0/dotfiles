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
pip3 install --upgrade pip setuptools

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

# Make ZSH default shell
if ! grep -Fxq "/usr/local/bin/zsh" /etc/shells
then
    echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
fi
chsh -s /usr/local/bin/zsh;

echo "Downloading latest iterm integration files for bash"
curl -sL https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

echo "Downloading latest iterm integration files for zsh"
curl -sL https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

###########
# crontab #
###########

# echo "Installing crontab"
# crontab ~/.cron