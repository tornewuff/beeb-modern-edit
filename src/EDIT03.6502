        ; -> EDIT03
INITED
        ; Set up edit keys as softkeys, and set softkeys to have
        ; following bases -
        ; plain = &80
        ; shift = &90
        ; ctrl  = &A0
        LDAIM   4
        LDXIM   2
        JSR     OSBYTE
        LDAIM   &DB
        LDXIM   128 + 10
        LDYIM   0
        JSR     OSBYTE          ; tab key pretends to be soft key 10
        LDAIM   &E3
        LDXIM   &A0
        LDYIM   0
        JSR     OSBYTE
        LDAIM   &E2
        LDXIM   &90
        LDYIM   0
        JSR     OSBYTE
        LDXIM   &80
INITEX
        LDAIM &E1
        LDYIM   0
        JMP     OSBYTE
INITUS
        ; Return cursor-keys & softkeys to 'normal' state.
        LDAIM   &DB
        LDXIM   9
        LDYIM   0
        JSR     OSBYTE          ; tab key emits 9
        LDAIM   4
        LDXIM   0
        JSR     OSBYTE
        LDXIM   1
        BRA     INITEX
STARTT
        ; Returns CS if on 1st line (GS = TSTART), else CC.
        LDA     TSTART
        CMP     GS
        LDA     TSTART + 1
        SBC     GS + 1
        RTS
ENDTES
        ; Returns CS if on last line (GE + scrimcreenY = TMAX), else CC.
        CLC
        LDA     CURRLE
        ADC     GE
        TAX
        LDAIM   0
        ADC     GE + 1
        CPX     TMAX
        SBC     TMAX + 1
        RTS
LENGTH
        ; Find length of current line. Exit - A = length - 1
        LDYIM   0
LECCLO
        LDAIY GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     LECCRE
        INY
        CPY     PAGEWI
        BNE     LECCLO
LECCRE
        TYA
        RTS
CHECKR
        ; Check for space in edit buffer.
        ; Entry - XY = required No. of bytes
        ; Exit  - size = XY
        ;         XY = temp = GE - XY
        ;         Error if temp < GS

        STX     SIZE
        STY     SIZE + 1
        SEC
        LDA     GE
        SBC     SIZE
        TAX
        LDA     GE + 1
        SBC     SIZE + 1
        TAY
        STX     TEMP
        STY     TEMP + 1
        CPX     GS
        SBC     GS + 1
        BCS     VDU23X
        JMP     CHNRRE                  ; 'No room'

CURON
        LDYIM 1
        BRA     VDU231
CUROFF
        LDYIM 0
VDU231
        LDXIM 1
VDU23
        ; Entry - X = 1st byte, Y = 2nd byte
        ; Exit  - VDU 23,X,Y,0,0,0,0,0,0,0 Output.

        LDAIM   23
        JSR     OSWRCH
        TXA
        JSR     OSWRCH
        TYA
        JSR     OSWRCH
        JSR     VSTRNG
        =       &00,&00,&00,&00,&00,&00,&00,&EA
VDU23X
        RTS

INTPAG
        LDA     TUTMOD
        ANDIM   7
        CMPIM   2
        BEQ     KEYONL
        CMPIM   5
        BEQ     KEYONL
        BRA     NOTTUT
CLEARS
        LDA     TUTMOD
        ANDIM   7
        CMPIM   2
        BEQ     DOTUT
        CMPIM   5
        BNE     NOTTUT
DOTUT
        PHA
        JSR     VSTRNG
        =       26,HOME,&EA
        JSR     STARTI
        JSR     BIGMESS
        PLA
        CMPIM   2
        BEQ     KEYONL
        JSR     BIGMET
KEYONL
        JSR     STOPIN
        JSR     GETWIN          ; get size of total screen
        STA     REALPA          ; pagelength in A
        JSR     DECWIN
NOTTUT
        JSR     GETWIN          ; get size of working area
        TAX                     ; pagelength again in A
        INX                     ; Initialize scrim.
        LDA     PAGEWI
SCMILO
        STAAX   SCRIM
        DEX
        BPL     SCMILO
        JSR     STATUS
        CLR     SCRNPY
        RTS
