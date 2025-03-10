        .area   TEST (ABS)
;	EMUBASIC based on GRANT's BASIC
;	TARGET: EMUZ80
;	ASSEMBLER: ARCPIT XZ80.EXE
;
;	START UP ROUTINE
;	VERSION 1.0, 2022/02/15
;	WRITTEN by TETSUYA SUZUKI
;
;	MEMORY ASIGN
ROMTOP  .equ    0x0000
RAMTOP  .equ    0x8000
RAMSIZ  .equ    0x1000
TSTACK  .equ    0x80ED
;
;	UART REGISTER ADDRESS
UARTDR  .equ    0x0E000                       ; UART DATA REGISTOR
UARTCR  .equ    0x0E001                       ; UART CONTROL REGISTOR
;
;	RESET (RST 00H)
        .org    ROMTOP
        DI
        LD      SP,TSTACK
        JP      SINIT
;
;	PUT 1CHAR (RST 08H)
        .org    ROMTOP+0x08
        JP      TXA
;
;	GET 1CHAR (RST 10H)
        .org    ROMTOP+0x10
        JP      RXA
;
;	KBHIT (RST 18H)
        .org    ROMTOP+0x18
        JP      KBHIT
;
;	UART -> A
RXA:    LD      A,(UARTCR)
        BIT     0,A
        JR      Z,RXA
        LD      A,(UARTDR)
        CP      'a
        RET     C
        CP      'z+1
        RET     NC
        AND     0x0DF
        RET
;
;	CHECK RECEIVE STATUS
KBHIT:  LD      A,(UARTCR)
        BIT     0,A
        RET
;
;	A -> UART
TXA:    PUSH    AF
TXAST1: LD      A,(UARTCR)
        BIT     1,A
        JR      Z,TXAST1
        POP     AF
        LD      (UARTDR),A
        RET
;
;
;	SYSTEM INITIALIZE
SINIT:
        JP      COLD
