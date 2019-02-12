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


# prompt_time() {
#     echo -n "%F{8}%D{%H:%M:%S}%f"
#     # elapsed is set in prompt.zsh function precmd()
#     if [[ -n $elapsed ]]
#     then
#         echo -n " ($elapsed ms)"
#     fi
#     echo
# }

## Main prompt
build_prompt() {
    
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
    
    local primaryTextColor=$fgWhite
    if [[ "$promptColor" != "Dark"* ]]
    then
        local _primaryTextColor="fgBlack"
        primaryTextColor=${(P)_primaryTextColor}
    fi
    
    local secondaryTextColor=$fgWhite
    if [[ "$tintColor" != "Dark"* ]]
    then
        local _secondaryTextColor="fgBlack"
        secondaryTextColor=${(P)_secondaryTextColor}
    fi
    
    # if [[ $timer = "on" ]]
    # then
    #     echo
    #     prompt_time
    # fi
    
    
    # Show minimal prompt if state has not changed
    if [[ -n $promptStateChanged ]]
    then
        _bgTintColor="bg$tintColor"
        local bgTintColor=${(P)_bgTintColor}
        _fgTintColor="fg$tintColor"
        local fgTintColor=${(P)_fgTintColor}
        
        tintTextColor=$fgPromptColor
        # tintTextColor=$fgBlack
        
        pwdPath=${promptState[pwdPath]}
        pwdLeaf=$(basename "$pwdPath")
        pwdParentPath=${pwdPath:a:h}
        
        echo
        
        #
        # Draw prompt
        #
        if [[ "$pwdPath" = "$HOME" ]]
        then
            if [[ "$pwdPath" = "$_HOME" ]]
            then
                # folderIcon="≋"
                folderIcon="ﲋ"
            else
                # folderIcon="~"
                folderIcon="ﰣ"
            fi
        elif [[ "$pwdPath" = "$_HOME" ]]
        then
            folderIcon="≈"
        fi
        
        # Top Margin
        # \u00a0 is a non-breaking space - keeps line visible when window width changed -
        # any non-visible char will work, or use any character with fg color set to bg.
        echo -n "$bgPromptColor\u00a0    $bgTintColor$nbs\u00a0"
        echo -n "$pad"
        echo "%k"
        
        # Line 1
        echo -n "$bgPromptColor$primaryTextColor  $folderIcon  $bgTintColor$secondaryTextColor  $pwdLeaf"
        if [[ "$pwdLeaf" != "$pwdPath" ]]
        then
            echo -n " $tintTextColor""in $pwdParentPath"
        fi
        echo -n "$pad"
        echo "%k%f"
        
        # Line 2
        if [[ -n "${promptState[isGit]}" ]]
        then
            
            gitBranch="${promptState[gitBranch]}"
            gitRepoPath="${promptState[gitRepoPath]}"
            gitRepoLeaf="$(basename "$gitRepoPath")"
            gitRemoteUrl="${promptState[gitRemoteUrl]}"
            if [ -n "$gitRemoteUrl" ]
            then
                gitRemoteName=${$(basename "$gitRemoteUrl"):r}
            fi
            gitStagedCount="${promptState[gitStagedCount]}"
            gitUnstagedCount="${promptState[gitUnstagedCount]}"
            gitRemoteCommitDiffCount="${promptState[gitRemoteCommitDiffCount]}"
            
            if [[ "$pwdPath" != "$gitRepoPath" ]]
            then
                echo -n "$bgPromptColor$primaryTextColor  $gitLogo  $bgTintColor$secondaryTextColor  $gitRepoLeaf"
                echo -n "$pad"
                echo "%k%f"
            fi
            
            # Line 3
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
            
            # Line 4
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
    fi #isGit
    
    echo
    echo "$fgPromptColor ❱❱❱%f"
    
}

PROMPT='$(build_prompt) '
