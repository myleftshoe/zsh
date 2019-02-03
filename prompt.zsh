# vim:ft=zsh ts=2 sw=2 sts=2


function preexec() {
  echo
  _timer=$(($(date +%s%N)/1000000))
}


promptColor=11
dynamicPromptColor="on"
nextPromptColor() {
    ((promptColor++))
    if [[ $promptColor -gt 15 ]]
    then
    	promptColor=1
	fi
}

function precmd() {
  if [[ $dynamicPromptColor = "on" ]]
  then
  	nextPromptColor
  fi
  unset elapsed
  if [ $_timer ]; then
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



computeState() {

    if [[ -n $promptState ]]
    then
        typeset -Ag prevPromptState
        prevPromptState=("${(@fkv)promptState}")
        typeset prevPromptState
    fi    

    typeset -Ag promptState
    promptState[pwdPath]=""
#   promptState[pwdLeaf]=""
#   promptState[pwdParentPath]=""
    promptState[isGit]=""
    promptState[gitBranch]="(none)"
    promptState[gitCommitCount]="0"
    promptState[gitStagedCount]="0"
    promptState[gitUnstagedCount]="0"
    promptState[gitRemoteDiffCount]="0"
    promptState[gitRepoPath]=""
#   promptState[gitRepoLeaf]=""
#   promptState[gitRemoteName]=""
    promptState[gitRemoteUrl]=""
    promptState[elapsed]=""
    

    # $bgBlue="$fgBlue"
    # $_tintColor="$bgDarkBlue"
    
    promptState[pwdPath]="$PWD"
    pwdLeaf=$(basename "$pwdPath")
    pwdParentPath=${pwdPath:a:h}
    
    is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    if [[ -n $is_git ]]
    then
        
        # git_branch="(none)"
        promptState[gitBranch]="$(git symbolic-ref --short HEAD)"
        
        #git_commitCount=0
        promptState[gitCommitCount]="$(git rev-list --all --count)"
        
        gitUnstagedCount=0
        gitStagedCount=0
        git status --porcelain | while IFS= read -r line
        do
            firstChar=${line:0:1}
            secondChar=${line:1:1}
            if [[ $firstChar != " " ]]
            then
                gitStagedCount++
            fi
            if [[ $secondChar != " " ]]
            then
                gitUnstagedCount++
            fi
            promptState[gitStagedCount]=gitStagedCount;
            promptState[gitUnstagedCount]=gitUnstagedCount;
            
        done
        
        promptState[gitRemoteCommitDiffCount]=$(git rev-list HEAD...origin/master --count 2> /dev/null)
        
        promptState[gitRepoPath]=$(git rev-parse --show-toplevel)
        promptState[gitRepoLeaf]=$(basename "$gitRepoPath")
        
        # gitRemoteName=""
        promptState[gitRemoteUrl]=$(git remote get-url origin 2> /dev/null)
        if [ -n "$gitRemoteUrl" ]
        then
            promptState[gitRemoteName]=${$(basename "$gitRemoteUrl"):r}
        fi
        
    fi #is_git
    
}

# computeState
