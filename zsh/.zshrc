export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git docker)

source $ZSH/oh-my-zsh.sh

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"

# ─── Personal Aliases ─────────────────────────────────────
source ~/.config/zsh/aliases.sh

# ─── Secrets & machine-local config (not in repo) ─────────
[ -f ~/.zshrc.secrets ] && source ~/.zshrc.secrets

# ─── NVM ──────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ─── Docker CLI completions ───────────────────────────────
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

# ─── Go ───────────────────────────────────────────────────
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/go/bin:$PATH"

# ─── Cargo (Rust) ─────────────────────────────────────────
export PATH="$HOME/.cargo/bin:$PATH"
