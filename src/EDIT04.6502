                ; the formatter -> EDIT04
PRINTH
        JMP         PRINHL        ; help on print
PRINT
        JSR     MKREFUSE
        LDXIM   &FF
        STX     PWTFLG
        STX     PRTFLG        ; bit 7 printer, bit 6 pay attention to bold/underlining
        STX     LINEOT        ; set needs header flag
        TXS
        JSR     PROMPT
        =       "Screen, Printer, Help ?",&EA
PRINTL
        JSR     GETRESP
        CMPIM   "h"
        BEQ     PRINTH
        CMPIM   "s"
        BEQ     PRINTS
        CMPIM   "p"
        BNE     PRINTL
        CLR     PRTFLG        ; 0 for printer
PRINTS
        JSR     PROMPT
        =       "Continuous, Paged ?",&EA
PRINTM
        JSR     GETRESP
        CMPIM   "c"
        BEQ     PRINTC
        CMPIM   "p"
        BNE     PRINTM
        CLR     PWTFLG        ; 0 for paged output
PRINTC
        JSR     MEMSTATE
        LDA     TSTART
        STA     ADDR
        LDA     TSTART+1
        STA     ADDR+1
        LDAIM   "."
        STA     CTLCHA
        LDXIM   0
CLRREG
        CLRAX   noregs        ; clears noregs, tablst, maclst
        INX
        TXA
        STAAX   trnlst        ; init translation
        BNE     clrreg

        [ cf8key=1
        PHX                     ; set X to correct offset
        SEC
        LDAIM   cr
        SBCZ    clterm
        CLC
        ADCIM   lf
        TAX
        ]

        LDAIM   " "

        [ cf8key=1
        STAAX   trnlst
        PLX
        |
        STA     trnlst + lf + (cr - termin) 
        ]

        LDAIM   &09
        STA     TABCHA
        DEA                   ; to 8
        CLC
DEFTAB
        STAAX   TABLST
        INX
        ADCIM   8        ; carry clear
        CMPIM   100
        BCC     DEFTAB
        LDAIM   2
        STA     BRKACTION
        DEA
        STA     PAGE        ; A=1
        STA     VSPACE        ; single spacing
        STA     LINENO
        CLR     DOINDX        ; no indexing
        CLR     INDEXH        ; index file handle
        CLR     PUNDRL        ; persistent underline off
        CLR     PBOLD        ; persistent bold off
        CLR     INDENT        ; turn off indent
        CLR     FILL        ; enable justification
        CLR     OFFSET        ; no page offset
        CLR     LINFED        ; no overprinting
        LDAIM   58
        STA     LINEDW        ; lines per page
        LDAIM   76
        STA     LEN        ; characters per line
        JSR     VSTRNG
        =       26,12,&EA
        BIT     PRTFLG
        BMI     PATCHA
        LDXIM   0        ; just for jes's code, set and reset printer type
        LDAIM   5
        JSR     OSBYTE
        JSR     OSBYTE
        LDAIM   2
        JSR     OSWRCH
PATCHA
        BIT     PWTFLG
        BMI     CHAINB
        BIT     PRTFLG
        BPL     CHAINB
        LDAIM   14
        JSR     OSWRCH        ; page mode if screen and page wait
CHAINB
        [ cf8key=1
        LDAZ    clterm
        |
        LDAIM   termin
        ]
        STAI    GS

        [ cf8key=1
                                ; Copy initial header and footer texts
                                ; into their respective buffers, changing
                                ; any nulls into the 'clterm' value

                                ; AX can be corrupted since X is loaded
                                ; with an immediate value straight after

        LDXIM   (dhsize - 1)    ; size of header
mhlp        
        LDAAX   defhdr          ; default header
        BNE     nhchan

        LDAZ    clterm
nhchan
        STAAX   dhbuff          ; and into the buffer

        DEX
        BPL     mhlp            ; move header loop

        LDXIM   (dfsize - 1)    ; size of footer
mflp        
        LDAAX   defftr          ; default footer
        BNE     nfchan

        LDAZ    clterm
nfchan
        STAAX   dfbuff          ; and into the buffer

        DEX
        BPL     mflp            ; move footer loop


        LDAIM   :LSB: dhbuff
        STA     pageeh
        STA     pageoh
        LDAIM   :MSB: dhbuff
        STA     pageeh + 1
        STA     pageoh + 1

        LDAIM   :LSB: dfbuff
        STA     pageef
        STA     pageof
        LDAIM   :MSB: dfbuff
        STA     pageef + 1
        STA     pageof + 1
        |
        LDAIM   DEFHDR
        STA     PAGEEH
        STA     PAGEOH
        LDAIM   :MSB: DEFHDR
        STA     PAGEEH+1
        STA     PAGEOH+1
        LDAIM   DEFFTR
        STA     PAGEEF
        STA     PAGEOF
        LDAIM   :MSB: DEFFTR
        STA     PAGEEF+1
        STA     PAGEOF+1        ; initial header and footer info
        ]

        LDXIM   maxMAC
