ZSH_THEME="miloshadzic"

export LANG=en_US.UTF-8
export TERM="xterm-256color"
export EDITOR=/usr/local/bin/zile

alias lrs='ls -lrt'
alias python='/usr/local/bin/python3'
alias k='kubectl'
alias kubeblacklist='kubectl -n kube-system edit cm kube-applier'
source <(kubectl completion bash)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc
