#! /bin/sh
cat "$@" |
sed '/^   .... [0-9A-Fa-f]/!d
    s/^   //
    s/^\(...................\)\[..\]  *\([0-9][0-9]*\) /|\2 \1 /
' |sed '
# continuous line
/^|/!{
:loop
    N
    /\n /!{
        P
        s/[^\n]*\n//
        b loop
    }
    s/\n/>>>/
    $b
    b loop
}'