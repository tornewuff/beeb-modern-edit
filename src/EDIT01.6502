        TTL     EDIT text editor        > EDIT01

        ; ------------------------------------------------------------ ;

origin
pasROM
        JMP     langua
        [ reladd=0
        JMP     servic
        |
        JMP     ((servic - origin) + &8000)
        ]

        [ reladd=0
        =       &C2                     ; Type flag
        |
        =       &E2                     ; relocation address provided
        ]

        =       copyri - pasROM
        =       &02
        =       "Edit"
        =       null
        =       "$vers"
copyri  
        =       null
        =       "(C)1984 Acorn"
        =       null

        [ reladd=1
        &       reladr                  ; relocation value
        &       &0000                   ; Top 2 bytes
        ]

rom1br
        ;Outputs 'brk' error message, & jumps to relevant re-entry
        ;point. Detailed action depends on value of 'brkaction' on entry -
        ; brkaction = 0 Moves cursor to editor status position,
        ; outputs error message, then prompts for space
        ; before jumping to editcont.
        ; 1    Outputs error message, and jumps to starloop.
        ; 2    resets to start of file and closes indexfile, then as 0

        LDXIM   &FF
        TXS
        STZ     cursed
        LDAIM   &7E
        JSR     osbyte
        LDA     BRKact
        CMPIM   &FF
        BNE     simBRK
unret
        LDA     addr
        BNE     unreta
        DEC     addr + 1
unretA
        DEC     addr
        LDA     argP
        BNE     unretb
        DEC     argP + 1
unretB
        DEC     argP
        LDAI    argP
        STAI    addr
        LDA     addr
        BNE     unret
        LDA     addr + 1
        CMP     string + 1
        BNE     unret
        LDAIM   cr
        STAI    tmax
        LDAIM   &00
simBRK
        CMPIM   &01
        BNE     simBK2
        JSR     supvBR
        JMP     starCN
simBK2
        BCC     norBRK
        JSR     closeX
        JSR     stFILE
norBRK
        JSR     vstrng
        =       &03,&0F,&EA
        JSR     csr0ST

        [ lerror=1
        JSR     vstrng
        =       &0B,&0B,&0B,"°",&EA
        LDXIM   "¦"
        LDAIM   59-80
        JSR     BRKsub
        =       "Shift f5 D for info±©",&EA
        LDXIM   " "
        LDAIM   78-80
        JSR     BRKsub
        =       "©²",&EA
        LDXIM   "¦"
        LDAIM   54-80
        JSR     BRKsub
        =       "Press ESCAPE to continue³",11,11,9,&EA
        JSR     BRKoy
        |
        JSR     supvBR
        JSR     curOFF
        LDA     tutmod
        ANDIM   &07
        CMPIM   &05
        BEQ     nomess
        LDAI    &FD
        CMPIM   &01
        BNE     nomess
        JSR     vstrng
        [ 1=0
        =       lf,cr,"For help type: shf-f5 D",&EA
        |
        =       lf,cr,"Shift f5 D for info",&EA ; Slightly shorter
        ]
nomess
        JSR     osnewl
        JSR     strimo
        =       "Press ESCAPE to continue",&EA
        ]

esclop
        JSR     osrdch
        CMPIM   &1B
        BNE     esclop
ESCCON
        LDAIM   &7E
        JSR     osbyte
        JSR     NORMAL
        JMP     EDITCO
SUPVBR
        JSR     OSNEWL
BRKOY
        LDYIM   &01
BRKOLP
        LDAIY   &FD
        BEQ     BRKOX
        JSR     OSASCI
        INY
        BNE     BRKOLP
BRKOX
        RTS

        ; ------------------------------------------------------------ ;

