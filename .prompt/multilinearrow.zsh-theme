# vim:ft=zsh ts=2 sw=2 sts=2


# prompt_time() {
#     #  echo -n "   %F{11}%f "
#     echo -n "%F{8}%D{%H:%M:%S}%f"
#     # elapsed is set in .zshrc precmd()
#     if [[ $elapsed ]]
#     then
#         echo -n " ($elapsed ms)"
#     fi
#     echo
# }

## Main prompt
build_prompt() {
    
    pwdPath="$PWD"
    pwdLeaf=$(basename $pwdPath)
    pwdParentPath=${pwdPath:a:h}
    
    # if [[ $elapsed ]]
    # then
    #     echo
    # fi
    # if [[ $timer = "on" ]]
    # then
    #     prompt_time
    # fi
    echo
    
    folderIcon=""
    if [[ "$pwdPath" = "$HOME" ]]
    then
        if [[ "$pwdPath" = "$_HOME" ]]
        then
            folderIcon="≋"
        else
            folderIcon="~"
        fi
    elif [[ "$pwdPath" = "$_HOME" ]]
    then
        folderIcon="≈"
    fi
    
    # Line 1
    echo -n "%F{$promptColor}┏━ $folderIcon%f"
    echo -n " $pwdLeaf"
    if [[ "$pwdLeaf" != "$pwdPath" ]] {
        echo -n " %F{8} $pwdParentPath%f"
    }
    
    echo
    
    # Line 2
    is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    if [[ $is_git ]]
    then
        
        echo -n "%F{$promptColor}┃%f "
        
        gitLogo=""
        gitBranchIcon=""
        
        git_branch="(none)";
        git_branch="$(git symbolic-ref --short HEAD)"
        
        git_commitCount=0
        git_commitCount="$(git rev-list --all --count)"
        
        git_unstagedCount=0;
        git_stagedCount=0;
        git status --porcelain | while IFS= read -r line
        do
            firstChar=${line:0:1}
            secondChar=${line:1:1}
            if [[ $firstChar != " " ]]
            then
                ((git_stagedCount++))
            fi
            if [[ $secondChar != " " ]]
            then
                ((git_unstagedCount++))
            fi
            
        done
        
        git_remoteCommitDiffCount=$(git rev-list HEAD...origin/master --count 2> /dev/null)
        
        gitRepoPath=$(git rev-parse --show-toplevel)
        gitRepoLeaf=$(basename $gitRepoPath)
        
        gitRemoteName=""
        gitRemoteUrl=$(git remote get-url origin 2> /dev/null)
        if [ $gitRemoteUrl ]
        then
            gitRemoteName=${$(basename $gitRemoteUrl):r}
        fi
        
        if [[ "$pwdPath" != "$gitRepoPath" ]]
        then
            echo -n " %F{11}$gitLogo%f "
            echo -n "$gitRepoLeaf"
        fi
        
        echo -n " %F{11}$gitBranchIcon%f"
        echo -n " $git_branch"
        if [[ $git_commitCount -eq 0 ]]
        then
            echo -n " %F{8}(no commits)%f"
        fi
        echo -n " %F{green}$git_stagedCount"
        echo -n " %F{red}$git_unstagedCount"
        echo -n " %F{11}$git_remoteCommitDiffCount"
        
        if [[ "$gitRemoteName" && ("$gitRemoteName" != "$gitRepoLeaf") ]]
        then
            echo -n " %F{11}肋%f"
            echo -n "$gitRemoteName"
        fi
        echo
    fi #is_git
    
    echo "%F{$promptColor}┗%f"
    
}

PROMPT='$(build_prompt) '