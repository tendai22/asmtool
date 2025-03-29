#! /bin/sh
sed '
#
# conversion in expression
#
/|[3T] [^"]/{
	# set marker to the tail
	# restor escaped COMMA constant
	s/'\''COMMA'\''/'\'','\''/
	s/\(|[3T] ..*[^ ]\)  *|;/\1, |;/
	s/\(|[3T] ..*[^ ]\) *$/\1,/
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
	# convert current address $ -> .(period)
	s/\([^'\'']\)\$/\1./
	t ppp
	b
:ppp
	# remove marker
	s/\([^'\'']\), |;/\1 |;/
	s/\([^'\'']\),$/\1/
#	/|2 CP|/w/dev/tty
}
' |tee x33.log