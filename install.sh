#!/bin/zsh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing dotfiles from $DOTFILES"

# ─── Homebrew ─────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "==> Installing Brewfile packages..."
brew bundle --file="$DOTFILES/Brewfile"

# ─── Oh My Zsh ────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ─── Symlinks ─────────────────────────────────────────────
echo "==> Symlinking configs..."

symlink() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "  backing up $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sf "$src" "$dst"
    echo "  linked $dst"
}

symlink "$DOTFILES/nvim/config"        "$HOME/.config/nvim"
symlink "$DOTFILES/tmux/tmux.conf"     "$HOME/.tmux.conf"
symlink "$DOTFILES/zellij/config.kdl"  "$HOME/.config/zellij/config.kdl"
symlink "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
symlink "$DOTFILES/zsh/.zshrc"         "$HOME/.zshrc"
symlink "$DOTFILES/zsh/aliases.sh"     "$HOME/.config/zsh/aliases.sh"

# ─── Secrets template ─────────────────────────────────────
if [ ! -f "$HOME/.zshrc.secrets" ]; then
    echo "==> Creating ~/.zshrc.secrets template..."
    cat > "$HOME/.zshrc.secrets" << 'EOF'
# ─── Secrets & machine-local config (not in repo) ─────────
export ANTHROPIC_API_KEY=""
export CLAUDE_CODE_OAUTH_TOKEN=""
export OPENROUTER_API_KEY=""

# ─── Work aliases ─────────────────────────────────────────

# ─── Work exports ─────────────────────────────────────────

# ─── Machine-local PATH additions ─────────────────────────
EOF
    echo "  created ~/.zshrc.secrets — fill in your secrets"
else
    echo "  ~/.zshrc.secrets already exists, skipping"
fi

# ─── Rust ─────────────────────────────────────────────────
if ! command -v cargo &>/dev/null; then
    echo "==> Installing Rust toolchain..."
    rustup-init -y
fi

# ─── Neovim Python venv (molten-nvim / Jupyter kernel) ─────
NVIM_VENV="$HOME/.venvs/nvim"
if [ ! -d "$NVIM_VENV" ]; then
    echo "==> Creating $NVIM_VENV..."
    uv venv --python 3.13 "$NVIM_VENV"
fi
echo "==> Syncing $NVIM_VENV packages..."
uv pip install --python "$NVIM_VENV/bin/python" -r "$DOTFILES/nvim/config/requirements.txt"
"$NVIM_VENV/bin/python" -m ipykernel install --user --name python3 --display-name "Python 3 (nvim)"

# ─── image.nvim magick rock ─────────────────────────────────
if [ ! -d "$HOME/.luarocks/lib/lua/5.1" ]; then
    echo "==> Building magick luarocks rock..."
    luarocks --local --lua-version=5.1 install magick
fi

echo ""
echo "==> Done! Restart your terminal or run: source ~/.zshrc"
