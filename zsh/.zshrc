bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down

#source ~/personal/zsh-history-substring-search/zsh-history-substring-search.zsh
#source ~/personal/zsh-autosuggestions/zsh-autosuggestions.zsh
#source $HOME/.npmcompletion

#eval $(/opt/homebrew/bin/brew shellenv)
#eval "$(fnm env --use-on-cd --resolve-engines)"
eval "$(fzf --zsh)"

export FZF_CTRL_T_OPTS="
  --height 100%
  --walker-skip .git,node_modules,dist,build
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

alias grh="git reset --hard @{u}"
alias vim=nvim
alias vi=nvim
alias ls=eza
alias f=fzf
alias c=pbcopy
alias k=kubectl

# bun completions
#[ -s "/Users/liamdebell/.bun/_bun" ] && source "/Users/liamdebell/.bun/_bun"

# bun
#export BUN_INSTALL="$HOME/.bun"
#export PATH="$BUN_INSTALL/bin:$PATH"

# go
#export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# pnpm
#export PNPM_HOME="/Users/liamdebell/Library/pnpm"
#case ":$PATH:" in
#  *":$PNPM_HOME:"*) ;;
#  *) export PATH="$PNPM_HOME:$PATH" ;;
#esac
# pnpm end

# bun-cli-scripts
#export PATH="$HOME/personal/liams-toolbox/bin:$PATH"

setopt prompt_subst

PROMPT='%F{#c5adde}%~%f%F{#adcdde}%f # '

#autoload -U +X bashcompinit && bashcompinit
#complete -o nospace -C /opt/homebrew/bin/terraform terraform
#. "/Users/liamdebell/.deno/env"

#export KUBECONFIG=~/.kube/ol-cluster.conf
