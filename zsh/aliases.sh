# ─── General ──────────────────────────────────────────────
alias src="source ~/.zshrc"
alias zshedit="cursor ~/.zshrc"
alias c="clear"
alias activate="source .venv/bin/activate"

# ─── Git ──────────────────────────────────────────────────
alias cpd="git cherry-pick \$(git log --oneline \$(gba | fzf) | fzf | cut -d' ' -f1)"
