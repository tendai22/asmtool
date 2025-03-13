#! /bin/sh
sed '#
#
# parser
#
# parse a source code to field-separated format
# as follows
# from:
#   LABEL:  MOV  A,B   ; some comments
# to:
#   |1 LABEL|2 MOV|3 A,B |; some comments
#
# field: |1

# CRLF to LF
s/\r$//

# parsing one assembly line
# comment
/^[ 	]*;/b	# comment line, skip processing
# label
/^[^ 	]/{		# label
	s/^\([^ 	][^ 	]*\)/|1 \1>>>\
/
	P
	s/^[^\n]*\n//
}
/^[ 	]*;/{
    s/^[ 	]*;/|2  >>>\
|3  >>>\
|;/
    b	# comment, skip processing
}
s/^[ 	][ 	]*//
# opcode
/^[^ 	]/{		# opcode
	s/^\([^ 	][^ 	]*\)/|2 \1>>>\
/
	P
	s/^[^\n]*\n//
}
/^[ 	]*;/{
    s/^[ 	]*;/|3 >>>\
|;/
    b	# comment, skip processing
}
s/^[ 	][ 	]*//
# oprand
s/^/|3 /
/[ 	]*;/{
	s/[ 	]*;/>>>\
|;/
}
s/>>>$//
' 