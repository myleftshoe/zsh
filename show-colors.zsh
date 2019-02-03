show-colors() {
    for c ({0..15}) {
        print -P "${(l:2:)c} %K{$c}  %k"
    }
    echo
}