;
;==================================================================================
; The updates to the original BASIC within this file are copyright Grant Searle
;
; You have permission to use this for NON COMMERCIAL USE ONLY
; If you wish to use it elsewhere, please include an acknowledgement to myself.
;
; http://searle.hostei.com/grant/index.html
;
; eMail: home.micros01@btinternet.com
;
; If the above don't work, please perform an Internet search to see if I have
; updated the web page hosting service.
;
;==================================================================================
;
; NASCOM ROM BASIC Ver 4.7, (C) 1978 Microsoft
; Scanned from source published in 80-BUS NEWS from Vol 2, Issue 3
; (May-June 1983) to Vol 3, Issue 3 (May-June 1984)
; Adapted for the freeware Zilog Macro Assembler 2.10 to produce
; the original ROM code (checksum A934H). PA
;
; GENERAL EQUATES
;
CTRLC   .equ    0x03                          ; Control "C"
CTRLG   .equ    0x07                          ; Control "G"
BKSP    .equ    0x08                          ; Back space
LF      .equ    0x0A                          ; Line feed
CS      .equ    0x0C                          ; Clear screen
CR      .equ    0x0D                          ; Carriage return
CTRLO   .equ    0x0F                          ; Control "O"
CTRLQ   .equ    0x11                          ; Control "Q"
CTRLR   .equ    0x12                          ; Control "R"
CTRLS   .equ    0x13                          ; Control "S"
CTRLU   .equ    0x15                          ; Control "U"
ESC     .equ    0x1B                          ; Escape
DEL     .equ    0x7F                          ; Delete
;
; BASIC WORK SPACE LOCATIONS
;
WRKSPC  .equ    0x8045                        ; BASIC Work space
USR     .equ    WRKSPC+0x3                    ; "USR (x)" jump
OUTSUB  .equ    WRKSPC+0x6                    ; "OUT p,n"
OTPORT  .equ    WRKSPC+0x7                    ; Port (p)
DIVSUP  .equ    WRKSPC+0x9                    ; Division support routine
DIV1    .equ    WRKSPC+0x0A                   ; <- Values
DIV2    .equ    WRKSPC+0x0E                   ; <- to
DIV3    .equ    WRKSPC+0x12                   ; <- be
DIV4    .equ    WRKSPC+0x15                   ; <- inserted
SEED    .equ    WRKSPC+0x17                   ; Random number seed
LSTRND  .equ    WRKSPC+0x3A                   ; Last random number
INPSUB  .equ    WRKSPC+0x3E                   ; #INP (x)" Routine
INPORT  .equ    WRKSPC+0x3F                   ; PORT (x)
NULLS   .equ    WRKSPC+0x41                   ; Number of nulls
LWIDTH  .equ    WRKSPC+0x42                   ; Terminal width
COMMAN  .equ    WRKSPC+0x43                   ; Width for commas
NULFLG  .equ    WRKSPC+0x44                   ; Null after input byte flag
CTLOFG  .equ    WRKSPC+0x45                   ; Control "O" flag
LINESC  .equ    WRKSPC+0x46                   ; Lines counter
LINESN  .equ    WRKSPC+0x48                   ; Lines number
CHKSUM  .equ    WRKSPC+0x4A                   ; Array load/save check sum
NMIFLG  .equ    WRKSPC+0x4C                   ; Flag for NMI break routine
BRKFLG  .equ    WRKSPC+0x4D                   ; Break flag
RINPUT  .equ    WRKSPC+0x4E                   ; Input reflection
POINT   .equ    WRKSPC+0x51                   ; "POINT" reflection (unused)
PSET    .equ    WRKSPC+0x54                   ; "SET"	reflection
RESET   .equ    WRKSPC+0x57                   ; "RESET" reflection
STRSPC  .equ    WRKSPC+0x5A                   ; Bottom of string space
LINEAT  .equ    WRKSPC+0x5C                   ; Current line number
BASTXT  .equ    WRKSPC+0x5E                   ; Pointer to start of program
BUFFER  .equ    WRKSPC+0x61                   ; Input buffer
STACK   .equ    WRKSPC+0x66                   ; Initial stack
CURPOS  .equ    WRKSPC+0x0AB                  ; Character position on line
LCRFLG  .equ    WRKSPC+0x0AC                  ; Locate/Create flag
TYPE    .equ    WRKSPC+0x0AD                  ; Data type flag
DATFLG  .equ    WRKSPC+0x0AE                  ; Literal statement flag
LSTRAM  .equ    WRKSPC+0x0AF                  ; Last available RAM
TMSTPT  .equ    WRKSPC+0x0B1                  ; Temporary string pointer
TMSTPL  .equ    WRKSPC+0x0B3                  ; Temporary string pool
TMPSTR  .equ    WRKSPC+0x0BF                  ; Temporary string
STRBOT  .equ    WRKSPC+0x0C3                  ; Bottom of string space
CUROPR  .equ    WRKSPC+0x0C5                  ; Current operator in EVAL
LOOPST  .equ    WRKSPC+0x0C7                  ; First statement of loop
DATLIN  .equ    WRKSPC+0x0C9                  ; Line of current DATA item
FORFLG  .equ    WRKSPC+0x0CB                  ; "FOR" loop flag
LSTBIN  .equ    WRKSPC+0x0CC                  ; Last byte entered
READFG  .equ    WRKSPC+0x0CD                  ; Read/Input flag
BRKLIN  .equ    WRKSPC+0x0CE                  ; Line of break
NXTOPR  .equ    WRKSPC+0x0D0                  ; Next operator in EVAL
ERRLIN  .equ    WRKSPC+0x0D2                  ; Line of error
CONTAD  .equ    WRKSPC+0x0D4                  ; Where to CONTinue
PROGND  .equ    WRKSPC+0x0D6                  ; End of program
VAREND  .equ    WRKSPC+0x0D8                  ; End of variables
ARREND  .equ    WRKSPC+0x0DA                  ; End of arrays
NXTDAT  .equ    WRKSPC+0x0DC                  ; Next data item
FNRGNM  .equ    WRKSPC+0x0DE                  ; Name of FN argument
FNARG   .equ    WRKSPC+0x0E0                  ; FN argument value
FPREG   .equ    WRKSPC+0x0E4                  ; Floating point register
FPEXP   .equ    FPREG+3                       ; Floating point exponent
SGNRES  .equ    WRKSPC+0x0E8                  ; Sign of result
PBUFF   .equ    WRKSPC+0x0E9                  ; Number print buffer
MULVAL  .equ    WRKSPC+0x0F6                  ; Multiplier
PROGST  .equ    WRKSPC+0x0F9                  ; Start of program text area
STLOOK  .equ    WRKSPC+0x15D                  ; Start of memory test
;
; BASIC ERROR CODE VALUES
;
NF      .equ    0x00                          ; NEXT without FOR
SN      .equ    0x02                          ; Syntax error
RG      .equ    0x04                          ; RETURN without GOSUB
OD      .equ    0x06                          ; Out of DATA
FC      .equ    0x08                          ; Function call error
OV      .equ    0x0A                          ; Overflow
OM      .equ    0x0C                          ; Out of memory
UL      .equ    0x0E                          ; Undefined line number
BS      .equ    0x10                          ; Bad subscript
RD      .equ    0x12                          ; Re-DIMensioned array
DZ      .equ    0x14                          ; Division by zero (/0)
ID      .equ    0x16                          ; Illegal direct
TM      .equ    0x18                          ; Type miss-match
OS      .equ    0x1A                          ; Out of string space
LS      .equ    0x1C                          ; String too long
ST      .equ    0x1E                          ; String formula too complex
CN      .equ    0x20                          ; Can't CONTinue
UF      .equ    0x22                          ; UnDEFined FN function
MO      .equ    0x24                          ; Missing operand
HX      .equ    0x26                          ; HEX error
BN      .equ    0x28                          ; BIN error
;
COLD:   JP      STARTB                        ; Jump for cold start
WARM:   JP      WARMST                        ; Jump for warm start
STARTB: JP      CSTART                        ; Jump to initialise
;
        .dw     DEINT                         ; Get integer -32768 to 32767
        .dw     ABPASS                        ; Return integer in AB
;
CSTART: LD      HL,WRKSPC                     ; Start of workspace RAM
        LD      SP,HL                         ; Set up a temporary stack
        JP      INITST                        ; Go to initialise
;
INIT:   LD      DE,INITAB                     ; Initialise workspace
        LD      B,INITBE-INITAB+3             ; Bytes to copy
        LD      HL,WRKSPC                     ; Into workspace RAM