CHAINC
        CLRAX   MACLST-1
        DEX
        BNE     CHAINC
FINE
        CLR     CENTRE        ; turn centre off
        CLR     RFLUSH        ; turn right-flush off
        LDAIM   &FF
        STA     TINDEN        ; no temp indent
        LDA     PUNDRL
        STA     UNDERL
        STA     UNDRRQ        ; underline required?
        LDA     PBOLD
        STA     BOLD
        STA     BOLDRQ        ; bold required?
        BRA     CTLIN
LASLEN
        JSR     ROUTBP
        BIT     PRTFLG        ; print exit
        BPL     DODWN
        JSR     STRIMO
        =       "Print done. ",&EA
        JSR     INKEYS
DODWN
        JSR     VSTRNG
        =       3,15,&EA
        JSR     CLOSEX
        LDX     GS
        LDY     GS+1
        JMP     EDITGS
CTLLMT
        LDYIM   3        ; found built in cmd
        JSR     CTLLDO
CTLLMX
        JSR     SPACEY
        DEY
        CLC
        JSR     YADP
        LDAI    ADDR
        CMP     CTLCHA
        BEQ     CTLIN1
        LDYIM   0
CLCTLI
        JSR     ROUTCO
        SEC
        JSR     YADP
CTLIN
        LDA     ADDR+1
        STA     XEFF        ; set nojust(local) by <>
        CMPIM   /CTLIN
        BCS     CTLIN1
        LDX     ADDR
        CPX     GS
        SBC     GS+1
        BCS     LASLEN
CTLIN1
        LDAI    ADDR
        CMP     CTLCHA
        BNE     LINLYX
        LDXIM   0        ; main control scan
        LDYIM   2
        LDAIY   ADDR
        STA     TEMP+1
        DEY
        LDAIY   ADDR
CTLLLP
        CMPAX   CMDS
        BNE     CTLLLL
        LDYAX   CMDS+1
        CPY     TEMP+1
        BEQ     CTLLMT
CTLLLL
        INX
        INX
        INX
        INX
        CPXIM   NOCMDS
        BNE     CTLLLP
        JSR     MACCHK
        BCC     LINLYX
        LDA     ADDR
        PHA
        LDA     ADDR+1
        PHA
        LDA     CTLCHA
        PHA
        LDAI    BUFF
        STA     CTLCHA
        LDA     BUFF
        STA     ADDR
        LDA     BUFF+1
        STA     ADDR+1
        LDYIM   2
        JSR     CLCTLI
        PLA
        STA     CTLCHA
        PLA
        STA     ADDR+1
        PLA
        STA     ADDR
        LDYIM   3
        BRA     CTLLMX
LINLYX
        LDA     LINEOT
        INA
        BNE     NOHDR
        JSR     DOHDR
NOHDR
        LDA     LEN
        LDY     TINDEN
        INY
        SEC
        BEQ     SBCLEN
        SBC     TINDEN        ; take off temp indent
        BRA     GOTLEN
SBCLEN
        SBC     INDENT        ; so take off indent
GOTLEN
        STA     JUSLEN
        LDYIM   0
        LDXIM   0
        CLR     SPACES        ; initialize spaces encountered
        CLR     LASTTAB        ; initialize start of spacing out
LINLEN
        CPYIM   250
        BCS     LENFNE
        JSR     IGNCTL        ; main char count
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     LENFNE
        CMP     TABCHA
        BNE     NOTTAB
        TXA
        LDXIM   &FF