GETWIN
        LDAIM   160
        LDXIM   10
        JSR     OSBYTE
        STX     PAGEWI
        STY     PAGELE
        LDXIM   8
        JSR     OSBYTE
        TYA
        CLC
        SBC     PAGELE
        STA     PAGELE
        RTS
DECWIN
        LDA     TUTMOD
        ANDIM   7
        LDYIM   14
        CMPIM   5
        BEQ     WINDOW
        LDYIM   7
        CMPIM   2
        BNE     NOWIND
WINDOW
        LDAIM   28
        JSR     OSWRCH
        LDAIM   0
        JSR     OSWRCH
        LDA     REALPA
        INA
        JSR     OSWRCH
        LDA     PAGEWI
        JSR     OSWRCH
        TYA
        JMP     OSWRCH
NOWIND
        LDAIM   26
        JMP     OSWRCH
EDRDCH
        ; Exit - A holds character read
        LDA     NEXTREADFLAG
        BEQ     EDRDOSRD
        LDA     NXTCHR
        CLR     NEXTREADFLAG
        RTS
EDRDOSRD
        [ MOUSE=1
        PHX
        PHY
MOUSLP
        LDAIM   &81
        LDXIM   0
        LDYIM   0
        JSR     OSBYTE
        TXA
        CPYIM   &FF
        BNE     NOMOUSE
        JSR     MOUSER
        LDA     MOUSEL + 8
        ORA     MOUSEL + 9
        BNE     MOUSLY
        LDA     MOUSEL + 6
        ORA     MOUSEL + 7
        BNE     MOUSLX
        LDA     MOUSEL
        CMP     MOUSEL + 5
        BEQ     MOUSLP
        ANDIM   &7
        BITIM   &1
        BNE     MOUSK1
        BITIM   &2
        BNE     MOUSK2
        BITIM   &4
        BEQ     MOUSLP
        LDAIM   &86
        BRA     NOMOUS
MOUSK1
        LDAIM   &98
        BRA     NOMOUS
MOUSK2
        LDAIM   &97
        BRA     NOMOUS
MOUSLX
        LDAIM   &8D
        LDX     MOUSEL + 7
        BPL     NOMOUS
        LDAIM   &8C
        BNE     NOMOUS
MOUSLY
        LDAIM   &8F
        LDX     MOUSEL + 9
        BPL     NOMOUSE
        LDAIM   &8E
NOMOUSE
        PLX
        PLY
        |
        JSR     OSRDCH
        ]

        JMP     ESCTST
MODIFY
        LDAIM   1
        LDX     MODFLG
        STA     MODFLG
        BEQ     STATUS
        RTS
TABCTL
        LDAIM   8
        EOR     TUTMOD
        JSR     DOMODE

CstatU
        STZ     UPDATE          ; update required
status
        JSR     CSR0ST          ; Output status on status line.
        JSR     startI          ; Start inverse
        JSR     TESTIF
        BEQ     STATSO

        JSR     VSTRNG
        =       "Insert ",&EA
        BRA     STATSI

STATSO
        JSR     VSTRNG
        =       "Over   ",&EA

STATSI
        LDX     CURSED
        BEQ     STATSC
        JSR     VSTRNG

        [ PHIL=0
        =       "    Cursor Editing",&EA
        |
        =       "    Soft Key Entry",&EA
        ]

        BRA     STATSX

STATSC
        LDA     MARKX
        BEQ     STATST
        DEA
        BNE     STATSM
        JSR     VSTRNG
        =       "One mark ",&EA
        BRA     STATSS
STATSM
        JSR     VSTRNG
        =       "Two marks",&EA
        BRA     STATSS
STATST
        LDAIM 8
        AND     TUTMOD
        BNE     STATTW
        JSR     VSTRNG
        =       "TAB cols ",&EA
        BRA     STATSS
STATTW
        JSR     VSTRNG
        =       "TAB words",&EA
STATSS
        LDA     MODFLG
        BNE     STATMO
        JSR     VSTRNG
        =       " Original",&EA
        BRA     STATSX
STATMO
        JSR     VSTRNG
        =       " Modified",&EA
