export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export EDITOR="nvim"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git docker)

source $ZSH/oh-my-zsh.sh

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"

unalias gc 2>/dev/null

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

# ─── Vim mode ─────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward
bindkey '^?' backward-delete-char

# ─── Ollama ─────────────────────────────────────────────
export OLLAMA_NUM_PARALLEL=4
export OLLAMA_KEEP_ALIVE=-1

# ─── Neovim / image.nvim ──────────────────────────────────
# image.nvim's "magick" luarocks rock links against Homebrew's libMagickWand at
# runtime; it's not on the default dyld search path on macOS, so it has to be
# pointed at explicitly here (setting it from inside init.lua is too late for dyld).
export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# ─── vLLM ──────────────────────────────────
#
alias vllmenv="source /Users/garrettkucinski/.venv-vllm-metal/bin/activate"
