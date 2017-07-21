

fd() {
    local dir
    dir=$(find . -path "*/\.*" -type d -prune -o -type d \
        2> /dev/null \
        | sed "s,^./,," \
        | grep -v "/\." \
        | grep -v "^\." \
        | fzf)

    cd "$dir"
}
