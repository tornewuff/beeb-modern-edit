        TTL                             > EDIT05
ROUTNE
        JSR     GETNO
        CMP     LINEOT
        BEQ     OKAY
        BCC     OKAY
ROUTBP
        LDA     LINEOT
        BRA     ALINES
ROUTNJ
        STA     FILL
OKAY
        RTS
ROUTNN
        STA     LINFED
        RTS
ROUTOP
        JSR     ROUTBP
        LDA     PAGE
        LSRA
        BCC     ROUTOP
        RTS
ROUTOS
        CLC
        JSR     YADP
        LDX     ADDR
        LDY     ADDR+1
        JSR     OSCLI
        LDYIM   0
        JMP     ROUTCO
ROUTPL
        LDX     LINEDW
        JSR     MODNO
        TXA
        BEQ     WZERO
        STA     LINEDW
        LDX     LINEOT
        INX
        BEQ     WZERO
        STA     LINEOT
WZERO
        RTS
ROUTPO
        LDX     OFFSET
        JSR     MODNO
        STA     OFFSET
        RTS
ROUTRF
        STA     RFLUSH
        CLR     CENTRE        ; can't have both
        RTS
ROUTSP
        JSR     GETNO
ALINES
        TAX
        BEQ     ALINEX
        PHY
        CMPIM   &FF
        BNE     ALINEL
        JSR     DOHDR
        LDX     LINEOT
ALINEL
        LDA     LINEOT
        INA
        BNE     ALINET
        PHX
        JSR     DOHDR
        PLX
ALINET

        LDAIM   cr              ; ++++
        JSR     oswrch
        JSR     lfwrch

        DEX
        BNE     ALINEL
        PLY
ALINEX
        RTS
ROUTSS
        LDAIM   1
        STA     VSPACE
        RTS
ROUTTA
        CLR     LASTTAB
SETTAB
        JSR     GETNO
        LDX     LASTTAB
        STAAX   TABLST
        CLRAX   TABLST+1
        INC     LASTTAB
        JSR     SPACEY
        CMPIM   ","
        BEQ     SETTAB
        DEY
        RTS
ROUTTC
        LDAIY   ADDR
        STA     TABCHA
        INY
        RTS
ROUTTI
        LDX     TINDEN
        CPXIM   &FF
        BNE     ROUSTI
        LDX     INDENT        ; if no temp indent then use INDENT as base
ROUSTI
        JSR     MODNO
        STX     TINDEN
        RTS
ROUTTR
        LDAIY   ADDR
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     SETTRX
        TAX
        INY
        LDAIY   ADDR
        DEY
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     SETTRX
        INY
        INY
        STAAX   TRNLST
SETTRX
        RTS
ROUTUL
        STA     UNDERL
        STA     UNDRRQ
        RTS
YADP
        TYA
        ADC     ADDR
        STA     ADDR
        BCC     ENDADD
        INC     ADDR+1
ENDADD
        RTS
MODNO
        JSR     SPACEY
        CMPIM   "-"
        BEQ     SUBNO
        CMPIM   "+"
        BEQ     ADDNO
        DEY
        LDXIM   0
ADDNO
        PHX
        JSR     GETNO
        PLX
        CLC
        STX     TEMP
        ADC     TEMP
        BCC     ADDNOX
        LDAIM   0
ADDNOX
        TAX
        RTS
SUBNO
        PHX
        JSR     GETNO
        STA     TEMP
        PLA
        SEC
        SBC     TEMP
        BCS     ADDNOX
        LDAIM   0
        TAX
        RTS
GETNO
        LDXIM   0
        JSR     SPACEY
        DEY
NUMLOP
        LDAIY   ADDR
        CMPIM   "0"
        BCC     ENDNO
        CMPIM   &3A
        BCS     ENDNUM        ; not a decimal digit
        ANDIM   &0F
        PHA
        TXA
        ASLA
        ASLA
        STA     TEMP
        TXA
        CLC
        ADC     TEMP
        ASLA
        STA     TEMP
        PLA
        CLC
        ADC     TEMP
        TAX
        INY
        BRA     NUMLOP
