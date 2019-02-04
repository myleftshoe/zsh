# vim:ft=zsh ts=2 sw=2 sts=2

# alias showprompt _showprompt=true
function showprompt() {
    _showprompt=true
}
# Arrays indexes in zsh start a 1!
# palette=("Blue" "Green" "Cyan" "Red" "Magenta" "Yellow" "Gray")
palette=("DarkBlue" "DarkGreen" "DarkCyan" "DarkRed" "DarkMagenta" "DarkYellow" "DarkGray")

let promptColor=1
dynamicPromptColor="on"
nextPromptColor() {
    if [ $promptColor -lt 1 -o $promptColor -ge $#palette ]
    then
        # array indexes start at 1!
        promptColor=1
    fi
    ((promptColor++))
}

# Runs before a command entered on the command line is executed
# Not run if no command entered
function preexec() {
    echo
    _timer=$(($(date +%s%N)/1000000))
}

# Runs before prompt is displayed
function precmd() {
    unset elapsed
    if [ $_timer ]
    then
        now=$(($(date +%s%N)/1000000))
        elapsed=$(($now-$_timer))
        unset _timer
    fi
    computeState
}


timer="on"
function set-timer() {
    if [[ $1 = "on" ]]
    then
        timer="on"
    fi
    if [[ $1 = "off" ]]
    then
        timer="off"
    fi
}

promptStateChanged=""
computeState() {
    
    
    # Default state. Will be overidden in code below
    typeset -Ag promptState
    promptState[pwdPath]=""
    promptState[isGit]=""
    promptState[gitBranch]="(none)"
    promptState[gitCommitCount]="0"
    promptState[gitStagedCount]="0"
    promptState[gitUnstagedCount]="0"
    promptState[gitRemoteCommitDiffCount]="0"
    promptState[gitRepoPath]=""
    promptState[gitRemoteUrl]=""
    promptState[elapsed]=""
    promptState[promptColor]="${prevPromptState[promptColor]}"
    # End default state
    
    promptState[pwdPath]="$PWD"
    
    isGit=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    promptState[isGit]="$isGit"
    if [[ -n $isGit ]]
    then
        
        # git_branch="(none)"
        promptState[gitBranch]="$(git symbolic-ref --short HEAD)"
        
        promptState[gitCommitCount]="$(git rev-list --all --count)"
        
        gitUnstagedCount=0
        gitStagedCount=0
        git status --porcelain | while IFS= read -r line
        do
            firstChar=${line:0:1}
            secondChar=${line:1:1}
            if [[ $firstChar != " " ]]
            then
                ((gitStagedCount++))
            fi
            if [[ $secondChar != " " ]]
            then
                ((gitUnstagedCount++))
            fi
            promptState[gitStagedCount]=$gitStagedCount;
            promptState[gitUnstagedCount]=$gitUnstagedCount;
            
        done
        
        promptState[gitRemoteCommitDiffCount]=$(git rev-list HEAD...origin/master --count 2> /dev/null)
        
        promptState[gitRepoPath]=$(git rev-parse --show-toplevel)
        
        promptState[gitRemoteUrl]=$(git remote get-url origin 2> /dev/null)
        
    fi #isGit
    
    # echo "0 ${prevPromptState[pwdPath]}"
    # echo "1 ${promptState[pwdPath]}"
    # echo "2 ${prevPromptState[gitRepoPath]}"
    # echo "3 ${promptState[gitRepoPath]}"
    # echo "4 ${prevPromptState[gitStagedCount]}"
    # echo "5 ${promptState[gitStagedCount]}"
    # echo "6 ${prevPromptState[gitUnstagedCount]}"
    # echo "7 ${promptState[gitUnstagedCount]}"
    # echo "8 ${prevPromptState[gitRemoteCommitDiffCount]}"
    # echo "9 ${promptState[gitRemoteCommitDiffCount]}"
    
    
    promptStateChanged=""
    if [[   -n $_showprompt ||
            "${prevPromptState[pwdPath]}" != "${promptState[pwdPath]}" ||
            "${prevPromptState[gitRepoPath]}" != "${promptState[gitRepoPath]}" ||
            "${prevPromptState[gitStagedCount]}" != "${promptState[gitStagedCount]}" ||
            "${prevPromptState[gitUnstagedCount]}" != "${promptState[gitUnstagedCount]}" ||
            "${prevPromptState[gitRemoteCommitDiffCount]}" != "${promptState[gitRemoteCommitDiffCount]}"
    ]]
    then
        promptStateChanged="true"
        if [[ $dynamicPromptColor = "on" ]]
        then
            nextPromptColor
        fi
        promptState[promptColor]=$palette[$promptColor]
    fi
    
    unset _showprompt
    
    typeset -Ag prevPromptState
    prevPromptState=("${(@fkv)promptState}")
    typeset prevPromptState
    
}

# computeState
