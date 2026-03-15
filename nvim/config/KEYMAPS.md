# Neovim Keymaps & Navigation Guide

Leader key: `<Space>`

---

## Files & Navigation

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `<leader>o` | Reveal current file in explorer |
| `<leader>sf` | Find files (Telescope) |
| `<leader>sg` | Live grep across project |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Find open buffers |

---

## Buffers

| Key | Action |
|-----|--------|
| `<S-h>` / `<S-l>` | Cycle prev / next buffer |
| `<leader>1`–`9` | Jump to buffer by tab position |
| `<leader>bb` | Visual pick — hit the highlighted letter |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Close all other buffers |
| `<leader>bl` / `<leader>br` | Close all buffers left / right |

---

## Harpoon (hot files for a task)

Mark the 4–5 files you're actively working in. Instant teleport, no search.

| Key | Action |
|-----|--------|
| `<leader>m` | Mark current file |
| `<C-e>` | Open harpoon menu (edit / reorder marks) |
| `<C-1>` – `<C-4>` | Jump to marked file 1–4 |

---

## Splits

Use splits to see two files at once. Use buffers/harpoon for everything else.

| Key | Action |
|-----|--------|
| `<leader>\|` | Split vertical (side by side) |
| `<leader>-` | Split horizontal (top / bottom) |
| `<leader>w` | Close current split |
| `<leader>=` | Equalize split sizes |
| `<C-h/j/k/l>` | Move between splits |
| `<leader><Space>z` | Zoom current split (tmux: `prefix+z`) |

---

## In-file Movement

| Key | Action |
|-----|--------|
| `s` + 2 chars | Flash jump — anywhere visible on screen |
| `S` + 2 chars | Flash Treesitter — jump to syntax node |
| `<C-h/j/k/l>` | Move between splits |

---

## LSP

Requires a language server to be active (check `:Mason`).
Configured for: Go, TypeScript, Python, Rust, Lua.

| Key | Action |
|-----|--------|
| `grd` | Go to definition |
| `grD` | Go to declaration |
| `grr` | Go to references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>th` | Toggle inlay hints |

---

## Diagnostics (Trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Project-wide diagnostics |
| `<leader>xX` | Current buffer diagnostics |
| `<leader>xQ` | Quickfix list |
| `<leader>xL` | Location list |
| `<leader>q` | Diagnostic quickfix (native) |

---

## Search

| Key | Action |
|-----|--------|
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>ss` | Search Treesitter symbols |
| `<leader>sw` | Search word under cursor |
| `<leader>sd` | Search diagnostics |
| `<leader>sn` | Search Neovim config files |
| `<leader>/` | Fuzzy search current buffer |
| `<leader>s/` | Search across open files |
| `<Esc>` | Clear search highlight |

---

## Git

| Key | Action |
|-----|--------|
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this |
| `]h` / `[h` | Next / prev hunk |

---

## Editing

| Key | Action |
|-----|--------|
| `<leader>f` | Format file / selection |
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment selection |

---

## Themes

Switch with `<leader>tc` (live preview) or `:colorscheme <name>`.

| Name | Variants |
|------|----------|
| Rose Pine | `rose-pine`, `rose-pine-moon`, `rose-pine-dawn` |
| Catppuccin | `catppuccin-mocha`, `catppuccin-macchiato`, `catppuccin-latte` |
| Kanagawa | `kanagawa-wave`, `kanagawa-dragon`, `kanagawa-lotus` |
| Night Owl | `night-owl` |
| Ayu | `ayu-dark`, `ayu-mirage`, `ayu-light` |
| Moonlight | `moonlight` |
| Monokai Pro | `monokai-pro` (also: `monokai-pro-classic`, `monokai-pro-machine`, `monokai-pro-octagon`, `monokai-pro-ristretto`, `monokai-pro-spectrum`) |

---

## Plugin Management

| Command | Action |
|---------|--------|
| `:Lazy` | Plugin manager UI |
| `:Lazy sync` | Install / update plugins |
| `:Mason` | LSP / formatter installer |
| `:checkhealth` | Diagnose issues |
| `:TSUpdate` | Update Treesitter parsers |