ENDNUM
        CLC
ENDNO
        TXA
        RTS
DOHDR
        LDX     PAGEEH
        LDY     PAGEEH+1
        LDA     PAGE
        LSRA
        BCC     DOHDR1
        LDX     PAGEOH
        LDY     PAGEOH+1
DOHDR1
        DEC     LINEOT
        JSR     MACRO
        LDA     LINEDW
        STA     LINEOT
        LDAIM   1
        STA     LINENO
        LDAIM   15
        TRB     LINENO+1; leave format alone!
        RTS
MACRO
        LDA     ADDR
        PHA
        LDA     ADDR+1
        PHA
        LDA     CTLCHA
        PHA
        LDA     LEN
        PHA
        LDA     INDENT
        PHA
        LDA     TINDEN
        PHA
        LDA     BOLD
        PHA
        LDA     PBOLD
        PHA
        LDA     BOLDRQ
        PHA
        LDA     UNDERL
        PHA
        LDA     PUNDRL
        PHA
        LDA     UNDRRQ
        PHA
        LDA     FILL
        PHA
        LDA     VSPACE
        PHA
        LDA     CENTRE
        PHA
        LDA     RFLUSH
        PHA
        LDA     LINFED
        PHA
        CLR     LINFED
        CLR     FILL
        CLR     PBOLD
        CLR     PUNDRL
        CLR     INDENT
        LDAIM   1
        STA     VSPACE
        STX     ADDR
        STY     ADDR+1
        LDAI    ADDR
        STA     CTLCHA
        LDYIM   3
        CLC
        JSR     YADP; skip definition
        JSR     FINE
        PLA
        STA     LINFED
        PLA
        STA     RFLUSH
        PLA
        STA     CENTRE
        PLA
        STA     VSPACE
        PLA
        STA     FILL
        PLA
        STA     UNDRRQ
        PLA
        STA     PUNDRL
        PLA
        STA     UNDERL
        PLA
        STA     BOLDRQ
        PLA
        STA     PBOLD
        PLA
        STA     BOLD
        PLA
        STA     TINDEN
        PLA
        STA     INDENT
        PLA
        STA     LEN
        PLA
        STA     CTLCHA
        PLA
        STA     ADDR+1
        PLA
        STA     ADDR
        RTS
VDUBIT
        TAY
        LDAAY   TRNLST
        STA     SCRATCH
        JSR     XYSCRATCH
        LDAIM   10
        JMP     OSWORD
DOVDU
        BIT     BOLD
        BPL     VDUNBL
; bold character
        PHY
        PHX
        JSR     VDUBIT
        LDXIM   7
VDUBLD
        LDAAX   SCRATCH+1
        LSRA
        ORAAX   SCRATCH+1
        STAAX   SCRATCH+1
        DEX
        BPL     VDUBLD
        BIT     UNDERL
        BPL     VDUDON
; both bold and underline
        BRA     VDUUND
VDUNBL
        BIT     UNDERL
        BPL     WRCHA
; underline character
        PHY
        PHX
        JSR     VDUBIT
VDUUND
        LDA     SCRATCH+8
        LSRA
        RORA
        ORA     SCRATCH+8
        ROLA
        EORIM   &FF
        TSB     SCRATCH+8
VDUDON
        LDAIM   23
        JSR     OSWRCH
        LDAIM   32
        JSR     OSWRCH
        LDXIM   1
VDUPRG
        LDAAX   SCRATCH
        JSR     OSWRCH
        INX
        CPXIM   9
        BNE     VDUPRG
        JSR     VSTRNG
        =       32,23,32,0,0,0,0,0,0,0,0,&EA
        PLX
        PLY
        RTS
ESCAP
        LDAIM   &7E
        JSR     OSBYTE
        JMP     DODWN