LOKTAB
        INX
        PHA
        LDAAX   TABLST
        BEQ     NOTAB
        PLA
        CMPAX   TABLST
        BCS     LOKTAB
        PHA
        LDAAX   TABLST
        PLX
        INY
        CMP     JUSLEN
        BCS     NOTAB2
        TAX
        STX     LASTSP
        STX     LASTTAB
        CLR     SPACES
        BRA     NOSP2
NOTAB
        PLX
        LDAIM   " "
NOTTAB
        CMPIM   " "
        BNE     NOSP
        STX     LASTSP
        INC     SPACES
NOSP
        INX
        INY
NOSP2
        CPX     JUSLEN
        BCC     LINLEN
NOTAB2
        JSR     IGNCTL
        CMPIM   " "
        BEQ     LENFNA
        CMP     TABCHA
        BEQ     LENFNA
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     LENFNA
        LDA     SPACES
        BEQ     LENFNA
        LDX     LASTSP
        DEC     SPACES
LENFNA
        DEX
        CLR     XEFF
LENFNE
        INX
        STX     COUNT        ; X, Y free
        BIT     PRTFLG
        BPL     DODW
        JSR     DOSCRE
        BRA     LINCTL
DODW
        LDAIM   &40
        TSB     PRTFLG        ; no underline first time
        LDA     UNDERL
        PHA
        JSR     WRITE
        PLA
        STA     UNDERL
        BIT     UNDRRQ
        BPL     LINCTL
        LDAIM   &40        ; now do underline
        TRB     PRTFLG
        JSR     DOSCRE
        CLR     UNDERL
LINCTL
        BIT     LINFED
        BMI     FINSEN
        LDX     VSPACE
LINSCT
        JSR     LFWRCH        ; ready for next line
        LDA     LINEOT
        INA
        BEQ     FINSEN
        DEX
        BNE     LINSCT
FINSEN
        CLR     LINFED        ; back on, for next line
        JSR     SPACEY
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     NICEDL
        DEY
NICEDL
        CLC
        JSR     YADP
        JMP     FINE
SPACEY
        LDAIY   ADDR
        INY
        BEQ     SPACER
        CMPIM   " "
        BEQ     SPACEY
SPACER
        RTS
IGNCTL
        LDAIY   ADDR        ; count routine
        CMP     CTLCHA
        BNE     NOCTRL
        INY
        LDAIY   ADDR
        CMPIM   "b"
        BEQ     WSCTRB
        CMPIM   "o"
        BEQ     WSCTRO
        CMPIM   "r"
        BEQ     WSCTRR
        CMPIM   "e"
        BNE     NORECG
WSCTRB
        INY
        LDAIY   ADDR
        CMPIM   "b"
        BEQ     WSCTRL
        CMPIM   "u"
        BNE     NORECF
WSCTRL
        INY
        BRA     IGNCTL
WSCTRO
        INY
        LDAIY   ADDR
        CMPIM   "n"
        BEQ     WSCTON
        CMPIM   "c"
        BNE     NORECF
        INX
WSCTON
        PHX
        INY
        JSR     GETNO
        PLX
        BRA     IGNCTL
WSCTRR
        INY
        LDAIY   ADDR
        CMPIM   "0"
        BCC     NORECF
        CMPIM   &3A
        BCS     NORECF
        JSR     DECCON
        BRA     WSCTRL
NORECF
        DEY
NORECG
        DEY
        LDAIY   ADDR
NOCTRL
        RTS
WASCTL
        INY
CHKCTL
        LDAIY   ADDR        ; print routine
        CMP     CTLCHA
        BNE     NOCTRL
        INY
        LDAIY   ADDR
        CMPIM   "b"
        BEQ     WASCTB
        CMPIM   "o"
        BEQ     WASCTO
        CMPIM   "r"
        BEQ     WASCTR
        CMPIM   "e"
        BNE     NORECG
        INY
        LDAIY   ADDR
        CMPIM   "b"
        BEQ     WASCTEB
        CMPIM   "u"
        BNE     NORECF
        CLR     PUNDRL
        CLR     UNDERL
        BRA     WASCTL
WASCTEB
        CLR     PBOLD
        CLR     BOLD
        BRA     WASCTL
WASCTB
        INY
        LDAIY   ADDR
        CMPIM   "b"
        BEQ     WASCTA
        CMPIM   "u"
        BNE     NORECF
        LDAIM   &FF
        STA     UNDERL
        STA     PUNDRL
        STA     UNDRRQ
        BRA     WASCTL