COPY:   LD      A,(DE)                        ; Get source
        LD      (HL),A                        ; To destination
        INC     HL                            ; Next destination
        INC     DE                            ; Next source
        DEC     B                             ; Count bytes
        JP      NZ,COPY                       ; More to move
        LD      SP,HL                         ; Temporary stack
        CALL    CLREG                         ; Clear registers and stack
        CALL    PRCRLF                        ; Output CRLF
        LD      (BUFFER+72+1),A               ; Mark end of buffer
        LD      (PROGST),A                    ; Initialise program area
MSIZE:  LD      HL,STLOOK                     ; Point to start of RAM
MLOOP:  INC     HL                            ; Next byte
        LD      A,H                           ; Above address FFFF ?
        OR      L
        JP      Z,SETTOP                      ; Yes - 64K RAM
        LD      A,(HL)                        ; Get contents
        LD      B,A                           ; Save it
        CPL                                   ; Flip all bits
        LD      (HL),A                        ; Put it back
        CP      (HL)                          ; RAM there if same
        LD      (HL),B                        ; Restore old contents
        JP      Z,MLOOP                       ; If RAM - test next byte
;
SETTOP: DEC     HL                            ; Back one byte
        LD      DE,STLOOK-1                   ; See if enough RAM
        CALL    CPDEHL                        ; Compare DE with HL
        JP      C,NEMEM                       ; If not enough RAM
        LD      DE,0-50                       ; 50 Bytes string space
        LD      (LSTRAM),HL                   ; Save last available RAM
        ADD     HL,DE                         ; Allocate string space
        LD      (STRSPC),HL                   ; Save string space
        CALL    CLRPTR                        ; Clear program area
        LD      HL,(STRSPC)                   ; Get end of memory
        LD      DE,0-17                       ; Offset for free bytes
        ADD     HL,DE                         ; Adjust HL
        LD      DE,PROGST                     ; Start of program text
        LD      A,L                           ; Get LSB
        SUB     E                             ; Adjust it
        LD      L,A                           ; Re-save
        LD      A,H                           ; Get MSB
        SBC     A,D                           ; Adjust it
        LD      H,A                           ; Re-save
        PUSH    HL                            ; Save bytes free
        LD      HL,SIGNON                     ; Sign-on message
        CALL    PRS                           ; Output string
        POP     HL                            ; Get bytes free back
        CALL    PRNTHL                        ; Output amount of free memory
        LD      HL,BFREE                      ; " Bytes free" message
        CALL    PRS                           ; Output string
;
WARMST: LD      SP,STACK                      ; Temporary stack
BRKRET: CALL    CLREG                         ; Clear registers and stack
        JP      PRNTOK                        ; Go to get command line
;
NEMEM:  LD      HL,MEMMSG                     ; Memory size not enough
        CALL    PRS                           ; Print it
XXXXX:  JP      XXXXX                         ; Stop
;
:|1 BFREE:|2 .db|3 |||" Bytes free",CR,LF,0,0
>|1 BFREE:|2 .ascii|3 " Bytes free"
.db|||,CR,LF,0,0
<|1 BFREE:|2 .ascii|3 " Bytes free"
.db|||CR,LF,0,0
<|1 BFREE:|2 .ascii|3 " Bytes free"
.dbCR,|||LF,0,0
<|1 BFREE:|2 .ascii|3 " Bytes free"
.dbCR,LF,|||0,0
BFREE:  .ascii  " Bytes free"
        .db     CR,LF,0,0
;
:|1 SIGNON:|2 .db|3 |||"Z80 BASIC Ver 4.7b",CR,LF
>|1 SIGNON:|2 .ascii|3 "Z80 BASIC Ver 4.7b"
.db|||,CR,LF
<|1 SIGNON:|2 .ascii|3 "Z80 BASIC Ver 4.7b"
.db|||CR,LF
SIGNON: .ascii  "Z80 BASIC Ver 4.7b"
        .db     CR,LF
:|1 |2 .db|3 |||"Copyright ",40,"C",41
>|1 |2 .ascii|3 "Copyright "
.db|||,40,"C",41
<|1 |2 .ascii|3 "Copyright "
.db|||40,"C",41
:|1 |2 .ascii|3 "Copyright "
.db40,|||"C",41
>|1 |2 .ascii|3 "Copyright "
        .db     40,"C"
.db|||,41
<|1 |2 .ascii|3 "Copyright "
        .db     40,"C"
.db|||41
        .ascii  "Copyright "
        .db     40,"C"
        .db     41
:|1 |2 .db|3 |||" 1978 by Microsoft",CR,LF,0,0
>|1 |2 .ascii|3 " 1978 by Microsoft"
.db|||,CR,LF,0,0
<|1 |2 .ascii|3 " 1978 by Microsoft"
.db|||CR,LF,0,0
<|1 |2 .ascii|3 " 1978 by Microsoft"
.dbCR,|||LF,0,0
<|1 |2 .ascii|3 " 1978 by Microsoft"
.dbCR,LF,|||0,0
        .ascii  " 1978 by Microsoft"
        .db     CR,LF,0,0
;
:|1 MEMMSG:|2 .db|3 |||"Memory size not enough",CR,LF
>|1 MEMMSG:|2 .ascii|3 "Memory size not enough"
.db|||,CR,LF
<|1 MEMMSG:|2 .ascii|3 "Memory size not enough"
.db|||CR,LF
MEMMSG: .ascii  "Memory size not enough"
        .db     CR,LF