fmwrch
        BIT     ESCFLG
        BMI     ESCAP        ; must not go via SENTRY,
                             ; because of marked mode (SWOPCH)
        BIT     DOINDX
        BMI     DOINDE

        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin        ; changed from CMPIM " "; BCC WRCHA
        ]
        BEQ     wrchen

        BIT     PRTFLG
        BMI     DOVDU
        BVS     NOULA

        LDAIM   " "
        BIT     UNDERL
        BPL     NOULA
        LDAIM   "_"
NOULA
        PHA

        LDAIM   &20
        BIT     PRTFLG
        BNE     NOBBLE
        BIT     BOLD
        BMI     NOBBLE

        LDAIM   " "
        JSR     OSWRCH
        PLA
        RTS

NOBBLE
        PLA
WRCHA
        PHY
        TAY
        LDAAY   TRNLST
        PLY
        [ cf8key=1
wrch
        JMI     &020E
wrchen
        LDAIM   cr
        BRA     wrch
        |
        [ termin=cr
wrchen
wrch
        JMI     &20E
        |
wrch
        JMI     &20E
wrchen
        LDAIM   cr
        BRA     wrch
        ]
        ]
DOINDE
        PHY
        TAY
        LDAAY   TRNLST
        LDY     INDEXH
        BEQ     DOINDF
        JSR     OSBPUT
DOINDF
        PLY
        RTS

lfwrch
        BIT     doindX
        BMI     writeX
        LDAIM   lf        ; write a real line feed
        INC     lineno
        BNE     fmwrca
        INC     lineno + 1
fmwrca
        DEC     lineot
        BNE     wrch
        JSR     oswrch
        PHX
        PHY
        LDX     pageef
        LDY     pageef + 1
        LDA     page
        LSRA
        BCC     doftr1
        LDX     pageof
        LDY     pageof + 1
doftr1
        DEC     lineot
        DEC     lineot
        JSR     macro
        LDAIM   &FF
        STA     lineot        ; set needs header
        INC     page
        BNE     HI
        INC     page + 1
HI
        PLY
        PLX
writeX
        RTS
write
        LDAIM   &20
        TSB     prtflg
        LDA     bold
        PHA
        JSR     DOSCRE
        PLA
        STA     BOLD
        BIT     BOLDRQ
        BPL     WRITEX
        LDAIM   &20
        TRB     PRTFLG
        JSR     DOSCRE 
        LDAIM   &20
        TSB     PRTFLG
        RTS
DOSCRE
        LDA     OFFSET
        JSR     SCMVTO
        CLR     DIFF
        LDA     XEFF
        BNE     SCREEA
        SEC
        LDA     JUSLEN
        SBC     COUNT
        STA     DIFF
SCREEA
        LDA     TINDEN
        CMPIM   &FF
        BNE     SCREEB
        LDA     INDENT
SCREEB
        JSR     SCMVTO
        LDA     CENTRE
        BPL     SCREED
        SEC
        LDA     JUSLEN
        INA
        SBC     COUNT
        JSR     MOVE
SCREED
        BIT     RFLUSH
        BPL     SCREEQ
        SEC
        LDA     JUSLEN
        ADCIM   1
        SBC     COUNT
        JSR     SCMVTO
SCREEQ
        LDYIM   0
        LDXIM   0
        LDA     SPACES
        BEQ     SCREEE
        LSRA
        STA     L
        LDAIM   0
        BIT     FILL
        BMI     SENA
        LDA     DIFF
SENA
        LDXIM   1
DODIV
        CMP     SPACES
        BCC     DONDIV
        INX
        SBC     SPACES 
        BCS     DODIV
DONDIV
        STX     Q
        STA     DIFF
        LDXIM   0
SCREEE
        JSR     CHKCTL

        CMPIM   cr              ; ++++
        BEQ     SCREEG

        CMP     TABCHA
        BNE     SCREES
        TXA
        LDXIM   &FF
SCRTAB
        INX
        PHA
        LDAAX   TABLST
        BEQ     SCRNTB
        PLA
        CMPAX   TABLST
        BCS     SCRTAB
        SEC
        SBCAX   TABLST
        EORIM   &FF
        INA
        PHX
        JSR     SCMVTO
        PLX
        LDAAX   TABLST
        TAX
        DEX
        BRA     NOUL
