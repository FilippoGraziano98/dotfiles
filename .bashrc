#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

export TERM=xterm-256color
export EDITOR=vim
export PATH=$PATH:/home/gerald/scripts
export HISTCONTROL=erasedups:ignorespace
export HISTSIZE=10000 #in memory
export HISTSIZE=10000 #in file

bind '"\C-j": history-search-backward'
bind '"\C-k": history-search-forward'

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
bind -x '"\C-h": run-help' #Ctrl+h

PS1='$? [\[\e[32;1m\]\u\[\e[0m\]\[\e[33;1m\]@\h\[\e[0m\] \[\e[34;1m\]\W\[\e[0m\]]$ '
PS2=' > '

alias ls='ls --color=auto'
alias l='ls -la -h -tr --group-directories-first'

alias grep='grep --color=auto'

#colorized man [ttps://wiki.archlinux.org/index.php/Color_output_in_console#man]
man() {
    LESS_TERMCAP_md=$'\e[01;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;37m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;33m' \
    command man "$@"
}

alias ethernet='sudo ip link set enp2s0 up && sudo dhcpcd enp2s0'

alias ethvpn='sudo openconnect -u fgraziano@student-net.ethz.ch -g student-net -k ETHZ.STUDENT-NET.VPN sslvpn.ethz.ch'
alias leonhard='ssh -i ~/.ssh/eth_leonhard fgraziano@login.leonhard.ethz.ch'

xournal() {
	GTK_THEME=Adwaita:dark xournalpp "$@" &>/dev/null &
}

alias keypass="keepassxc-cli clip -k ~/.ssh/gerald_dbkey ~/gerald_keys.kdbx"
keyfn() {
	keepassxc-cli "$1" -k ~/.ssh/gerald_dbkey ~/gerald_keys.kdbx "${@:2}"
}

ida32() {
	wine ~/.wine/drive_c/Program\ Files/IDA\ 7.0/ida.exe "$@" &>/dev/null &
}

ida64() {
	wine ~/.wine/drive_c/Program\ Files/IDA\ 7.0/ida64.exe "$@" &>/dev/null &
}

alias pwn='source ~/VirtualEnv/pwn/bin/activate'
alias ml='source ~/VirtualEnv/ml/bin/activate'

