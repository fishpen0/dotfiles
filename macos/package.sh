# Enable xcode command line tools - required for most other tools
if [ $(xcode-select -p) ] ; then
    echo "Skipping xcode installation.  Already Installed"
else
    echo "Installing xcode"
    xcode-select --install
fi

# Install Homebrew
which -s brew
if [[ $(command -v brew) == "" ]] ; then
    echo "Skipping Brew installation.  Already Installed"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew"
    brew update
fi

# Install Packages
brew bundle