#! /bin/sh
( cat xx.log |
sed '
#
# recompile lines
#
/|3  [^"]/{
	# need to convert each of the terms
	# so markers like operands([+-*/]) are needed 
	# as pre-delimiter(\([-+\*\/ ]\)) in the regexp
	# 
	# convert '012ABH' to '0x12AB'
	s/\([-+\*\/ ]\)\([01][01]*\)[Bb]/\10b\2/g
	s/\([-+\*\/ ]\)\([0-9A-Fa-f][0-9A-Fa-f]*\)[Hh]/\10x\2/g
	# single character constant
	s/\([-+\*\/ ]\)\('\'' '\''\)\([ 	+*/,->]\)/0x20\1/
	s/\([-+\*\/ ]\)\('\''.\)'\''\([ 	+*/,->]\)/\1\2\3/
	s/\([-+\*\/ ]\)\('\'' '\''\)$/\10x20 /g
	s/\([-+\*\/ ]\)\('\''.\)'\''$/\1\2 /g
	s/\([-+\*\/ ]\)\('\'' '\''\)>/\10x20 >/
	s/\([-+\*\/ ]\)\('\''.\)'\''>/\1\2 >/
	t ppp
	b
:ppp
#	/|2 CP|/w/dev/tty
}
' x2.log |tee x3.log |
sed '
# reconstruct lines
:loop
/>>>$/!{
    s/>>>\n/ /g
	# compile one line
	/^[ 	]*;/b
	/^|1 /!s/^/|1 /
    b
}
N
b loop
' |
sed '
# adaptation for asxxxx format
'
)>x4.log