servic  ; Recognise *help and *edit

        [ mouse = 0
        CMPIM   &04
        BEQ     unknow
        CMPIM   &09
        BNE     servex

        ; *HELP response

        LDAIY   &F2
        CMPIM   cr
        BNE     helpEX  ; don't say anything unless there are no keywords

        [ reladd=0
        PHY
        |
        TYA             ; When relocated for TUBEs then non-CMOS codes
        PHA
        ]

        LDYIM   helpen - helpin - 1
helpLO
        [ reladd=0
        LDAAY   helpin          ; Must always be assembled for &8000
        |                       ; on relocated versions
        LDAAY   (helpin - reladr) + &8000
        ]
        JSR     osasci
        DEY
        BPL     helpLO

        [ reladd=0
        PLY
        |
        PLA
        TAY
        ]
helpEX
        LDAIM   &09
servex
        RTS
helpin
        = cr,"5 TIDE",cr
helpen

unknow
        ; Recognise *edit as command to enter language.

        [ reladd=0
        PHY
        PHX
        |
        TYA
        PHA
        TXA
        PHA
        ]

        LDXIM   &03
ucomLO
        LDAIY   &F2
        CMPIM   "."
        BEQ     ucommi
        ANDIM   &DF
        [ reladd=0
        CMPAX   helpen - 5      ; Must always be assembled at &8000
        |                       ; on relocated versions
        CMPAX   (helpen - reladr - 5) + &8000
        ]
        BNE     ucomEX
        INY
        DEX
        BPL     ucomLO
        LDAIY   &F2
        CMPIM   space + 1
        BCC     ucommi
ucomEX
        [ reladd=0
        PLX
        PLY
        |
        PLA
        TAX
        PLA
        TAY
        ]
        LDAIM   &04
        RTS
ucommi
        ; Command recognised - enter self as a language.
        [ reladd=0
        LDAIM   &8E
        PLX
        |
        PLA
        TAX
        LDAIM   &8E
        ]
        JMP     OSBYTE
        ]
        ; ------------------------------------------------------------ ;

langua                          ; Language entry point
        CLI
        CLD
        LDXIM   &FF
        TXS
        LDAIM   ROM1br
        STA     BRKv
        LDAIM   :MSB: ROM1BR
        STA     BRKv + 1
        CLR     oldsta + 3
        LDAIM   &F2
        STA     scratc
        CLR     scratc + 1
        JSR     readby
        TAX
        JSR     readnx
        STA     scratc + 1
        STX     scratc
        LDXIM   20
EDITol
        DEX
        BEQ     EDIToz

        JSR     readby
        JSR     readne
        CMPIM   cr
        BEQ     EDIToz

        CMPIM   " "
        BNE     EDITol
        LDXIM   &00
EDITgb
        JSR     readby
        JSR     readne
        STAAX   &01A0
        INX
        CPXIM   "@"
        BNE     EDITGB
        LDAIM   cr
        STAAX   &01A0 - 1
        STA     nambuf
        LDYIM   &00
        JSR     readhx
        BCC     EDITon
        CMPIM   ","
        BNE     EDITon
        LDAZX   &00
        STA     oldsta
        LDAZX   &01
        STA     oldsta + 1
        INY
        JSR     readHX
        BCC     EDITon
        CMPIM   cr
        BNE     EDITon
        LDAZX   &00
        STA     oldsta + 2
        LDAZX   &01
        STA     oldsta + 3
        STZ     cursed
        BRA     EDIToy
EDITon
        LDXIM   &FF
EDITn1
        INX
        LDAAX   &01A0
        CMPIM   " "
        BEQ     EDITn1
        CMPIM   cr
        BEQ     EDIToz
EDITn2
        LDAAX   &01A0
        CMPIM   cr
        BEQ     EDITn3
        CMPIM   " "
        BCC     EDIToz
        CMPIM   delete
        BCS     EDIToz

EDITn3
        STAAX   nambuf
        INX
        CMPIM   cr
        BNE     EDITn2
        LDAIM   &01
        STA     cursed
        BRA     EDIToy

EDIToz
        LDXIM   &FF
        STX     cursed
        LDAIM   cr
        STA     nambuf

        [ cf8key=1
        LDAZ    clterm          ; current line terminator
        |
        [ termin<>cr
        LDAIM   termin
        ]
        ]

        CMPI    paje
        BNE     EDIToy
        CMPI    tmax
        BNE     EDIToy
        JSR     memsta