WASCTA
        LDAIM   &FF
        STA     PBOLD
        STA     BOLDRQ
        STA     BOLD
        BRA     WASCTL
WASCTO
        INY
        LDAIY   ADDR
        CMPIM   "n"
        BEQ     WASCON
        CMPIM   "c"
        BNE     NORECF
        INX
WASCON
        PHX
        INY
        JSR     GETNO
        LDAIM   1
        JSR     OSWRCH
        TXA
        JSR     OSWRCH
        PLX
        BRA     CHKCTL
WASCTR
        INY
        LDAIY   ADDR
        CMPIM   "0"
        BCC     NORECF
        CMPIM   &3A
        BCS     NORECF
        JSR     DECCON
        PHX
        LDX     TEMP
OUTCON
        LDAAX   BUFF
        JSR     FMWRCH        ; ul!!
        DEX
        BPL     OUTCON
        PLX
        JMP     WASCTL
CTLLDO
        LDAIM   &FF
        JMIX    CMDS+2
ROUTAF
        JSR     GETNO
        ANDIM   15
        ASLA
        TAX
        LDAAX   NOREGS+1
        ANDIM   15
        STAAX   NOREGS+1
        INY            ; skip some delimter
        PHX
        JSR     GETNO
        PLX
        ASLA
        ASLA
        ASLA
        ASLA
        ORAAX   NOREGS+1
        STAAX   NOREGS+1
        RTS
ROUTAN
        JSR     GETNO
        ANDIM   15
        ASLA
        PHA
        LDAIY   ADDR
        INY            ; skip delimter
        PHA
        JSR     GETNO
        PLA
        CMPIM   "+"
        BEQ     ADDREG
        CMPIM   "-"
        BEQ     SUBREG
        CMPIM   "="
        BEQ     MOVREG
        TXA
        PLX
        STAAX   NOREGS
        LDAAX   NOREGS+1
        ANDIM   &F0
        STAAX   NOREGS+1
        RTS
ADDREG
        CLC
        STX     BUFF
        PLX
        LDAAX   NOREGS
        ADC     BUFF
        STAAX   NOREGS
        LDAAX   NOREGS+1
        ADCIM   0
        STAAX   NOREGS+1
        RTS
SUBREG
        STX     BUFF
        PLX
        LDAAX   NOREGS
        SBC     BUFF
        STAAX   NOREGS
        LDAAX   NOREGS+1
        SBCIM   0
        STAAX   NOREGS+1
        RTS
MOVREG
        TXA
        ANDIM   15
        ASLA
        TAX
        LDAAX   NOREGS+1
        ANDIM   15
        STA     BUFF
        LDAAX   NOREGS
        PLX     
        STAAX   NOREGS
        LDAAX   NOREGS+1
        ANDIM   &F0
        ORA     BUFF
        STAAX   NOREGS+1
        RTS
ROUTBL
        STA     BOLD
        STA     BOLDRQ
        RTS
ROUTCC
        LDAIY   ADDR
        STA     CTLCHA
        INY
        RTS
ROUTCE
        STA     CENTRE
        CLR     RFLUSH        ; can't have both
        RTS
ROUTCH
        LDA     ADDR
        STA     TEMP
        LDA     ADDR+1
        STA     TEMP+1        ; move filename pointer
        LDA     TSTART
        STA     ADDR
        LDA     TSTART+1
        STA     ADDR+1
        LDA     TMAX
        LDX     TMAX+1
        JSR     PASLNM
        JSR     PASGO
        STX     GS
        STY     GS+1
        LDXIM   &FF
        TXS
        JMP     CHAINB
MACCHK
        STA     TEMP        ; check for macro: A=lo, TEMP+1=hi
        LDXIM   -2
MACCHL
        INX
        INX
        CPXIM   MAXMAC
        BCS     MACCHX
        LDAAX   MACLST
        STA     BUFF
        LDAAX   MACLST+1
        STA     BUFF+1
        BEQ     MACCHZ
        PHY
        LDYIM   3
MACSPC
        LDAIY   BUFF
        INY
        CMPIM   " "
        BEQ     MACSPC
        STA     BUFF+2
        LDAIY   BUFF
        PLY
        CMP     TEMP+1
        BNE     MACCHL
        LDA     BUFF+2
        CMP     TEMP
        BNE     MACCHL
        RTS            ; found CS,EQ