SCRNTB
        PLX
        LDAIM   " "
SCREES
        CMPIM   " "
        BNE     SCREEF
        CPX     LASTTAB
        BCC     SCREEF
        PHX
        LDX     Q
SCRJUS
        DEX
        BEQ     NOMOV
        LDAIM   " "
        JSR     FMWRCH
        BRA     SCRJUS
NOMOV
        PLX
        SEC
        LDA     L
        SBC     DIFF
        STA     L
        BCS     ENDJUS
        ADC     SPACES
        STA     L
        LDAIM   " "
        JSR     FMWRCH
ENDJUS
        LDAIM   " "
SCREEF
        JSR     FMWRCH
NOUL
        INY
        INX
        CPX     COUNT
        BCC     SCREEE

        LDAIM   cr              ; ++++
screeG
        JMP     fmwrch

closeX
        LDY     INDEXH
        BEQ     CLOSEE
        CLR     INDEXH
        LDAIM   &00
        JSR     OSFIND        ; close index file
closee
        RTS

SCMVTO
        ASLA
MOVE
        LSRA
        BEQ     MOVEX
        TAX
        LDAIM   9
        BIT     PRTFLG
        BMI     MLOOP
        LDAIM   " "
MLOOP
        BIT     DOINDX
        BPL     MLOOPA
        LDAIM   " "
        JSR     DOINDE
        BRA     MLOOPB
MLOOPA
        JSR     OSWRCH
MLOOPB
        DEX
        BNE     MLOOP
MOVEX
        RTS
INKEYS
        JSR     STRIMO
        =       "Press SHIFT to continue",&EA
INKEY
        PHX
        PHY
INKEYL
        JSR     ESCTST
        LDXIM   &FF
        LDYIM   &FF
        LDAIM   &81
        JSR     OSBYTE
        CPXIM   &FF
        BNE     INKEYL
        LDAIM   15
        LDXIM   &FF
        JSR     OSBYTE
        PLY
        PLX
        RTS
DECCON
        PHX            ; reg in A to print buff. INX by # chars
        PHY
        ANDIM   15
        ASLA
        TAX
        LDAAX   NOREGS
        STA     TEMP
        LDAAX   NOREGS+1
        TAX
        ANDIM   15
        STA     TEMP+1
        ORA     TEMP
        PHP
        TXA
        LSRA
        LSRA
        LSRA
        LSRA
        PLP
        BNE     NMLTST
        CMPIM   8
        BCC     DECANY
        LDAIM   0
        BRA     DECANY
NMLTST
        CMPIM   8
        BCS     ROMAN
DECANY
        PHA
        LDXIM   4
        LDAIM   "0"
        STA     BUFF+5
        STA     BUFF+6
        STA     BUFF+7
NUMLAP
        LDAIM   "0"
        STAAX   BUFF
        SEC
NUMLP
        LDA     TEMP
        SBCAX   WOPTBL
        TAY
        LDA     TEMP+1
        SBCAX   WOPTBH
        BCC     OUTNUM
        STY     TEMP
        STA     TEMP+1
        INCAX   BUFF
        BNE     NUMLP
OUTNUM
        DEX
        BPL     NUMLAP
        PLA
        STA     TEMP
        LDXIM   8
LZB
        DEX
        CPX     TEMP
        BEQ     LASTZ
        LDAAX   BUFF
        ANDIM   15
        BEQ     LZB
LASTZ
        STX     TEMP
        PLY
        PLA
        SEC
        ADC     TEMP
        TAX
        RTS
ROMAN
        PHA
        CMPIM   10
        BCS     AAA
        LDAIM   &FF
        PHA
        LDXIM   12
ROMANL
        SEC
        LDA     TEMP
        SBCAX   NUMERL
        TAY
        LDA     TEMP+1
        SBCAX   NUMERH
        BCC     ROMANO
        STY     TEMP
        STA     TEMP+1
        TXA
        ASLA
        TAY
        LDAAY   CHARS
        PHA
        LDAAY   CHARS+1
        CMPIM   " "
        BEQ     ROMANL
        PHA
        BRA     ROMANL