EDIToy
        LDAIM   161             ; read CMOS RAM into 'tutmod'
        LDXIM   &08             ; our byte
        LDYIM   &10             ; ???
        JSR     osbyte
        STY     tutmod          ; returns &00 on the BBC OS 1.2

        [ mouse=1
        JSR     mouser
        ]

        LDAIM   cr
        STA     frbuff
        STA     grbuff
        [ cf8key=1
        STAZ    clterm          ; initialise 'clterm' here
        ]
        STZ     indexH
        STZ     modflg
        JSR     vstrng          ; define characters

        =       3
        =       23,"¦",&00,&00,&00,&FF,&00,&00,&00,&00
        =       23,"©",&18,&18,&18,&18,&18,&18,&18,&18

        [ dchars=1      ; Character definitions for descriptive MODE
        =       23,"°",&00,&00,&00,&07,&0C,&18,&18,&18
        =       23,"±",&00,&00,&00,&E0,&30,&18,&18,&18
        =       23,"²",&18,&18,&0C,&07,&00,&00,&00,&00
        =       23,"³",&18,&18,&30,&E0,&00,&00,&00,&00
        =       23,"‡",&7E,&C3,&9D,&B1,&9D,&C3,&7E,&00
        =       23,"ˆ",&00,&18,&38,&7F,&38,&18,&00,&00
        =       23,"‰",&00,&18,&1C,&FE,&1C,&18,&00,&00
        =       23,"Š",&18,&18,&18,&18,&7E,&3C,&18,&00
        =       23,"‹",&00,&18,&3C,&7E,&18,&18,&18,&18
        =       23,"¢",&00,&00,&00,&1F,&00,&00,&00,&00
        =       23,"¤",&00,&00,&00,&F8,&00,&00,&00,&00
        =       23,"§",&00,&00,&00,&FF,&18,&18,&18,&18
        =       23,"«",&18,&18,&18,&1F,&18,&18,&18,&18
        =       23,"­",&18,&18,&18,&F8,&18,&18,&18,&18
        =       23,"®",&18,&18,&18,&FF,&00,&00,&00,&00
        =       23,"¯",&18,&18,&18,&FF,&18,&18,&18,&18
        ]
        [ lfarro=1
nlfarr  *       &FE
        =       23,nlfarr,&00,&18,&38,&7F,&38,&18,&00,&00
        ]

        =       &EA

        LDA     cursed
        BEQ     zippo
        DEA
        BEQ     zappo
        JMP     EDIT    ; and away we go...
zippo
        JSR     EDITmd

        [ stamp=1
        JSR      NSTAMP
        ]

        JMP     oldtex

zappo
        STZ     BRKact
        JSR     EDITmd
        JSR     EDITi2
        LDYIM   &00
        LDAIM   nambuf
        STA     temp
        LDAIM   :MSB: nambuf
        STA     temp + 1
        JSR     tload
        JMP     EDITgt

XYscra
        ; Load XY with address of scratch.
        LDXIM   :LSB: scratc
        LDYIM   :MSB: scratc
        RTS

readne
        INC     scratc
        BNE     . + 4
        INC     scratc + 1
        RTS

readhx
        LDXIM   0
        STZ     scratc + 5
tsthex
        LDAAY   &01A0
        CMPIM   "0"
        BCC     hexend
        CMPIM   "9" + 1
        BCC     OKhex
        SBCIM   &37
        CMPIM   10
        BCC     hexend
        CMPIM   16
        BCS     hexend
OKhex
        ASL     scratc + 5
        ASL     scratc + 5
        ASL     scratc + 5
        ASL     scratc + 5
        ANDIM   &0F
        TSB     scratc + 5
        INY
        INX
        BRA     tsthex
hexend
        CPXIM   &01             ; CC status for not found
        LDX     scratc + 5
        RTS

readnx
        JSR     readne

readby
        PHX
        PHY
        JSR     XYscra
        LDAIM   5
        JSR     osword
        PLY
        PLX
        LDA     scratc + 4
        RTS

paslnm
        SEC
        SBC     addr
        STA     maxsiz
        TXA
        SBC     addr + 1
        STA     maxsiz + 1