MACCHX
        CLC            ; not found, no space CC,NE
        TXA
MACCHZ
        RTS            ; not found, at space CC,EQ
DMEXIT
        DEY
        RTS
ROUTDM
        JSR     SPACEY
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     DMEXIT
        CMP     CTLCHA
        BEQ     DMEXIT
        STA     TEMP+1
        LDAIY   ADDR
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     DMEXIT
        JSR     MACCHK
        BNE     DMEXIT
        LDA     ADDR
        STAAX   MACLST
        LDA     ADDR+1
        STAAX   MACLST+1
        BRA     SKIPEN
ROUTDS
        LDAIM   2
        STA     VSPACE
        RTS
ROUTOF
        LDA     ADDR
        STA     PAGEOF
        LDA     ADDR+1
        STA     PAGEOF+1
        BRA     SKIPEN
ROUTOH
        LDA     ADDR
        STA     PAGEOH
        LDA     ADDR+1
        STA     PAGEOH+1
        BRA     SKIPEN
ROUTFO
        LDA     ADDR
        STA     PAGEOF
        LDA     ADDR+1
        STA     PAGEOF+1
ROUTEF
        LDA     ADDR
        STA     PAGEEF
        LDA     ADDR+1 
        STA     PAGEEF+1
ROUTIG
        BRA     SKIPEN
ROUTHE
        LDA     ADDR
        STA     PAGEOH
        LDA     ADDR+1
        STA     PAGEOH+1
ROUTEH
        LDA     ADDR
        STA     PAGEEH
        LDA     ADDR+1
        STA     PAGEEH+1
SKIPEN
        CLC
        JSR     YADP
SKIPEM
        LDAI    ADDR
        INC     ADDR
        BNE     SKIPEK
        PHA
        INC     ADDR+1
        LDA     ADDR
        CMP     GS
        LDA     ADDR+1
        SBC     GS+1
        BCS     SKIPEX
        PLA
SKIPEK
        CMP     CTLCHA
        BNE     SKIPEM
        LDAI    ADDR
        CMPIM   "e"
        BNE     SKIPEM
        LDYIM   1
        LDAIY   ADDR
        CMPIM   "n"
        BNE     SKIPEM
        INY
SKIPEX
        RTS
ROUTEN
        TSX
        CPXIM   &FD
        BCS     SKIPEX        ; check for possible to do it
        PLA
        PLA
        RTS            ; return a macro level
ROUTEP
        JSR     ROUTBP
        LDA     PAGE
        LSRA
        BCS     ROUTEP
        RTS
ROUTFF
        LDA     PWTFLG
        BMI     NOWAIT
        LDA     PRTFLG
        BPL     PRTWAT
        JSR     INKEY
NOWAIT
        LDAIM   12
        JMP     OSWRCH
PRTWAT
        JSR     NOWAIT
        JMP     INKEY
ROUTIC
        PHY
        JSR     CLOSEX
        PLY
        RTS
ROUTIN
        LDX     INDENT
        JSR     MODNO
        STX     INDENT
        RTS
ROUTIO
        CLC
        JSR     YADP
        JSR     CLOSEX
        LDX     ADDR
        LDY     ADDR+1
        LDAIM   &80
        JSR     OSFIND
        STA     INDEXH
        LDYIM   0
ROUTCO
        [ cf8key=1
        LDAZ    clterm
        |
        LDAIM   termin
        ]
        BRA     SKIPL1
SKIPLP
        INY
        BNE     SKIPL1
        INC     ADDR+1
SKIPL1
        CMPIY   ADDR
        BNE     SKIPLP
        RTS
ROUTIX
        STA     DOINDX
        CLC
        JSR     YADP
        LDA     LINEOT
        PHA
        LDAIM   &FD
        STA     LINEOT
        JSR     CTLIN
        PLA
        STA     LINEOT
        CLR     DOINDX
        RTS
ROUTJU
        CLR     FILL
        RTS
ROUTLL
        LDX     LEN
        JSR     MODNO
        STA     LEN
        RTS
ROUTLS
        LDX     VSPACE
        JSR     MODNO
        STX     VSPACE
        RTS
ROUTLV
        JSR     GETNO
        CMP     LINEOT
        BEQ     OKAYLV
        BCC     OKAYLV
        PHA
        JSR     ROUTBP
        PLA
OKAYLV
        JMP     ALINES

        LNK     EDIT05
