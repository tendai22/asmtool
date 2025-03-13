#! /bin/sh
sed '
:loop
    s/ /\
/
    P
    s/^[^\n]*\n//
    / /b loop
' <<"EOF"
aaa bbb ccc
