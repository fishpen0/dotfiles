#@IgnoreInspection BashAddShebang
zmodload zsh/zprof

################
# Path Changes #
################

if type brew &>/dev/null; then
# Use zsh-completions
    chmod -R go-w '/opt/homebrew/share'
    BREW_PREFIX=$(brew --prefix)
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit

    # Use brew coreutils
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

    # Use brew curl
    export PATH="$BREW_PREFIX/opt/curl/bin:$PATH"

    # Use brew findutils
    export PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"

    # Use brew grep
    export PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"

    # Use brew antidote
    source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
fi