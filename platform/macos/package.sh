# Resolve this script's directory, even if sourced
this_script="${BASH_SOURCE[0]:-${(%):-%x}}"
script_dir="$(cd "$(dirname "$this_script")" && pwd)"

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
brew analytics off # Disable Tracking
brew install mas --quiet # App Store
brew install whalebrew --quiet # Containerized packages
brew bundle --file="$script_dir/Brewfile"
brew upgrade
brew cleanup

# Execute macos-specific configuration tasks
source "$script_dir/.macos"

# Make all terminals use the brew version of zsh
# TODO: make this work on one loop
sudo sh -c 'echo /opt/homebrew/bin/zsh >> /etc/shells'
chsh -s /opt/homebrew/bin/zsh