filena
        ; Entry - IY temp points to input name. Exit - scratch -> filename.
        LDAIY   temp
        CMPIM   cr
        BEQ     textna
        CMPIM   &8B
        BEQ     oldnam
        LDXIM   &00

memnam
        LDAIY   temp
        STAAX   nambuf
        INY
        INX
        CPXIM   52
        BNE     memnam

oldnam
        LDA     nambuf
        CMPIM   cr
        BEQ     nonam
        LDAIM   nambuf
        STA     scratc
        LDAIM   :MSB: nambuf
        STA     scratc + 1
        RTS

textna
        LDX     GE
        LDY     GE + 1
        PHX
        PHY
        LDX     tstart
        LDY     tstart + 1
        JSR     GPBKXY
        LDYIM   &00

MVIC
        LDAIY   GE
        STAAY   stracc
        INY
        BNE     MVIC 
        PLY
        PLX
        JSR     GPFDXY
        LDYIM   &FF
namsrc
        INY
        BMI     nonam
        LDAAY   STRACC

        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]

        BEQ     nonam
        CMPIM   ">"
        BNE     namsrc
        INY
        STY     scratc
namsr3
        LDAAY   stracc

        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]

        BEQ     namfnd
        INY
        BPL     namsr3
nonam
        TYA
        BEQ     namsrc
        BRK
        =       &01,"No name found",null

namfnd

        [ cf8key=1
        LDAIM   cr
        STAAY   stracc
        |
        [ termin<>cr
        LDAIM   cr
        STAAY   STRACC
        ]
        ]

        LDAIM   :MSB: stracc
        STA     scratc + 1
        RTS

writna
        JSR     startI
        LDYIM   &FF
wrispc
        INY
        LDAIY   scratc
        CMPIM   " "
        BEQ     wrispc
wrilop
        LDAIY   scratc
        CMPIM   " " + 1
        BCC     wriex
        JSR     oswrch
        INY
        BRA     wrilop
wriex
        JMP     stopin

tload
        LDA     tstart
        STA     addr
        LDA     tstart + 1
        STA     addr + 1
        LDA     tmax
        LDX     tmax + 1

        [ STAMP=1
        JSR     pasloa
        PHX
        PHY
        LDXIM   flload
        LDYIM   &02
        JSR     frscra
        LDXIM   flexec
        JSR     frscra
        PLY
        PLX
        RTS
        ]

