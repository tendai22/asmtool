#! /bin/sh
cat "$@" |
sed '
    # keep only binary data lines
    /^   .... [0-9A-Fa-f]/!d
    # cut unnecessary tails
    s/\[.*$//
    # 28chars need to be kept
    s/^\(...........................\).*$/\1/
    # cut tail of spaces
    s/  *$//
    # cut head 3 spaces
    s/^   //
' |tee l1.log |
sed 's/^\([0-9A-Fa-f]\)/=\1/
    s/  */ /
    s/ /\
/g
' |sed '/^ *$/d'