#! /bin/sh

##########
# Warmup #
##########

echo "Running Setup Tasks"

# Copy dotfiles to home
echo "Copying Configuration files"
cp -av dotfiles/. ~/

##################
# Other Packages #
##################

# Update pip
pip3 install --upgrade pip setuptools

##########
# Mac OS #
##########



###############
# Shell Stuff #
###############

# Make ZSH default shell
if ! grep -Fxq "/usr/local/bin/zsh" /etc/shells
then
    echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
fi
chsh -s /usr/local/bin/zsh;