:|1 |2 .db|3 |||"The system is stopped.",CR,LF,0,0
>|1 |2 .ascii|3 "The system is stopped."
.db|||,CR,LF,0,0
<|1 |2 .ascii|3 "The system is stopped."
.db|||CR,LF,0,0
<|1 |2 .ascii|3 "The system is stopped."
.dbCR,|||LF,0,0
<|1 |2 .ascii|3 "The system is stopped."
.dbCR,LF,|||0,0
        .ascii  "The system is stopped."
        .db     CR,LF,0,0
;
; FUNCTION ADDRESS TABLE
;
FNCTAB: .dw     SGN
        .dw     INT
        .dw     ABS
        .dw     USR
        .dw     FRE
        .dw     INP
        .dw     POS
        .dw     SQR
        .dw     RND
        .dw     LOG
        .dw     EXP
        .dw     COS
        .dw     SIN
        .dw     TAN
        .dw     ATN
        .dw     PEEK
        .dw     DEEK
        .dw     POINT
        .dw     LEN
        .dw     STR
        .dw     VAL
        .dw     ASC
        .dw     CHR
        .dw     HEX
        .dw     BIN
        .dw     LEFT
        .dw     RIGHT
        .dw     MID
;
; RESERVED WORD LIST
;
<|1 WORDS:|2 .db|3 |||0x0C5,"ND"
:|1 WORDS:|2 .db|3 0x0C5,|||"ND"
>|1 WORDS:|2 .db|3 0x0C5,"ND"
.db|||
WORDS:  .db     0x0C5,"ND"
        .db
<|1 |2 .db|3 |||0x0C6,"OR"
:|1 |2 .db|3 0x0C6,|||"OR"
>|1 |2 .db|3 0x0C6,"OR"
.db|||
        .db     0x0C6,"OR"
        .db
<|1 |2 .db|3 |||0x0CE,"EXT"
:|1 |2 .db|3 0x0CE,|||"EXT"
>|1 |2 .db|3 0x0CE,"EXT"
.db|||
        .db     0x0CE,"EXT"
        .db
<|1 |2 .db|3 |||0x0C4,"ATA"
:|1 |2 .db|3 0x0C4,|||"ATA"
>|1 |2 .db|3 0x0C4,"ATA"
.db|||
        .db     0x0C4,"ATA"
        .db
<|1 |2 .db|3 |||0x0C9,"NPUT"
:|1 |2 .db|3 0x0C9,|||"NPUT"
>|1 |2 .db|3 0x0C9,"NPUT"
.db|||
        .db     0x0C9,"NPUT"
        .db
<|1 |2 .db|3 |||0x0C4,"IM"
:|1 |2 .db|3 0x0C4,|||"IM"
>|1 |2 .db|3 0x0C4,"IM"
.db|||
        .db     0x0C4,"IM"
        .db
<|1 |2 .db|3 |||0x0D2,"EAD"
:|1 |2 .db|3 0x0D2,|||"EAD"
>|1 |2 .db|3 0x0D2,"EAD"
.db|||
        .db     0x0D2,"EAD"
        .db
<|1 |2 .db|3 |||0x0CC,"ET"
:|1 |2 .db|3 0x0CC,|||"ET"
>|1 |2 .db|3 0x0CC,"ET"
.db|||
        .db     0x0CC,"ET"
        .db
<|1 |2 .db|3 |||0x0C7,"OTO"
:|1 |2 .db|3 0x0C7,|||"OTO"
>|1 |2 .db|3 0x0C7,"OTO"
.db|||
        .db     0x0C7,"OTO"
        .db
<|1 |2 .db|3 |||0x0D2,"UN"
:|1 |2 .db|3 0x0D2,|||"UN"
>|1 |2 .db|3 0x0D2,"UN"
.db|||
        .db     0x0D2,"UN"
        .db
<|1 |2 .db|3 |||0x0C9,"F"
:|1 |2 .db|3 0x0C9,|||"F"
>|1 |2 .db|3 0x0C9,"F"
.db|||
        .db     0x0C9,"F"
        .db
<|1 |2 .db|3 |||0x0D2,"ESTORE"
:|1 |2 .db|3 0x0D2,|||"ESTORE"
>|1 |2 .db|3 0x0D2,"ESTORE"
.db|||
        .db     0x0D2,"ESTORE"
        .db
<|1 |2 .db|3 |||0x0C7,"OSUB"
:|1 |2 .db|3 0x0C7,|||"OSUB"
>|1 |2 .db|3 0x0C7,"OSUB"
.db|||
        .db     0x0C7,"OSUB"
        .db
<|1 |2 .db|3 |||0x0D2,"ETURN"
:|1 |2 .db|3 0x0D2,|||"ETURN"
>|1 |2 .db|3 0x0D2,"ETURN"
.db|||
        .db     0x0D2,"ETURN"
        .db
<|1 |2 .db|3 |||0x0D2,"EM"
:|1 |2 .db|3 0x0D2,|||"EM"
>|1 |2 .db|3 0x0D2,"EM"
.db|||
        .db     0x0D2,"EM"
        .db
<|1 |2 .db|3 |||0x0D3,"TOP"
:|1 |2 .db|3 0x0D3,|||"TOP"
>|1 |2 .db|3 0x0D3,"TOP"
.db|||
        .db     0x0D3,"TOP"
        .db
<|1 |2 .db|3 |||0x0CF,"UT"
:|1 |2 .db|3 0x0CF,|||"UT"
>|1 |2 .db|3 0x0CF,"UT"
.db|||
        .db     0x0CF,"UT"
        .db