pasloa
        ; Entry - IY temp -> name, addr = load address, AX = max free address
        ; Exit - File checked for size (not on slow FS's)
        ; File loaded to addr, with XY = top of file
        JSR     paslnm
        JSR     prompt
        =       "Loading ",&EA
        JSR     writna

pasGO
        LDYIM   &00
        TYA
        JSR     osargs
        CMPIM   &04
        BCC     nosize
        ; Using a random access filing system,
        ; so can quickly check size of file.
        LDAIM   &05
        JSR     XYscra
        JSR     osfile
        CMPIM   &01
        BNE     nosize          ; Let FS generate 'Directory/not found' error.
        LDA     scratc + &0C
        ORA     scratc + &0D
        BNE     paslhu
        LDA     maxsiz
        CMP     scratc + &0A
        LDA     maxsiz + 1
        SBC     scratc + &0B
        BCC     paslhu

nosize
        ; Load file to addr, & set XY --> top of loaded file.
        LDA     addr
        STA     scratc + 2
        LDA     addr + 1
        STA     scratc + 3
        CLR     scratc + 4
        CLR     scratc + 5
        CLR     scratc + 6
        LDAIM   &FF
        JSR     XYscra
        JSR     osfile
        CLR     oldsta + 3      ; make old impossible
        CLC
        LDA     addr
        ADC     scratch + &0A
        TAX
        LDA     addr + 1
        ADC     scratc + &0B
        TAY
        RTS

paslhu
        BRK
        =       &02,"File too big",null

tSAVE
        ; Save (defaulting) marked block of text.
        ; Entry - (temp),Y points to input name.
        ; GE = Start of block
        ; ENDP = End of block
        ; Exit - specified memory saved as filename.
        JSR     filena

inSAVE
        JSR     prompt
        =       "Saving to ",&EA
        JSR     writna
        LDXIM   &0F
pasacl
        STZAX   scratc + 2
        DEX
        BPL     pasacl

        [ STAMP=1
        JSR     dstamp
        LDXIM   flload
        LDYIM   &02
        JSR     toscra
        LDXIM   flexec
        JSR     toscra
        LDXIM   GE
        JSR     toscr2
        LDYIM   &0E
        LDXIM   endp
        JSR     toscr2
        |
        DEC     scratc + 6
        DEC     scratc + 7
        DEC     scratc + 8
        DEC     scratc + 9
        LDA     GE
        STA     scratc + &0A
        LDA     GE + 1
        STA     scratc + &0B
        LDA     endp
        STA     scratc + &0E
        LDA     endp + 1
        STA     scratc + &0F
        ]

        LDAIM   &00
        JSR     XYscra
        JMP     osfile

        [ STAMP=1
toscra
        JSR     toscr2
toscr2
        JSR     toscr1
toscr1
        LDAZX   &00
        STAAY   scratc
        INX
        INY
        RTS

frscra
        JSR     frscr2
frscr2
        JSR     frscr1
frscr1
        LDAAY   scratc
        STAZX   &00
        INX
        INY
dstmpX
        RTS

nstamp
        LDXIM   &07
        LDAIM   &00
nstmp1
        STAAX   flexec
        CPXIM   &04
        BNE     nstmp2
        LDAIM   &FF
nstmp2
        DEX
        BPL     nstmp1
        RTS
mstamp
        LDAIM   &FF
        STA     flload + 1
        STA     flload + 2
        STA     flload + 3
dstamp
        LDA     flload + 1
        AND     flload + 2
        AND     flload + 3
        INA
        BNE     dstmpX
        LDXIM   flexec
        LDYIM   &00
        LDAIM   &01
        JMP     osword
        ]

readns
        ; Reads line to commandline (linbuf), & strips leading &
        ; trailing spaces.
        ; Exit - temp --> 1st non-space char on line
        ; A      = 1st non-space char on line
        ; Y      = 0
        ; EQ if line was 'empty', else NE

        JSR     readLS
        TYA
        BEQ     renSCR
renSST
        LDAAY   comman - 1
        CMPIM   space
        BNE     renSCR
        DEY
        BNE     renSST
renSCR
        LDAIM   cr
        STAAY   comman
        LDYIM   &FF
renSIG
        INY
        LDAAY   comman
        CMPIM   space
        BEQ     renSIG
        CLC
readIM
        TYA
        ADCIM   :LSB: comman
        STA     temp
        LDAIM   &00
        ADCIM   :MSB: comman
        STA     temp + 1
        LDYIM   &00
        LDAI    temp
        CMPIM   cr
escCLR
        RTS

readIN
        LDYIM   &00
        BRA     readIM

readLS
        LDAIM   " "
        JSR     oswrch

        ; Read line into linbuf/commandline, testing for escape.
        ; Exit - Y = No. of chars read (excluding CR).

        LDAIM   thelot
        STA     update
        JSR     rdlnre
        BCC     escCLR
escSET
        JSR     VSTRNG
        =       &03,&0F,&0D,&EA
        LDA     BRKact
        CMPIM   &02
        BNE     escSIM
        JSR     closeX
        JSR     stFILE
escSIM
        STZ     cursed
        JMP     escCON
escTST
        BIT     &FF
        BMI     escSET
        RTS

RDLNRE
        LDYIM   0
RDLNLP
        JSR     OSRDCH
        BCS     RDLNEX
        STAAY   LINBUF
        CMPIM   &7F
        BNE     RDLN2
        CPYIM   0
        BEQ     RDLNLP
        DEY
        JSR     OSWRCH
        BRA     RDLNLP
RDLN2
        CMPIM   &15
        BNE     RDLN3
RDLNDL
        TYA
        BEQ     RDLNLP
        LDAIM   &7F
        JSR     OSWRCH
        DEY
        BRA     RDLNDL
RDLN3
        INY
        CMPIM   CR
        BEQ     RDLNEG
        JSR     PASWRCH
        BRA     RDLNLP
RDLNEG
        PHY
        JSR     CUROFF
        PLY
        DEY
        CLC
RDLNEX
        RTS
COPYBK
        ; Copy block backwards (i.e. to lower address).
        ; Entry - ARGP --> block of size XY
        ; VARP --> destination address 
        STX     SIZE
        STY     SIZE + 1
        LDA     SIZE
        ORA     SIZE + 1
        BEQ     BKEXIT
        LDX     SIZE + 1
        SEC
        LDAIM   0
        SBC     SIZE
        TAY
        BEQ     BKLOOP
        STA     TEMP
        SEC
        LDA     ARGP
        SBC     TEMP
        STA     ARGP
        BCS     CPNHI1
        DEC     ARGP + 1
        SEC
CPNHI1
        LDA     VARP
        SBC     TEMP
        STA     VARP
        BCS     CPNHI2
        DEC     VARP + 1
CPNHI2
        INX
BKLOOP
        LDAIY   ARGP
        STAIY   VARP
        INY
        BNE     BKLOOP
        INC     ARGP + 1
        INC     VARP + 1
        DEX
        BNE     BKLOOP
BKEXIT
        RTS

memsta
        LDA     tstart + 1
        JSR     chkptr
        LDA     GS + 1
        JSR     chkptr
        LDA     GE + 1
        JSR     CHKPTR
        LDA     TMAX + 1
        JSR     CHKPTR
        LDX     TMAX
        LDY     TMAX + 1
        JSR     GPFDXY
        LDA     TSTART
        STA     OLDSTA
        LDA     TSTART + 1
        STA     OLDSTA + 1
        LDA     GS
        STA     OLDSTA + 2
        LDA     GS + 1
        STA     OLDSTA + 3
        CLC
CHKPTX
        RTS
CHKPTR
        CMP     HYMEM + 1
        BCS     CHKPTX
        CMP     PAJE + 1
        BCS     CHKPTX
        PLA
        PLA
        RTS

        [ lerror=1
BRKSUB
        SEC
        ADC     PAGEWI
        TAY
        TXA
BRKSB1
        JSR     OSWRCH
        DEY
        BNE     BRKSB1
        ]

VSTRNG
        PLA
        STA     STRING
        PLA
        STA     STRING + 1
        JSR     VSTRLP
        JMI     STRING
VSTRLM
        JSR     OSWRCH
VSTRLP
        INC     STRING
        BNE     STRINOT
        INC     STRING + 1
STRINO
        LDAI    STRING          ; enter here for normal string
        CMPIM   &EA
        BNE     VSTRLM
        RTS
CRTOGG
        LDAIM   &20
        EOR     TUTMOD
DOMODE
        STA     TUTMOD
        PHX
        PHY
        TAY
        LDAIM   162
        LDXIM   8
        JSR     OSBYTE
        PLY
        PLX
        RTS
TESTIF
        LDAIM   &10
        BIT     TUTMOD
        RTS
        [ MOUSE=1
MOUSER
        LDA     MOUSEL
        STA     MOUSEL + 5
        LDAIM   &92
        LDXIM   MOUSWI
        JSR     OSBYTE
        STY     MOUSEL
        LDXIM   MOUXLO
        JSR     OSBYTE
        PHY
        INX
        JSR     OSBYTE
        PLA
        ANDIM   &F8
        PHA
        SBC     MOUSEL + 1
        STA     MOUSEL + 6
        TYA
        SBC     MOUSEL + 2
        STA     MOUSEL + 7
        STY     MOUSEL + 2
        PLA
        STA     MOUSEL + 1
        LDAIM   &92
        INX
        JSR     OSBYTE
        PHY
        INX
        JSR     OSBYTE
        PLA
        ANDIM   &F8
        PHA
        SBC     MOUSEL + 3
        STA     MOUSEL + 8
        TYA
        SBC     MOUSEL + 4
        STA     MOUSEL + 9      ; ychange
        STY     MOUSEL + 4
        PLY
        STY     MOUSEL + 3
        RTS
        ]

        LNK     EDIT02

        END