ROMANO
        DEX
        BPL     ROMANL
ROMANG
        PLA
        INX
        STAAX   BUFF
        CMPIM   &FF
        BNE     ROMANG
        DEX
CASECH
        PLA
        ANDIM   1
        BEQ     LASTZ
        STX     TEMP
CASELP
        LDAAX   BUFF
        ORAIM   &20
        STAAX   BUFF
        DEX
        BPL     CASELP
        LDX     TEMP
        BRA     LASTZ
AAA
        LDA     TEMP
        BNE     AAADEC
        DEC     TEMP+1
AAADEC
        DEC     TEMP
        LDYIM   0
AAALOP
        LDA     TEMP
        SEC
AAALOQ
        INY
        SBCIM   26
        BCS     AAALOQ
        STA     TEMP
        LDA     TEMP+1
        BEQ     AAAGOT
        DEC     TEMP+1
        BRA     AAALOP
AAAGOT
        LDA     TEMP
        ADCIM   26+"A"
        LDXIM   0
AAALON
        STAAX   BUFF
        INX
        DEY
        BNE     AAALON
        DEX
        BRA     CASECH
NUMERL
        =       1,4,5,9,10,40,50,90,100,400,500,900,1000
NUMERH
        =       /1,/4,/5,/9,/10,/40,/50,/90,/100,/400,/500,/900,/1000
CHARS
        =       "I IVV IXX XLL XCC CDD DMM "
CMDS
        =       "af"
        &       ROUTAF
        =       "an"
        &       ROUTAN
        =       "bl"
        &       ROUTBL
        =       "bp"
        &       ROUTBP
        =       "cc"
        &       ROUTCC
        =       "ce"
        &       ROUTCE
        =       "ch"
        &       ROUTCH
        =       "co"
        &       ROUTCO
        =       "dm"
        &       ROUTDM
        =       "ds"
        &       ROUTDS
        =       "ef"
        &       ROUTEF
        =       "eh"
        &       ROUTEH
        =       "en"
        &       ROUTEN
        =       "ep"
        &       ROUTEP
        =       "ff"
        &       ROUTFF
        =       "fo"
        &       ROUTFO
        =       "he"
        &       ROUTHE
        =       "ic"
        &       ROUTIC
        =       "ig"
        &       ROUTIG
        =       "in"
        &       ROUTIN
        =       "io"
        &       ROUTIO
        =       "ix"
        &       ROUTIX
        =       "ju"
        &       ROUTJU
        =       "ll"
        &       ROUTLL
        =       "ls"
        &       ROUTLS
        =       "lv"
        &       ROUTLV
        =       "ne"
        &       ROUTNE
        =       "nj"
        &       ROUTNJ
        =       "nn"
        &       ROUTNN
        =       "of"
        &       ROUTOF
        =       "oh"
        &       ROUTOH
        =       "op"
        &       ROUTOP
        =       "os"
        &       ROUTOS
        =       "pl"
        &       ROUTPL
        =       "po"
        &       ROUTPO
        =       "rf"
        &       ROUTRF
        =       "sp"
        &       ROUTSP
        =       "ss"
        &       ROUTSS
        =       "ta"
        &       ROUTTA
        =       "tc"
        &       ROUTTC
        =       "ti"
        &       ROUTTI
        =       "tr"
        &       ROUTTR
        =       "ul"
        &       ROUTUL
NOCMDS  *       ( . - CMDS )


        [ cf8key=1
                                ; before printing, defaults are copied
                                ; into private workspace buffer
                                ; and nulls replaced with 'clterm'

defhdr
        =       "$dhtext"

defftr
        =       "$dftext"

        |
DEFHDR
        =       ".he",termin
        =       ".en",termin
DEFFTR
        =       ".fo",termin
        =       ".ce",termin
        =       "Page .r0",termin
        =       ".ff.en",termin
        ]

        LNK         EDIT06