<|1 |2 .db|3 |||0x0CF,"N"
:|1 |2 .db|3 0x0CF,|||"N"
>|1 |2 .db|3 0x0CF,"N"
.db|||
        .db     0x0CF,"N"
        .db
<|1 |2 .db|3 |||0x0CE,"ULL"
:|1 |2 .db|3 0x0CE,|||"ULL"
>|1 |2 .db|3 0x0CE,"ULL"
.db|||
        .db     0x0CE,"ULL"
        .db
<|1 |2 .db|3 |||0x0D7,"AIT"
:|1 |2 .db|3 0x0D7,|||"AIT"
>|1 |2 .db|3 0x0D7,"AIT"
.db|||
        .db     0x0D7,"AIT"
        .db
<|1 |2 .db|3 |||0x0C4,"EF"
:|1 |2 .db|3 0x0C4,|||"EF"
>|1 |2 .db|3 0x0C4,"EF"
.db|||
        .db     0x0C4,"EF"
        .db
<|1 |2 .db|3 |||0x0D0,"OKE"
:|1 |2 .db|3 0x0D0,|||"OKE"
>|1 |2 .db|3 0x0D0,"OKE"
.db|||
        .db     0x0D0,"OKE"
        .db
<|1 |2 .db|3 |||0x0C4,"OKE"
:|1 |2 .db|3 0x0C4,|||"OKE"
>|1 |2 .db|3 0x0C4,"OKE"
.db|||
        .db     0x0C4,"OKE"
        .db
<|1 |2 .db|3 |||0x0D3,"CREEN"
:|1 |2 .db|3 0x0D3,|||"CREEN"
>|1 |2 .db|3 0x0D3,"CREEN"
.db|||
        .db     0x0D3,"CREEN"
        .db
<|1 |2 .db|3 |||0x0CC,"INES"
:|1 |2 .db|3 0x0CC,|||"INES"
>|1 |2 .db|3 0x0CC,"INES"
.db|||
        .db     0x0CC,"INES"
        .db
<|1 |2 .db|3 |||0x0C3,"LS"
:|1 |2 .db|3 0x0C3,|||"LS"
>|1 |2 .db|3 0x0C3,"LS"
.db|||
        .db     0x0C3,"LS"
        .db
<|1 |2 .db|3 |||0x0D7,"IDTH"
:|1 |2 .db|3 0x0D7,|||"IDTH"
>|1 |2 .db|3 0x0D7,"IDTH"
.db|||
        .db     0x0D7,"IDTH"
        .db
<|1 |2 .db|3 |||0x0CD,"ONITOR"
:|1 |2 .db|3 0x0CD,|||"ONITOR"
>|1 |2 .db|3 0x0CD,"ONITOR"
.db|||
        .db     0x0CD,"ONITOR"
        .db
<|1 |2 .db|3 |||0x0D3,"ET"
:|1 |2 .db|3 0x0D3,|||"ET"
>|1 |2 .db|3 0x0D3,"ET"
.db|||
        .db     0x0D3,"ET"
        .db
<|1 |2 .db|3 |||0x0D2,"ESET"
:|1 |2 .db|3 0x0D2,|||"ESET"
>|1 |2 .db|3 0x0D2,"ESET"
.db|||
        .db     0x0D2,"ESET"
        .db
<|1 |2 .db|3 |||0x0D0,"RINT"
:|1 |2 .db|3 0x0D0,|||"RINT"
>|1 |2 .db|3 0x0D0,"RINT"
.db|||
        .db     0x0D0,"RINT"
        .db
<|1 |2 .db|3 |||0x0C3,"ONT"
:|1 |2 .db|3 0x0C3,|||"ONT"
>|1 |2 .db|3 0x0C3,"ONT"
.db|||
        .db     0x0C3,"ONT"
        .db
<|1 |2 .db|3 |||0x0CC,"IST"
:|1 |2 .db|3 0x0CC,|||"IST"
>|1 |2 .db|3 0x0CC,"IST"
.db|||
        .db     0x0CC,"IST"
        .db
<|1 |2 .db|3 |||0x0C3,"LEAR"
:|1 |2 .db|3 0x0C3,|||"LEAR"
>|1 |2 .db|3 0x0C3,"LEAR"
.db|||
        .db     0x0C3,"LEAR"
        .db
<|1 |2 .db|3 |||0x0C3,"LOAD"
:|1 |2 .db|3 0x0C3,|||"LOAD"
>|1 |2 .db|3 0x0C3,"LOAD"
.db|||
        .db     0x0C3,"LOAD"
        .db
<|1 |2 .db|3 |||0x0C3,"SAVE"
:|1 |2 .db|3 0x0C3,|||"SAVE"
>|1 |2 .db|3 0x0C3,"SAVE"
.db|||
        .db     0x0C3,"SAVE"
        .db
<|1 |2 .db|3 |||0x0CE,"EW"
:|1 |2 .db|3 0x0CE,|||"EW"
>|1 |2 .db|3 0x0CE,"EW"
.db|||
        .db     0x0CE,"EW"
        .db
;
<|1 |2 .db|3 |||0x0D4,"AB("
:|1 |2 .db|3 0x0D4,|||"AB("
>|1 |2 .db|3 0x0D4,"AB("
.db|||
        .db     0x0D4,"AB("
        .db
