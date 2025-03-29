#! /bin/sh
sed '
# restore ===COMMA=== to '\'',
s/===COMMA===/'\'',/g
s/===SEMICOLON===/'\'';/g
# remove trailing : in EQU line
/|2 EQU /s/:\(  *|2 \)/\1/
# convert opcodes
s/|2 ORG /|2 .org /
s/|2 EQU /|2 .equ /
s/|2 DB /|2 .db /
s/|2 DW /|2 .dw /
s/|2 END /|2 .end /
' |tee x51.log |
sed '
# recover 
s/|[123] //g
s/|;/;/
'