STATSX
        [ cf8key=1

        LDAZ    clterm
        CMPIM   cr
        BEQ     STATcr

        JSR     vstrng
        =       " LF",&EA

        BRA     STATlf
STATcr
        JSR     vstrng
        =       " CR",&EA

STATlf
        ]

        [ STAMP=1
        LDA     FLLOAD + 1
        AND     FLLOAD + 2
        AND     FLLOAD + 3
        INA
        BNE     STATNS

        JSR     VSTRNG
        =       " Date",&EA
        BRA     STATNQ
STATNS

        JSR     VSTRNG
        =       " Exec",&EA
STATNQ
        ]

        JSR     stopIN          ; stop inverse
        LDY     pagele
        INY

prmptl  *       25              ; Prompt position

        GBLA    $prmod
$prmod  SETA    0               ; the modification to prmptl for nice printing

        [ cf8key=1
$prmod  SETA    ($prmod + 3)    ; CR/LF text
        ]

        [ stamp=1
$prmod  SETA    ($prmod + 5)    ; Date/Exec text
        ]

        LDAIM   (PRMPTL - 1 + $prmod)   ; plus any modifications

        JMP     wipeTA                  ; and clear the rest of the line


promtF
        JSR     prompt
        =       "Type filename ",&EA
        LDXIM   &01
        BRA     STRMFL

prompt
        LDY PAGELE
        INY
        JSR     WIPELI
        LDXIM   0
PRMPTX
        LDY     PAGELE
        INY
        JSR     CSRXY
        LDXIM   1
        BRA     STRMFL
STRIMO
        LDXIM 0
STRMFL
        JSR     STARTI
        PLA
        STA     STRING
        PLA
        STA     STRING + 1
        JSR     VSTRLP
        JSR     STOPIN
        TXA
        BEQ     STRMEX
        LDA     PAGEWI
        DEA
        LDY     PAGELE
        STAAY   SCRIM + 1
STRMEX
        JMI STRING
CSRSCR
        LDX SCRNX
        LDY     SCRNY
        BPL     CSRXY
CSR0ST
        LDY PAGELE
        INY
CSR0Y
        LDXIM 0
CSRXY
        LDAIM 31
        JSR     OSWRCH
        TXA
        JSR     OSWRCH
        TYA
        JMP     OSWRCH
NORMAL
        ; Entry : gap character positioned
        ; Exit : gap moved to start of current line
        LDA     GS
        STA     TEMP
        LDA     GS + 1
        STA     TEMP + 1
        JSR     FINDPO
        STA     STRING
        SEC
        LDA     GS
        SBC     STRING
        TAX
        LDA     GS + 1
        SBCIM   0
        TAY
        JMP     GPBKXY
FINDPO
        ; Entry : temp-> middle of line in 1st half of text
        ; Exit  : A[Z]  = xcoord (0..page..width) of pointer within line.
        ;         Y(=atemp) = page_width - A  
        CLC     ;-1
        LDA     TEMP
        SBC     PAGEWI 
        STA     TEMP
        BCS     FIPOND
        DEC     TEMP + 1
FIPOND
        LDY PAGEWI
FIPOLP
        LDAIY TEMP
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     FIPOL2
FIPOE2
        ; Entry point, when called from tempbacklines.
        DEY
        BPL     FIPOLP
        BMI     FINDPO
FIPOL2
        STY ATEMP
        SEC
        LDA     PAGEWI
        SBC     ATEMP
        RTS
TPGEFD
        ; TP := GE  +  A lines
        LDX     GE
        LDY     GE + 1
        STX     TP
        STY     TP + 1
TPFWDA
        ; Moves pointer TP forward A lines.
        ; Entry - A = No. of lines to advance TP
        ; Exit  - TP advanced (possibly by less than A lines if hit EOT)
        ;         count = No. of lines remaining from original request.
        ;         atemp = Last end of line character.
        TAX
        STX     COUNT
        BEQ     TPTPEX
TPTPLP
        LDYIM &FF
TPTPSE
        INY
        LDAIY   TP
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     TPTPFD
        CPY     PAGEWI
        BNE     TPTPSE
TPTPFD
        STA ATEMP
        TYA
        JSR     TPPAP1
        BCS     TPTPEX
        DEC     COUNT
        BNE     TPTPLP
TPTPEX
        RTS
