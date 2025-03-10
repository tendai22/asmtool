#! /bin/sh
cat "$@" |
sed '/^T /!d
s/^T \(..\) \(..\)/0x\2\1/
/^[0-9A-F][0-9A-F][0-9A-F][0-9A-F]$/d
s/ /\
 /g
' |awk '
$1 ~ /^0x/ {
    newaddr = strtonum($1)
    while (newaddr - addr > 0) {
        print " FF"
        addr += 1
    }
}
/^ /{
    print
    addr += 1
}
' |awk '{
    line = line " " $1
    addr += 1
    if (addr % 8 == 0) {
        printf "%04X%s\n", top, line
        line = ""
        top = addr
    }
}'