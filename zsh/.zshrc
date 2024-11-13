bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source ~/.env

source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(fnm env --use-on-cd --resolve-engines)"
eval "$(fzf --zsh)"

export FZF_CTRL_T_OPTS="
  --height 100%
  --walker-skip .git,node_modules,dist,build
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export EDITOR="nvim"
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

alias grh="git reset --hard @{u}"
alias vim=nvim
alias vi=nvim
alias ls=eza
alias f=fzf
alias c=pbcopy
alias k=kubectl

setopt prompt_subst
autoload -U compinit && compinit

PROMPT='%F{#c5adde}%~%f%F{#adcdde}%f # '