TPPAP1
        ; Exit  -  CC TP = TP  +  (A + 1). CS TP + (A + 1) = HYMEM,
        ;          TP unchanged.
        SEC     ; + 1
        ADC     TP
        TAX
        LDAIM   0
        ADC     TP + 1
        TAY
        CPX     HYMEM
        SBC     HYMEM + 1
        BCS     TPPAPX
        STX     TP
        STY     TP + 1
TPPAPX
        RTS
TPGSBK
        ; TP := GS - A lines
        ; Entry - A = No. of lines to retreat XY.
        ; Exit  - TP retreated
        ;         A = No. of lines was able to go back.
        LDX     GS
        LDY     GS + 1
        STX     TP
        STY     TP + 1
        TAX
        STX     COUNT
        BEQ     TPXYEX
        LDXIM   0
TPXYLP
        LDA TSTART
        CMP     TP
        LDA     TSTART + 1
        SBC     TP + 1
        BCS     TPXYAB
        CLC     ; - 1
        LDA     TP
        SBC     PAGEWI
        STA     TP
        BCS     TPXYND
        DEC     TP + 1
TPXYND
        LDY PAGEWI
        LDAIY   TP
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     TPXYCO
        LDA     TP
        STA     TEMP
        LDA     TP + 1
        STA     TEMP + 1
        JSR     FIPOE2
        BEQ     TPXYCO
        TYA                     ; answer from FINDPO in Y
        ADC     TP              ; + 1 from CS
        STA     TP
        BCC     TPXYCO
        INC     TP + 1
TPXYCO
        INX
        CPX     COUNT
        BCC     TPXYLP
TPXYAB
        TXA
TPXYEX
        RTS
PAGEUP
        LDA PAGELE
        INA
MVLNBK
        ; Entry - A = No. of lines to move gap back.
        ; Exit  - Gap moved back A lines. May be moved less if
        ;         hits start of file.
        JSR     TPGSBK
        LDX     TP
        LDY     TP + 1
GPBKXY
        ; Move gap back so that GS := XY
        STX     ARGP
        STY     ARGP + 1
        SEC
        LDA     GS
        SBC     ARGP
        STX     GS
        TAX
        LDA     GS + 1
        SBC     ARGP + 1
        STY     GS + 1
        TAY
        STX     SIZE
        STY     SIZE + 1
        LDA     GE
        SBC     SIZE
        STA     VARP
        STA     GE
        LDA     GE + 1
        SBC     SIZE + 1
        STA     VARP + 1
        STA     GE + 1
COPYFD
        ; Copy block forward (i.e. to higher address).
        ; Entry - ARGP --> block of size XY
        ;         VARP --> destination address 
        ; Exit  - ARGP,VARP uncorrupted.
        STX     SIZE
        STY     SIZE + 1
CPFD2
        LDA SIZE
        TAY
        ORA     SIZE + 1
        BEQ     CPFDEX
        LDX     SIZE + 1
        CLC
        TXA
        ADC     ARGP + 1
        STA     ARGP + 1
        TXA
        ADC     VARP + 1
        STA     VARP + 1
        INX
        BCC     CPFDL2
CPFDLP
        LDAIY ARGP
        STAIY   VARP
CPFDL2
        DEY
        CPYIM   &FF
        BNE     CPFDLP
        DEX
        BEQ     CPFDEX
        DEC     ARGP + 1
        DEC     VARP + 1
        BNE     CPFDLP
CPFDEX
        RTS
PAGEDN
        LDA PAGELE
        INA
MVLNFD
        JSR TPGEFD
GPFDTP
        LDX TP
        LDY     TP + 1
GPFDXY
        ; Move gap forward so that GE := XY
        LDA     GE
        STA     ARGP
        LDA     GE + 1
        STA     ARGP + 1
        LDA     GS
        STA     VARP
        LDA     GS + 1
        STA     VARP + 1
        SEC
        TXA
        SBC     GE
        TAX
        TYA
        SBC     GE + 1
        TAY
        CLC
        TXA
        ADC     GS
        STA     GS
        TYA
        ADC     GS + 1
        STA     GS + 1
        TXA
        ADC     GE
        STA     GE
        TYA
        ADC     GE + 1
        STA     GE + 1
        JMP     COPYBK
