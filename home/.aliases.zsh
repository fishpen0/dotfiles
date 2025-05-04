#@IgnoreInspection BashAddShebang

# Quick helper for reloading the ZSH config
alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"

# Quick helper for opening the current directory in VS Code
code() { command code "${@:-.}"; }

# Quick helper for opening the dotfiles directory in VS Code
alias dotfiles="code $HOME/dev/personal/dotfiles"


###########
# Network #
###########

# IP address helpers
publicip() { dig +short txt ch whoami.cloudflare @1.1.1.1 | tr -d '"'; }
localip() { ipconfig getifaddr en0; }

spoof(){
    local old_mac=$(ifconfig en0 | awk '/ether/ {print $2}')
    local new_mac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    sudo ifconfig en0 ether $new_mac
    echo "$old_mac => $new_mac"
}

unspoof() {
  if [[ -n $old_mac ]]; then
    sudo ifconfig en0 ether "$old_mac" && echo "MAC restored to: $old_mac"
  else
    echo "old_mac is not set. whoopsies"
  fi
}