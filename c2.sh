#! /bin/sh
cat "$@" |
sed '
#
# label formatter
#    force to append ":"
/^|1 /s/\([^:]\)>>>$/\1:>>>/
' |
sed '
#
# operant parser
# single- and double-quote string ('str', "str") are converted
# to separated DB opcode lines
#
# implementation idea:
# The marker, "|||" traverses among expressions, either 'c', "str", 
# or constants
#
/^|3 /!b
/^|3 $/b end
# operand line
    # preprocessing, escape ','
	s/'\'','\''/===COMMA===/g
    s/\([^>]\)[     ]*$/\1/
    s/\([^>]\)>>>$/\1>>>/
:loop
	#s/^/=/p
	#s/^=//
    /^[     ]*$/d
	/^|T  *$/b end
    # delimiter separation
    # word
	s/^\(|[3T] [  ]*[A-Za-z0-9_()][A-Za-z0-9_()]*[^A-Za-z0-9_()>]\)/\1>>>\
|T /
    # character constant
    s/^\(|[3T] [  ]*'\''.'\''[^A-Za-z0-9_>]\)/\1>>>\
|T /
    # ascii string
    s/^\(|3 [  ]*"[^"][^"]*"\),/\1\
|2 DB>>>\
|3 /
    s/^|T \([  ]*"[^"][^"]*"\),/|2 DB>>>\
|3 \1\
|2 DB>>>\
|3 /
    # delimter separation
    P
    s/^[^\n]*//
    s/^\n//
	b loop
:end
	s/|3 \([^, ]\)/|3  \1/
'