FINEPO
        ; Entry - Gap line positioned, without VS in text.
        ; Exit  - Gap character positioned, with VS added.
        JSR     ADDVIR
        CLC
        LDA     GE
        ADC     SCRNX
        TAX
        LDA     GE + 1
        ADCIM   0
        TAY
        BRA     GPFDXY
ADDVIR
        JSR     VSCOUN
        BEQ     ADVSEX
        PHA
        TAX
        LDA     CURRLE
        JSR     INSRTX
        ; Wipe possible visible TERMIN.
        LDX     CURRLE
        LDY     SCRNY
        JSR     CSRXY
        LDAIM   SPACE
        JSR     OSWRCH
        PLX     ;number spaces from VSCOUN
        LDY     SCRNX
ADVSLP
        DEY
        STAIY   GE
        DEX
        BNE     ADVSLP
ADVSEX
        JMP     CSRSCR
VSCOUN
        ; Exit - A(Z) = Number of virtual spaces.
        SEC
        LDA     SCRNX
        SBC     CURRLE
        BCS     VSCTEX
        LDAIM   0
VSCTEX
        RTS
INSRTX
        ; Entry - Require gap of XY ( > 0) opening up after GE  +  A
        ; Exit  - GE -= XY (checked against GS)
        ;         A chars moved back to new GE, to open up gap
        STA     ATEMP
        CLC
        ADC     GE
        PHA
        LDA     GE + 1
        ADCIM   0
        PHA
        PHX
        LDYIM   0
        JSR     CHECKR
        LDYIM   0
INSXLP
        LDAIY GE
        STAIY   TEMP
        INY
        CPY     ATEMP
        BCC     INSXLP
        STX     GE
        LDA     TEMP + 1
        STA     GE + 1
        PLX
        STX     COUNT
        PLA
        STA     TEMP + 1
        PLA
        STA     TEMP
        LDY     MARKX
INSXMK
        DEY
        BMI     INSXEX
        LDXAY   SMATLO
        CPX     TEMP
        LDAAY   SMATHI
        SBC     TEMP + 1
        BCS     INSXMK
        SEC
        TXA
        SBC     COUNT
        STAAY   SMATLO
        LDAAY   SMATHI
        SBCIM   0
        STAAY   SMATHI
        BRA     INSXMK
INSXEX
        RTS
TABKEY
        LDAIM 8
        BIT     TUTMOD
        BNE     TABSTR
TABPOS
        INC SCRNX
        LDA     SCRNX
        ANDIM   7
        BNE     TABPOS
        LDA     SCRNX
        CMP     PAGEWI
        BCC     TABX
        CLR     SCRNX
        BRA     TABX
TABSTR
        LDAIM 1
        JSR     TPGSBK
        CMPIM   1
        BNE     INSXEX
        LDY     SCRNX
        DEY
TABS1
        INY
        CPY     PAGEWI
        BCS     TABSSP
        LDAIY   TP
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     TABSSP
        CMPIM   " "
        BNE     TABS1
        BRA     TABS2
TABSSP
        LDYIM &FF
TABS2
        INY
        CPY     PAGEWI
        BCS     TABSEX
        LDAIY   TP
        CMPIM   " "
        BEQ     TABS2
TABSEX
        STY     SCRNX
TABX
        CLR     UPDATE
RELANX
        RTS
RETLAN
        JSR     PROMPT
        =       "Type language name:",&EA
        JSR     READLS
        BEQ     RELANX
        LDYIM   0
RELAPL
        LDAAY   LINBUF
        INY
        CMPIM   CR
        BNE     RELAPL
        STAAY   LINBUF + 1
        LDAIM   " "
        STAAY   LINBUF - 1
        LDAIM   "@"
        STAAY   LINBUF
        LDAIM   THELOT
        STA     UPDATE
        JSR     STFILE
        LDA     GE + 1
        DEA
        CMP     PAJE + 1
        BCS     RETLOK
        BRK
        =       &02,"Not enough space to return to language",null
