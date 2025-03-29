#! /bin/sh
# erase unwanted '> >>>$'
sed '
s/> >>>$/ >>>/
' |
sed '
# reconstruct lines
:loop
/>>>$/!{
    /> *$/{
        #s/^/==/p
        #s/==//
        s/> $//
        N
        b loop
    }
    s/>>>\n/ /g
	# compile one line
	/^[ 	]*;/b
	/^|1 /!s/^/|1 /
    b
}
:continue
N
# string separation
# |3 {...},>>>\n|T "{string}" -> |3 {...}\n|1 |2 DB|3 "{string}"
s/\(|[3T] [^>, ]*\),>>>\n\(|[2T] "\)/\1\
|1 \2/g
s/|1 |T "/|1 |2 DB |3 "/
b loop
' |tee x41.log |
# postprocessing, separage .ascii primitives
sed '
s/\(|3 [^|]*\)\(|2 \)/\1\
|1 \2/
s/^|1 |T /|1 |2 DB |3 /
s/|2 DB |3  *"/|2 .ascii |3 "/
s/,  |T  "/\
|2 .ascii |3  "/
s/",  |T  \([^"]\)/"\
|2 DB |3 \1/
' |tee x42.log |
# now line construction completed
# remove inserted separators
sed '
# some final adjusting, erase trailing comma
s/^|2 /|1   |2 /
s/\(|3 .*\),\( |;\)/\1\2/
s/\(|3 .*\), *$/\1/

# fill columns with spaces
s/|1 |2/|1        |2/
s/|1 \(.*\) |2/|1 \1         |2/
s/|2 \(.*\) |3/|2 \1               |3/
s/[     ]*|T/|T/g
s/|T[   ]*|/ |/g
s/|T[   ]*//g
s/|3 \(.*\) |;/|3 \1                  |;/
#s/|3 \(.*\)$/|3 \1/

s/|1 \(........\)  *|2/|1 \1|2/
s/|2 \(.........\)  *|3/|2 \1 |3/
s/|3 \(..........\)   *|;/|3 \1 |;/
'