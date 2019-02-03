# vim:ft=zsh ts=2 sw=2 sts=2

# Icons
folderIcon=""
gitLogo=""
gitBranchIcon=""
gitRemoteIcon="肋"

# Colors (VT100 escape sequences)
fgBlack="%{\e[30m%}";
fgDarkBlue="%{\e[34m%}";
fgDarkGreen="%{\e[32m%}";
fgDarkCyan="%{\e[36m%}";
fgDarkRed="%{\e[31m%}";
fgDarkMagenta="%{\e[35m%}";
fgDarkYellow="%{\e[33m%}";
fgGray="%{\e[37m%}";
#fgExtended="%{\e[38m%}";
#fgDefault="%{\e[39m%}";
fgDarkGray="%{\e[90m%}";
fgBlue="%{\e[94m%}";
fgGreen="%{\e[92m%}";
fgCyan="%{\e[96m%}";
fgRed="%{\e[91m%}";
fgMagenta="%{\e[95m%}";
fgYellow="%{\e[93m%}";
fgWhite="%{\e[97m%}";

bgBlack="%{\e[40m%}";
bgDarkBlue="%{\e[44m%}";
bgDarkGreen="%{\e[42m%}";
bgDarkCyan="%{\e[46m%}";
bgDarkRed="%{\e[41m%}";
bgDarkMagenta="%{\e[45m%}";
bgDarkYellow="%{\e[43m%}";
bgGray="%{\e[47m%}";
#bgExtended="%{\e[38m%}";
#bgDefault="%{\e[39m%}";
bgDarkGray="%{\e[100m%}";
bgBlue="%{\e[104m%}";
bgGreen="%{\e[102m%}";
bgCyan="%{\e[106m%}";
bgRed="%{\e[101m%}";
bgMagenta="%{\e[105m%}";
bgYellow="%{\e[103m%}";
bgWhite="%{\e[107m%}";

pad="%{\e[400@%}"


prompt_time() {
    #    echo -n "     %F{11}%f "
    echo -n "%F{8}%D{%H:%M:%S}%f"
    # elapsed is set in .zshrc precmd()
    if [[ -n $elapsed ]]
    then
        echo -n " ($elapsed ms)"
    fi
    echo
}



WriteLinePadded() {
    echo -n "$*"
    echo "%{\e[400@%}"
    echo "%{\e[0m%}"
}

## Main prompt
build_prompt() {
    # $bgBlue="$fgBlue"
    # $_tintColor="$bgDarkBlue"
    
    pwdPath="$PWD"
    pwdLeaf=$(basename "$pwdPath")
    pwdParentPath=${pwdPath:a:h}
    
    if [[ -n $elapsed ]]
    then
        echo
    fi
    if [[ $timer = "on" ]]
    then
        prompt_time
    fi
    
    #
    # Populate vars
    #
    
    
    
    is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    if [[ -n $is_git ]]
    then
        
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
                (git_stagedCount++)
            fi
            if [[ $secondChar != " " ]]
            then
                (git_unstagedCount++)
            fi
            
        done
        
        git_remoteCommitDiffCount=$(git rev-list HEAD...origin/master --count 2> /dev/null)
        
        gitRepoPath=$(git rev-parse --show-toplevel)
        gitRepoLeaf=$(basename "$gitRepoPath")
        
        gitRemoteName=""
        gitRemoteUrl=$(git remote get-url origin 2> /dev/null)
        if [ -n "$gitRemoteUrl" ]
        then
            gitRemoteName=${$(basename "$gitRemoteUrl"):r}
        fi
        
    fi #is_git
    
    
    #
    # Draw prompt
    #
    
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
    
    # Top Margin
    echo -n "$bgBlue     $bgCyan"
    echo -n "$pad"
    echo "%k"
    
    # Line 1
    echo -n "$bgBlue  $folderIcon  $bgCyan $pwdLeaf"
    if [[ "$pwdLeaf" != "$pwdPath" ]]
    then
        echo -n " $fgDarkGray $pwdParentPath"
    fi
    echo -n "$pad"
    echo "%k%f"
    
    # Line 2
    if [[ -n $is_git ]]
    then
        
        if [[ "$pwdPath" != "$gitRepoPath" ]]
        then
            echo -n "$bgBlue  $gitLogo  $bgCyan $gitRepoLeaf"
            echo -n "$pad"
            echo "%k%f"
        fi
        
        echo -n "$bgBlue  $gitBranchIcon  $bgCyan $git_branch"
        
        if [[ $git_commitCount -eq 0 ]]
        then
            echo -n " $fgDarkGray(no commits)"
        fi
        echo -n " $fgGreen$git_stagedCount"
        echo -n " $fgRed$git_unstagedCount"
        echo -n " $fgYellow$git_remoteCommitDiffCount"
        echo -n "$pad"
        echo "%k%f"
        
        if [[ -n "$gitRemoteName" && ("$gitRemoteName" != "$gitRepoLeaf") ]]
        then
            echo -n "$bgBlue  $gitRemoteIcon $bgCyan $gitRemoteName"
            echo -n "$pad"
            echo "%k%f"
        fi
    fi #is_git
    
    # Bottom Margin
    echo -n "$bgBlue     $bgCyan"
    echo -n "$pad"
    echo "%k"
    
    echo "%F{$fgBlue} %f"
}

PROMPT='$(build_prompt) '