RETLOK
        LDAIM   &FF
        STA     BRKACT          ; pretty lethal break action rqd
        LDA     PAJE + 1
        INA
        STA     ARGP + 1
        CLR     ARGP
        LDAIM   0
        STAI    TMAX            ; terminating zero
        LDA     GE
        STA     ADDR
        LDA     GE + 1
        STA     ADDR + 1
RELLOP
        LDAI    ADDR
        STAI    ARGP
        INC     ARGP
        BNE     RELLOQ
        INC     ARGP + 1
RELLOQ
        INC     ADDR
        BNE     RELLOP
        INC     ADDR + 1
        LDA     ADDR + 1
        CMP     HYMEM + 1
        BNE     RELLOP
        JSR     CURON
        JSR     VSTRNG
        =       26,12,&EA
        JSR     INITUS
        LDA     PAJE + 1
        INA
        STA     STRING + 1  ; set 0 to PAGE + 256
        CLR     STRING
        LDXIM   LINBUF
        LDYIM   /LINBUF
        JMP     OSCLI

prHELP
        = 14,cr,cr,"Format commands:- {initial values}",cr
        = cr
        = ".afrn assign format n to register r {0}",cr
        = ".anrn assign number to register r {0}",cr
        = ".bl   bold line",cr
        = ".bp   begin page",cr
        = ".cc c control character is c {.}",cr
        = ".ce   centre line",cr
        = ".ch*c chain in next file",cr
        = ".co   comment line",cr
        = ".dmcc define macro to .en",cr
        = ".ds   double space lines",cr
        = ".ef   even page foot title to .en",cr
        = ".eh   even page head title to .en",cr
        = ".en   end of .at, .ix or .ef etc",cr
        = ".ep   begin even page",cr
        = ".ff   form feed the printer, wait if paged mode",cr
        = ".fo   even and odd foot title to .en",cr
        = ".he   even and odd head title to .en",cr
        = ".ic   close indexfile",cr
        = ".ig   ignore input until .en",cr
        = ".in+- indent left margin n places {0}",cr
        = ".io*c open indexfile for output",cr
        = ".ix   send text to indexfile until .en",cr
        = ".ju   justify right margin of lines {on}",cr
        = ".ll+- line length including indent {76}",cr
        = ".ls+- line spacing is n {1}",cr
        = ".lv n leave n blank lines (by .ne n and .sp n)",cr
        = ".ne n needs n output lines, .bp if necessary",cr
        = ".nj   no justification of lines",cr
        = ".nn   no new line after this line",cr
        = ".of   odd page foot title to .en",cr
        = ".oh   odd page head title to .en",cr
        = ".op   begin odd page",cr
        = ".os*c call operating system with this string",cr
        = ".pl+- text area length is n lines {58}",cr
        = ".po+- page offset is n {0}",cr
        = ".rf   right flush this line",cr
        = ".sp n insert n blank lines",cr
        = ".ss   single space lines",cr
        = ".ta   define tabs {8,16,24,...,96}",cr
        = ".tcc  define tab character as c {ctrl I}",cr
        = ".ti+- temporary indent n",cr
        = ".trcc translate {ctrl J is space}",cr
        = ".ul   underline line",cr
        = cr
        = "n represents a decimal number, 0 is used if not present",cr
        = "Spaces are allowed before n. c represents any character",cr
        = "+- allows n, +n or -n: .in+2 sets an indent 2 more than current",cr
        = ".ti+2 is a temporary indent of 2 more than the current indent",cr
        = cr,"Formatting commands which can appear anywhere",cr,cr
        = ".bb   begin bold",cr
        = ".bu   begin underline",cr
        = ".eb   end bold",cr
        = ".eu   end underline",cr
        = ".oc n output CHR$(n) to printer counted as 1 char",cr
        = ".on n output CHR$(n) to printer without being counted",cr
        = ".r0-9 contents of register e.g. .r0",15,cr,cr
        = &EA

prinHL
        LDAIM   prHELP
        STA     string
        LDAIM   :MSB: prHELP
        STA     string + 1
        LDAI    string
prinHK
        JSR     osasci
        INC     string
        BNE     prinHM
        INC     string + 1
prinHM
        LDAI    string
        BPL     prinHK
        JSR     inkeys
        JMP     EDITco

        ; ------------------------------------------------------------ ;

        LNK     EDIT04
