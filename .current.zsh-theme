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
    # $bgPromptColor="$fgBlue"
    # $_tintColor="$bgDarkBlue"
    local promptColor="${promptState[promptColor]}"
    local _bgPromptColor="bg$promptColor"
    local bgPromptColor=${(P)_bgPromptColor}
    local _fgPromptColor="fg$promptColor"
    local fgPromptColor=${(P)_fgPromptColor}
    
    local tintColor="$promptColor"
    if [[ "$promptColor" = "$tintColor" ]]
    then
        if [[ "$promptColor" = "Dark"* ]]
        then
            tintColor="${promptColor#'Dark'}"
            
        else
            tintColor="Dark$promptColor"
        fi
    fi
    
    primaryTextColor=$fgWhite
    if [[ "$promptColor" != "Dark"* ]]
    then
        _primaryTextColor="fgWhite"
        primaryTextColor=${(P)_primaryTextColor}
    fi
    secondaryTextColor=$fgWhite
    if [[ "$tintColor" != "Dark"* ]]
    then
        _secondaryTextColor="fgBlack"
        secondaryTextColor=${(P)_secondaryTextColor}
    fi
    
    if [[ $timer = "on" ]]
    then
        echo
        prompt_time
    fi
    
    
    # Show minimal prompt if state has not changed
    if [[ -n $promptStateChanged ]]
    then
        _bgTintColor="bg$tintColor"
        local bgTintColor=${(P)_bgTintColor}
        _fgTintColor="fg$tintColor"
        local fgTintColor=${(P)_fgTintColor}
        
        tintTextColor=$fgPromptColor
        
        # pwdPath="$PWD"
        pwdPath=${promptState[pwdPath]}
        pwdLeaf=$(basename "$pwdPath")
        pwdParentPath=${pwdPath:a:h}
        
        # echo
        echo
        
        # isGit=$(git rev-parse --is-inside-work-tree 2> /dev/null)
        # if [[ -n $isGit ]]
        # then
        
        #     # gitBranch="(none)";
        #     # gitBranch="$(git symbolic-ref --short HEAD)"
        
        #     git_commitCount=0
        #     git_commitCount="$(git rev-list --all --count)"
        #     git_unstagedCount=0;
        #     git_stagedCount=0;
        
        #     git status --porcelain | while IFS= read -r line
        #     do
        #         firstChar=${line:0:1}
        #         secondChar=${line:1:1}
        #         if [[ $firstChar != " " ]]
        #         then
        #             (git_stagedCount++)
        #         fi
        #         if [[ $secondChar != " " ]]
        #         then
        #             (git_unstagedCount++)
        #         fi
        
        #     done
        
        #     git_remoteCommitDiffCount=$(git rev-list HEAD...origin/master --count 2> /dev/null)
        
        #     gitRepoPath=$(git rev-parse --show-toplevel)
        #     gitRepoLeaf=$(basename "$gitRepoPath")
        
        #     gitRemoteName=""
        #     gitRemoteUrl=$(git remote get-url origin 2> /dev/null)
        #     if [ -n "$gitRemoteUrl" ]
        #     then
        #         gitRemoteName=${$(basename "$gitRemoteUrl"):r}
        #     fi
        
        # fi #isGit
        
        
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
        # \u00a0 is a non-breaking space - needed to the line visible when window width changed
        # any non-visible char will work, or use any character with fg color set to bg.
        echo -n "$bgPromptColor\u00a0    $bgTintColor$nbs\u00a0"
        echo -n "$pad"
        echo "%k"
        
        # Line 1
        echo -n "$bgPromptColor$primaryTextColor  $folderIcon  $bgTintColor$secondaryTextColor  $pwdLeaf"
        if [[ "$pwdLeaf" != "$pwdPath" ]]
        then
            echo -n " $tintTextColor $pwdParentPath"
        fi
        echo -n "$pad"
        echo "%k%f"
        
        # Line 2
        if [[ -n "${promptState[isGit]}" ]]
        then
            
            gitBranch="${promptState[gitBranch]}"
            gitRepoPath="${promptState[gitRepoPath]}"
            gitRepoLeaf="$(basename "$gitRepoPath")"
            gitRemoteName="${promptState[gitRemoteName]}"
            gitStagedCount="${promptState[gitStagedCount]}"
            gitUnstagedCount="${promptState[gitUnstagedCount]}"
            gitRemoteCommitDiffCount="${promptState[gitRemoteCommitDiffCount]}"
            
            if [[ "$pwdPath" != "$gitRepoPath" ]]
            then
                echo -n "$bgPromptColor$primaryTextColor  $gitLogo  $bgTintColor$secondaryTextColor  $gitRepoLeaf"
                echo -n "$pad"
                echo "%k%f"
            fi
            
            echo -n "$bgPromptColor$primaryTextColor  $gitBranchIcon  $bgTintColor$secondaryTextColor  $gitBranch"
            
            if [[ "${promptState[gitCommitCount]}" -eq 0 ]]
            then
                echo -n " $tintTextColor(no commits)"
            fi
            
            green="$fgGreen"
            red="$fgRed"
            yellow="$fgYellow"
            
            if [[ $tintColor = "Green" ]]
            then
                green="$fgDarkGreen"
            fi
            if [[ $tintColor = "Red" ]]
            then
                red="$fgDarkRed"
            fi
            if [[ $tintColor = "Yellow" ]]
            then
                yellow="$fgDarkYellow"
            fi
            
            echo -n " $green$gitStagedCount"
            echo -n " $red$gitUnstagedCount"
            echo -n " $yellow$gitRemoteCommitDiffCount"
            echo -n "$pad"
            echo "%k%f"
            
            if [[ -n "$gitRemoteName" && ("$gitRemoteName" != "$gitRepoLeaf") ]]
            then
                echo -n "$bgPromptColor$primaryTextColor  $gitRemoteIcon $bgTintColor$secondaryTextColor  $gitRemoteName"
                echo -n "$pad"
                echo "%k%f"
            fi
        fi #isGit
        
        # Bottom Margin
        echo -n "$bgPromptColor\u00a0    $bgTintColor\u00a0"
        echo -n "$pad"
        echo "%k"
    fi
    
    echo
    echo "$fgPromptColor %f"
}

PROMPT='$(build_prompt) '