<|1 |2 .db|3 |||0x0D4,"O"
:|1 |2 .db|3 0x0D4,|||"O"
>|1 |2 .db|3 0x0D4,"O"
.db|||
        .db     0x0D4,"O"
        .db
<|1 |2 .db|3 |||0x0C6,"N"
:|1 |2 .db|3 0x0C6,|||"N"
>|1 |2 .db|3 0x0C6,"N"
.db|||
        .db     0x0C6,"N"
        .db
<|1 |2 .db|3 |||0x0D3,"PC("
:|1 |2 .db|3 0x0D3,|||"PC("
>|1 |2 .db|3 0x0D3,"PC("
.db|||
        .db     0x0D3,"PC("
        .db
<|1 |2 .db|3 |||0x0D4,"HEN"
:|1 |2 .db|3 0x0D4,|||"HEN"
>|1 |2 .db|3 0x0D4,"HEN"
.db|||
        .db     0x0D4,"HEN"
        .db
<|1 |2 .db|3 |||0x0CE,"OT"
:|1 |2 .db|3 0x0CE,|||"OT"
>|1 |2 .db|3 0x0CE,"OT"
.db|||
        .db     0x0CE,"OT"
        .db
<|1 |2 .db|3 |||0x0D3,"TEP"
:|1 |2 .db|3 0x0D3,|||"TEP"
>|1 |2 .db|3 0x0D3,"TEP"
.db|||
        .db     0x0D3,"TEP"
        .db
;
<|1 |2 .db|3 |||0x0AB
        .db     0x0AB
<|1 |2 .db|3 |||0x0AD
        .db     0x0AD
<|1 |2 .db|3 |||0x0AA
        .db     0x0AA
<|1 |2 .db|3 |||0x0AF
        .db     0x0AF
<|1 |2 .db|3 |||0x0DE
        .db     0x0DE
<|1 |2 .db|3 |||0x0C1,"ND"
:|1 |2 .db|3 0x0C1,|||"ND"
>|1 |2 .db|3 0x0C1,"ND"
.db|||
        .db     0x0C1,"ND"
        .db
<|1 |2 .db|3 |||0x0CF,"R"
:|1 |2 .db|3 0x0CF,|||"R"
>|1 |2 .db|3 0x0CF,"R"
.db|||
        .db     0x0CF,"R"
        .db
<|1 |2 .db|3 |||0x0BE
        .db     0x0BE
<|1 |2 .db|3 |||0x0BD
        .db     0x0BD
<|1 |2 .db|3 |||0x0BC
        .db     0x0BC
;
<|1 |2 .db|3 |||0x0D3,"GN"
:|1 |2 .db|3 0x0D3,|||"GN"
>|1 |2 .db|3 0x0D3,"GN"
.db|||
        .db     0x0D3,"GN"
        .db
<|1 |2 .db|3 |||0x0C9,"NT"
:|1 |2 .db|3 0x0C9,|||"NT"
>|1 |2 .db|3 0x0C9,"NT"
.db|||
        .db     0x0C9,"NT"
        .db
<|1 |2 .db|3 |||0x0C1,"BS"
:|1 |2 .db|3 0x0C1,|||"BS"
>|1 |2 .db|3 0x0C1,"BS"
.db|||
        .db     0x0C1,"BS"
        .db
<|1 |2 .db|3 |||0x0D5,"SR"
:|1 |2 .db|3 0x0D5,|||"SR"
>|1 |2 .db|3 0x0D5,"SR"
.db|||
        .db     0x0D5,"SR"
        .db
<|1 |2 .db|3 |||0x0C6,"RE"
:|1 |2 .db|3 0x0C6,|||"RE"
>|1 |2 .db|3 0x0C6,"RE"
.db|||
        .db     0x0C6,"RE"
        .db
<|1 |2 .db|3 |||0x0C9,"NP"
:|1 |2 .db|3 0x0C9,|||"NP"
>|1 |2 .db|3 0x0C9,"NP"
.db|||
        .db     0x0C9,"NP"
        .db
<|1 |2 .db|3 |||0x0D0,"OS"
:|1 |2 .db|3 0x0D0,|||"OS"
>|1 |2 .db|3 0x0D0,"OS"
.db|||
        .db     0x0D0,"OS"
        .db
<|1 |2 .db|3 |||0x0D3,"QR"
:|1 |2 .db|3 0x0D3,|||"QR"
>|1 |2 .db|3 0x0D3,"QR"
.db|||
        .db     0x0D3,"QR"
        .db
<|1 |2 .db|3 |||0x0D2,"ND"
:|1 |2 .db|3 0x0D2,|||"ND"
>|1 |2 .db|3 0x0D2,"ND"
.db|||
        .db     0x0D2,"ND"
        .db
<|1 |2 .db|3 |||0x0CC,"OG"
:|1 |2 .db|3 0x0CC,|||"OG"
>|1 |2 .db|3 0x0CC,"OG"
.db|||
        .db     0x0CC,"OG"
        .db
<|1 |2 .db|3 |||0x0C5,"XP"
:|1 |2 .db|3 0x0C5,|||"XP"
>|1 |2 .db|3 0x0C5,"XP"
.db|||
        .db     0x0C5,"XP"
        .db
<|1 |2 .db|3 |||0x0C3,"OS"
:|1 |2 .db|3 0x0C3,|||"OS"
>|1 |2 .db|3 0x0C3,"OS"
.db|||
        .db     0x0C3,"OS"
        .db
