#! /bin/sh
( sed '
#
# recompile lines
#
/|3  [^"]/{
	# convert '012ABH' to '0x12AB'
	s/\([ +*/,-]\)\([0-9A-Fa-f][0-9A-Fa-f]*\)[Hh]\([ +*/,->]\)/\10x\2\3/g
	s/\([ +*/,-]\)\([01][01]*\)[Bb]\([ +*/,->]\)/\10b\2\3/g
	# single character constant
	s/\([ +*/,-]\)\('\'' '\''\)\([ 	+*/,->]\)/\10x20\3/g
	s/\([ +*/,-]\)\('\''.\)'\''\([ 	+*/,->]\)/\1\2\3/g
	s/\([ +*/,-]\)\('\'' '\''\)$/\10x20 /g
	s/\([ +*/,-]\)\('\''.\)'\''$/\1\2 /g
	s/\([ +*/,-]\)\('\'' '\''\)>/\10x20 >/
	s/\([ +*/,-]\)\('\''.\)'\''>/\1\2 >/
	t ppp
	b
:ppp
#	/|2 CP|/w/dev/tty
}
' x2.log |
sed '
# reconstruct lines
:loop
/>>>$/!{
    s/>>>\n/ /g
    b
}
N
b loop
' |
sed '
# adaptation for asxxxx format
'
)>x3.log
