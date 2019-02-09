$SHELL --version
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# uncomment this and change ls alias to something else e.g to use prezto success
# # Source Prezto.
# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#     source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi

# Customize to your needs...
alias drives="df | grep -o '^.:'"

# Create windows drive aliases e.g. c: x: m:
drives | while read -r line
do
    driveLetter=${line:0:1:l}
    alias $driveLetter:="cd /mnt/$driveLetter"
done


export DEV="/mnt/x"
export ZHOME="/mnt/x/zsh"
alias ~~='cd $_HOME'
alias zh="cd $ZHOME"
alias dev="cd $DEV"
alias rel="cd $DEV/releases"
alias react="cd $DEV/react"
alias sysinfo="clear; neofetch --block_range 0 15"
alias gs="git status"
export SCRIPTS="$ZHOME"
alias scripts="cd $SCRIPTS"
alias pp="showprompt"
alias ton="set-timer on"
alias toff="set-timer off"

# Set Start Dir - command prompt will show paths relative to this
set~~() {
    _HOME=$PWD
    echo
    echo Start folder set to $_HOME
    echo
}
alias get~~='echo "\n $_HOME"'

source $ZHOME/show-colors.zsh
#replace ls to not show windows hidden files
ls() {
    if test "${PWD##/mnt/}" != "${PWD}"; then
        cmd.exe /D /A /C 'dir /B /AH 2> nul' \
        | sed 's/^/-I/' | tr -d '\r' | tr '\n' '\0' \
        | xargs -0 /bin/ls "$@"
    else
        /bin/ls "$@"
    fi
}

# z - for jumping around folders
source ~/z.sh

source $ZHOME/.ohmy.zsh
source $ZHOME/.prompt/.prompt.zsh
source $ZHOME/.prompt/panel.zsh-theme

export PATH=$PATH:$HOME/Library/Python/2.7/bin

set~~

export GO="$DEV/.go"
alias go="noglob _go"
function _go() {
    if [[ -n $1 ]] {
        m="$GO/$1"
        paths=(${~m})
        target=$(readlink ${paths[1]})
        cd $target
        return
    }
    cd $GO
    ls
}


#[ "$PWD" = "$HOME" ] && neofetch