<|1 |2 .db|3 |||0x0D3,"IN"
:|1 |2 .db|3 0x0D3,|||"IN"
>|1 |2 .db|3 0x0D3,"IN"
.db|||
        .db     0x0D3,"IN"
        .db
<|1 |2 .db|3 |||0x0D4,"AN"
:|1 |2 .db|3 0x0D4,|||"AN"
>|1 |2 .db|3 0x0D4,"AN"
.db|||
        .db     0x0D4,"AN"
        .db
<|1 |2 .db|3 |||0x0C1,"TN"
:|1 |2 .db|3 0x0C1,|||"TN"
>|1 |2 .db|3 0x0C1,"TN"
.db|||
        .db     0x0C1,"TN"
        .db
<|1 |2 .db|3 |||0x0D0,"EEK"
:|1 |2 .db|3 0x0D0,|||"EEK"
>|1 |2 .db|3 0x0D0,"EEK"
.db|||
        .db     0x0D0,"EEK"
        .db
<|1 |2 .db|3 |||0x0C4,"EEK"
:|1 |2 .db|3 0x0C4,|||"EEK"
>|1 |2 .db|3 0x0C4,"EEK"
.db|||
        .db     0x0C4,"EEK"
        .db
<|1 |2 .db|3 |||0x0D0,"OINT"
:|1 |2 .db|3 0x0D0,|||"OINT"
>|1 |2 .db|3 0x0D0,"OINT"
.db|||
        .db     0x0D0,"OINT"
        .db
<|1 |2 .db|3 |||0x0CC,"EN"
:|1 |2 .db|3 0x0CC,|||"EN"
>|1 |2 .db|3 0x0CC,"EN"
.db|||
        .db     0x0CC,"EN"
        .db
<|1 |2 .db|3 |||0x0D3,"TR$"
:|1 |2 .db|3 0x0D3,|||"TR$"
>|1 |2 .db|3 0x0D3,"TR$"
.db|||
        .db     0x0D3,"TR$"
        .db
<|1 |2 .db|3 |||0x0D6,"AL"
:|1 |2 .db|3 0x0D6,|||"AL"
>|1 |2 .db|3 0x0D6,"AL"
.db|||
        .db     0x0D6,"AL"
        .db
<|1 |2 .db|3 |||0x0C1,"SC"
:|1 |2 .db|3 0x0C1,|||"SC"
>|1 |2 .db|3 0x0C1,"SC"
.db|||
        .db     0x0C1,"SC"
        .db
<|1 |2 .db|3 |||0x0C3,"HR$"
:|1 |2 .db|3 0x0C3,|||"HR$"
>|1 |2 .db|3 0x0C3,"HR$"
.db|||
        .db     0x0C3,"HR$"
        .db
<|1 |2 .db|3 |||0x0C8,"EX$"
:|1 |2 .db|3 0x0C8,|||"EX$"
>|1 |2 .db|3 0x0C8,"EX$"
.db|||
        .db     0x0C8,"EX$"
        .db
<|1 |2 .db|3 |||0x0C2,"IN$"
:|1 |2 .db|3 0x0C2,|||"IN$"
>|1 |2 .db|3 0x0C2,"IN$"
.db|||
        .db     0x0C2,"IN$"
        .db
<|1 |2 .db|3 |||0x0CC,"EFT$"
:|1 |2 .db|3 0x0CC,|||"EFT$"
>|1 |2 .db|3 0x0CC,"EFT$"
.db|||
        .db     0x0CC,"EFT$"
        .db
<|1 |2 .db|3 |||0x0D2,"IGHT$"
:|1 |2 .db|3 0x0D2,|||"IGHT$"
>|1 |2 .db|3 0x0D2,"IGHT$"
.db|||
        .db     0x0D2,"IGHT$"
        .db
<|1 |2 .db|3 |||0x0CD,"ID$"
:|1 |2 .db|3 0x0CD,|||"ID$"
>|1 |2 .db|3 0x0CD,"ID$"
.db|||
        .db     0x0CD,"ID$"
        .db
<|1 |2 .db|3 |||0x80 |; End of list marker
        .db     0x80                          ; End of list marker
;
; KEYWORD ADDRESS TABLE
;
WORDTB: .dw     PEND
        .dw     FOR
        .dw     NEXT
        .dw     DATA
        .dw     INPUT
        .dw     DIM
        .dw     READ
        .dw     LET
        .dw     GOTO
        .dw     RUN
        .dw     IF
        .dw     RESTOR
        .dw     GOSUB
        .dw     RETURN
        .dw     REM
        .dw     STOP
        .dw     POUT
        .dw     ON
        .dw     NULL
        .dw     WAIT
        .dw     DEF
        .dw     POKE
        .dw     DOKE
        .dw     REM
        .dw     LINES
        .dw     CLS
        .dw     WIDTH
        .dw     MONITR
        .dw     PSET
        .dw     RESET
        .dw     PRINT
        .dw     CONT
        .dw     LIST
        .dw     CLEAR
        .dw     REM
        .dw     REM
        .dw     NEW
