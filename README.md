# dotfiles

Personal development environment for macOS.

## What's included

- **nvim** — Kickstart.nvim with LSP, Telescope, Harpoon, Trouble, and more
- **tmux** — Prefix on `C-Space`, vim-style pane navigation, clean status bar
- **starship** — Cross-shell prompt with nerd font icons
- **zsh** — Oh My Zsh with personal aliases
- **Brewfile** — All Homebrew dependencies

## Install

```bash
git clone git@github.com-personal:GarrettKucinski/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles
./install.sh
```

The install script will:
1. Install Homebrew if missing
2. Install all packages from the Brewfile
3. Install Oh My Zsh if missing
4. Symlink all configs to their expected locations
5. Create a `~/.zshrc.secrets` template for secrets and machine-local config

## Secrets

Anything sensitive (API keys, work aliases, machine-specific paths) lives in `~/.zshrc.secrets` which is never committed. The install script creates a blank template on first run.

## Neovim keymaps

| Key | Action |
|-----|--------|
| `;d` | Save file |
| `;m` | Add file to Harpoon |
| `;p` | Open Harpoon picker |
| `;j1-4` | Jump to Harpoon file 1-4 |
| `;e` | Toggle file explorer |
| `;sg` | Live grep |
| `;sf` | Find files |
| `;xx` | Toggle Trouble diagnostics |
| `gl` | Show diagnostic float |
| `gcc` | Toggle comment |
| `K` | Hover docs |