;
; RESERVED WORD TOKEN VALUES
;
ZEND    .equ    0x080                         ; END
ZFOR    .equ    0x081                         ; FOR
ZDATA   .equ    0x083                         ; DATA
ZGOTO   .equ    0x088                         ; GOTO
ZGOSUB  .equ    0x08C                         ; GOSUB
ZREM    .equ    0x08E                         ; REM
ZPRINT  .equ    0x09E                         ; PRINT
ZNEW    .equ    0x0A4                         ; NEW
;
ZTAB    .equ    0x0A5                         ; TAB
ZTO     .equ    0x0A6                         ; TO
ZFN     .equ    0x0A7                         ; FN
ZSPC    .equ    0x0A8                         ; SPC
ZTHEN   .equ    0x0A9                         ; THEN
ZNOT    .equ    0x0AA                         ; NOT
ZSTEP   .equ    0x0AB                         ; STEP
;
ZPLUS   .equ    0x0AC                         ; +
ZMINUS  .equ    0x0AD                         ; -
ZTIMES  .equ    0x0AE                         ; *
ZDIV    .equ    0x0AF                         ; /
ZOR     .equ    0x0B2                         ; OR
ZGTR    .equ    0x0B3                         ; >
ZEQUAL  .equ    0x0B4                         ; M
ZLTH    .equ    0x0B5                         ; <
ZSGN    .equ    0x0B6                         ; SGN
ZPOINT  .equ    0x0C7                         ; POINT
ZLEFT   .equ    0x0CD+2                       ; LEFT.
;
; ARITHMETIC PRECEDENCE TABLE
;
<|1 PRITAB:|2 .db|3 |||0x79 |; Precedence value
PRITAB: .db     0x79                          ; Precedence value
        .dw     PADD                          ; FPREG = <last> + FPREG
;
<|1 |2 .db|3 |||0x79 |; Precedence value
        .db     0x79                          ; Precedence value
        .dw     PSUB                          ; FPREG = <last> - FPREG
;
<|1 |2 .db|3 |||0x7C |; Precedence value
        .db     0x7C                          ; Precedence value
        .dw     MULT                          ; PPREG = <last> * FPREG
;
<|1 |2 .db|3 |||0x7C |; Precedence value
        .db     0x7C                          ; Precedence value
        .dw     DIV                           ; FPREG = <last> / FPREG
;
<|1 |2 .db|3 |||0x7F |; Precedence value
        .db     0x7F                          ; Precedence value
        .dw     POWER                         ; FPREG = <last> ^ FPREG
;
<|1 |2 .db|3 |||0x50 |; Precedence value
        .db     0x50                          ; Precedence value
        .dw     PAND                          ; FPREG = <last> AND FPREG
;
<|1 |2 .db|3 |||0x46 |; Precedence value
        .db     0x46                          ; Precedence value
        .dw     POR                           ; FPREG = <last> OR FPREG
;
; BASIC ERROR CODE LIST
;
:|1 ERRORS:|2 .db|3 |||"NF" |; NEXT without FOR
>|1 ERRORS:|2 .ascii|3 "NF"
.db||| |; NEXT without FOR
ERRORS: .ascii  "NF"
        .db                                   ; NEXT without FOR
:|1 |2 .db|3 |||"SN" |; Syntax error
>|1 |2 .ascii|3 "SN"
.db||| |; Syntax error
        .ascii  "SN"
        .db                                   ; Syntax error
:|1 |2 .db|3 |||"RG" |; RETURN without GOSUB
>|1 |2 .ascii|3 "RG"
.db||| |; RETURN without GOSUB
        .ascii  "RG"
        .db                                   ; RETURN without GOSUB
:|1 |2 .db|3 |||"OD" |; Out of DATA
>|1 |2 .ascii|3 "OD"
.db||| |; Out of DATA
        .ascii  "OD"
        .db                                   ; Out of DATA
:|1 |2 .db|3 |||"FC" |; Illegal function call
>|1 |2 .ascii|3 "FC"
.db||| |; Illegal function call
        .ascii  "FC"
        .db                                   ; Illegal function call
:|1 |2 .db|3 |||"OV" |; Overflow error
>|1 |2 .ascii|3 "OV"
.db||| |; Overflow error
        .ascii  "OV"
        .db                                   ; Overflow error
:|1 |2 .db|3 |||"OM" |; Out of memory
>|1 |2 .ascii|3 "OM"
.db||| |; Out of memory
        .ascii  "OM"
        .db                                   ; Out of memory
:|1 |2 .db|3 |||"UL" |; Undefined line
>|1 |2 .ascii|3 "UL"
.db||| |; Undefined line
        .ascii  "UL"
        .db                                   ; Undefined line
:|1 |2 .db|3 |||"BS" |; Bad subscript
>|1 |2 .ascii|3 "BS"
.db||| |; Bad subscript
        .ascii  "BS"
        .db                                   ; Bad subscript
:|1 |2 .db|3 |||"DD" |; Re-DIMensioned array
>|1 |2 .ascii|3 "DD"
.db||| |; Re-DIMensioned array
        .ascii  "DD"
        .db                                   ; Re-DIMensioned array
:|1 |2 .db|3 |||"/0" |; Division by zero
>|1 |2 .ascii|3 "/0"
.db||| |; Division by zero
        .ascii  "/0"
        .db                                   ; Division by zero
:|1 |2 .db|3 |||"ID" |; Illegal direct
>|1 |2 .ascii|3 "ID"
.db||| |; Illegal direct
        .ascii  "ID"
        .db                                   ; Illegal direct
:|1 |2 .db|3 |||"TM" |; Type mis-match
>|1 |2 .ascii|3 "TM"
.db||| |; Type mis-match
