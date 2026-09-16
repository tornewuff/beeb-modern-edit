        ; -> EDIT08
        ; Find-Replace & Global-Replace should have their own seperate command
        ; keys, with the first delimeter 'built in' (i.e. not required), and CR
        ; sufficing as terminator -
        ; FR/ ....... [/.......] <CR>
        ; GR/ .......  /.......  <CR>
GETRESP
        ;Exit - A holds char - forced to lower case - read from keyboard
        JSR     EDRDCH
        ORAIM   &20
        RTS
MOVETOFOUNDPOSN
        LDX     MS
        LDY     MS+1
        JMP     GPFDXY
GLOBREPLACE
        JSR     DFINIT
        JSR     PROMPT
        =       "Global replace:",&EA
        [ extgf=1
        JSR     readlf
        |
        JSR     readLS
        ]
        JSR     READINIT
        BNE     NEWGR
        CMP     GRBUFF
        BEQ     NOBUFF
OLDGR
        LDAAY   GRBUFF
        STAIY   TEMP
        INY
        BPL     OLDGR
        LDYIM   0
NEWGR
        LDAIY   TEMP
        STAAY   GRBUFF
        INY
        CPYIM   100
        BNE     NEWGR
        JSR     FINDTRANS
        JSR     DFBLOK
        CLR     LINE
        CLR     LINE+1
        CLR     TEXPFLAG
GREPLP
        LDX     GE
        LDY     GE+1
GREPNX
        STX     MS
        STY     MS+1
        JSR     SEARCH
        BCS     GREPEX
        INC     LINE
        BNE     GREPNH
        INC     LINE+1
GREPNH
        LDA     REPLFLAG
        BNE     GREPRP
        LDX     ME
        LDY     ME+1
        BRA     GREPNX
GREPRP
        JSR     CHKNREP
        BRA     GREPLP
GREPEX
        ;Move cursor (as near as possible) to the place it started at, then
        ;output match count.
        LDX     STRING
        LDY     STRING+1
        JSR     GPBKXY
        JSR     NORMALIZE
        JSR     SCRNUD
        LDXIM   PRMPTL
        JSR     PRMPTX
        =       " ",&EA
        JSR     WRITLINE
        JSR     PRMPTX
        =       " found",&EA
        RTS
NOBUFF
        BRK
        =       1,"No previous string",0
FINDREPLACE
        JSR     PROMPT
        =       "Find and replace:",&EA
        [ extgf=1
        JSR     readlf
        |
        JSR     READLS
        ]
        JSR     READINIT
        BNE     NEWFR
        CMP     FRBUFF
        BEQ     NOBUFF
OLDFR
        LDAAY   FRBUFF
        STAIY   TEMP
        INY
        BPL     OLDFR
        LDYIM   0
NEWFR
        LDAIY   TEMP
        STAAY   FRBUFF
        INY
        CPYIM   100
        BNE     NEWFR
        JSR     FINDTRANS
        JSR     TEMPSX
        JSR     FINEPOSITIONGAP
        LDA     LINE
        STA     SCRNX
        ;Set up search termination pointer & flag.
        LDA     TMAX
        STA     TEXP
        LDA     TMAX+1
        STA     TEXP+1
        STA     TEXPFLAG
IMRPRL
        LDX     GE
        LDY     GE+1
IMRPCL
        STX     MS
        STY     MS+1
        JSR     SEARCH
        BCS     IMRPNF
        JSR     MOVETOFOUNDPSN
        JSR     NORMAX; get position of X back
        LDA     BSM ;Move to BSM
        STA     SCRNY
        JSR     SCRNUD
        LDAIM   FULLSCREEN
        STA     UPDATEREQD
        JSR     PROMPT
        =       "R(eplace), C(ontinue) or ESCAPE",&EA

        JSR     CSRSCREENXY
        JSR     CURON
IMRPPR
        JSR     GETRESP
        CMPIM   "c"
        BNE     IMRPNC
        LDX     ME
        LDY     ME+1
        BRA     IMRPCL
IMRPNC
        CMPIM   "r"
        BNE     IMRPPR
        JSR     MKREFUSE
        ;Either use supplied replace part, or prompt for one.
        LDA     REPLFLAG
        BNE     IMRPRP
        JSR     PROMPT
        =       "Replace by:",&EA

        [ extgf=1
        JSR     readlf
        |
        JSR     READLS
        ]
        JSR     READINIT
        JSR     MININIT
        LDA     REPLINDEX
        STA     OUTINDEX
        JSR     REPLPART
IMRPRP
        JSR     CHKNREP
        JMP     IMRPRL  
IMRPNF
        JSR     NORMALIZE
        LDAIM   THELOT
        STA     UPDATER
        JSR     SCRNUD
        JSR     STATUS
        LDXIM   PRMPTL
        JSR     PRMPTX
        =       " Not found",&EA
        RTS

WRITLINE
        JSR     STARTINV
        LDXIM   4 ;Outputs LINE in decimal, suppressing leading zeros.
        STX     STRING
WOPRNEXT
        CLR     STRING+1
WOPRLOOP
        SEC
        LDA     LINE
        SBCAX   WOPTBL
        TAY
        LDA     LINE+1
        SBCAX   WOPTBH
        BCC     WOPRDIGI
        STY     LINE
        STA     LINE+1
        INC     STRING+1
        BRA     WOPRLOOP
WOPRDIGI
        LDA     STRING+1
        BNE     WOPRGEN
        DEC     STRING
        BPL     WOPRCONT
WOPRGEN
        ORAIM   "0"
        JSR     OSWRCH
        CLR     STRING
WOPRCONT
        DEX
        BPL     WOPRNEXT
        RTS
WOPTBL
        =       :LSB: 1
        =       :LSB: 10
        =       :LSB: 100
        =       :LSB: 1000
        =       :LSB: 10000
WOPTBH
        =       :MSB: 1
        =       :MSB: 10
        =       :MSB: 100
        =       :MSB: 1000
        =       :MSB: 10000

        ;Marks are stored in SMATlo,hi (Set Mark Address Table), where the
        ;addresses refer to positions in the 2nd half of text; when updated
        ;(any number of times), this address is translated into a value in
        ;UMATlo,hi (Used Mark Address Table), where the addresses refer to
        ;positions in the text as it is currently partitioned.
MARKUP
        ;Update marks for current position of gap.
        ;Exit  -  marksbeforecsr =       No. of marks before GE.
        JSR     MKUDCH
MKUDKN
        CLR     MARKSB
        LDX     MARKX
MKUDLP
        DEX
        BMI     MKUDEX
        LDYZX   SMATLO
        STYZX   UMATLO
        CPY     GE
        LDAZX   SMATHI
        STAZX   UMATHI
        SBC     GE+1
        BCS     MKUDLP
        INC     MARKSB
        SEC
        TYA
        SBC     CHUNKS
        STAZX   UMATLO
        LDAZX   UMATHI
        SBC     CHUNKS + 1
        STAZX   UMATHI
        BCS     MKUDLP
MKUDEX
        RTS
MKUDCH
        ;chunksize :=       size of gap to correct for.
        SEC
        LDA     GE
        SBC     GS
        STA     CHUNKS
        LDA     GE+1
        SBC     GS+1
        STA     CHUNKS + 1
        RTS
CLRMARKS
        ;Clear, count update & order mark(s), ready for use.
        ;Entry - Mark1 (markstk) and/or Mark2 (markstk+2) possibly set.
        ;Exit  - Gap finepositioned
        ;        Marks ordered so that Mark1 <=       Mark2
        ;        Marks cleared & status updated
        ;        A[Z] =       nummarks =       No. of marks
        ;Save (GE - GS) for updating marks, then finepositiongap
        JSR     FINEPO
        JSR     MKUDCH
        JSR     MKUDKN

        ;If Mark2 (exists) < Mark1, then swap.
        LDX     MARKX
        CPXIM   2
        BNE     CLRMCO
        LDA     UMATLO+1
        CMP     UMATLO
        LDA     UMATHI+1
        SBC     UMATHI
        BCS     CLRMCO
        LDA     UMATLO
        LDY     UMATLO+1
        STA     UMATLO+1
        STY     UMATLO
        LDA     UMATHI
        LDY     UMATHI+1
        STA     UMATHI+1
        STY     UMATHI
CLRMCO
        LDA     MARKX
        STA     NUMMAR
        CLR     MARKX
        JSR     STATUS
        LDA     NUMMAR
MKRFEX
        RTS
MKREFUSE
        ;Complain if any marks are set.
        LDA     MARKX
        BEQ     MKRFEX
        BRK
        =       1,"Mark(s) set",0
NMBLOK
        ;Normalizes a marked block of text, to ease use.
        ;Entry  -  Marks updated (gap fine positioned). TEXP =       GE
        ;Exit   -  'Bad marking' error if 2 marks were set.
        ;       -  EQ - 0 marks were set.
        ;          NE - 1 mark was set (csr-mark or mark-csr):
        ;               Gap moved to start of block,
        ;               XY =       end of block.
        LDA     GE
        STA     TEXP
        LDA     GE+1
        STA     TEXP+1
        LDA     NUMMAR
        BEQ     NBLKEX
        CMPIM   1
        BNE     BADMAR
        LDX     UMATLO
        LDY     UMATHI
        DEC     MARKSB
        BNE     NBLKEX
        JSR     GPBKXY
        LDX     TEXP
        LDY     TEXP+1
NBLKEX
        RTS
DFINIT
        ;Seperated this way to avoid grotty command-line escape.
        JSR     TEMPSX
        JSR     CLRMAR
        CMPIM   2
        BEQ     BADMAR
        PHA
        LDA     LINE
        STA     SCRNX
        PLA
        RTS
DFBLOK
        ;Normalize a 'marked' block (defaulting to whole) of text.
        ;Exit  -  TEXP =       Old cursor position (in end of text).
        ;         ENDP =       End of 'marked' block.
        JSR     NMBLOK
        BNE     DBLKEP
        JSR     STFILE
        LDX     TMAX
        LDY     TMAX + 1
DBLKEP
        STX     ENDP
        STY     ENDP + 1
        RTS
MVBLOK
        ;Ensure good marking (m-m-c or c-m-m) for a block 'move-op'
        ;Exit  -  CC: marks are after cursor
        ;         CS: marks are before cursor
        JSR     CLRMAR
        CMPIM   2
        BNE     BADMAR
        ;if 2nd mark on cursor then shift it to GS
        LDA     UMATLO + 1
        CMP     GE
        BNE     MVBLOJ
        LDA     UMATHI + 1
        CMP     GE+1
        BNE     MVBLOJ
        LDA     GS
        STA     UMATLO + 1
        LDA     GS+1
        STA     UMATHI + 1
        INC     MARKSB
MVBLOJ
        LDA     MARKSB
        DEA     ;cmp#1
        BEQ     BADMAR
        RTS
BADMARKING
        BRK
        =       1,"Bad marking",0
SETMARK
        JSR     FINEPO
        LDX     MARKX
        CPXIM   2
        BEQ     BADMAR
        ;Save mark address.
        LDA     GE   
        STAZX   SMATLO
        LDA     GE+1
        STAZX   SMATHI
        JSR     NORMAL
        INC     MARKX
        JMP     STATUS
CLEARMARKS
        JSR     CLRMAR
        JMP     NORMAL
MKDEL
        JSR     CLRMAR
        JSR     NMBLOK
        BEQ     BADMAR ;Stop delete from defaulting to 'NEW' !
        STX     GE
        STY     GE+1
        JSR     MODIFY
NORMAX
        JSR     NORMAL
        LDA     STRING
        STA     SCRNX
        RTS
MKCPY
        ;Marked copy. Either m-m-c or c-m-m.
        JSR     MVBLOK
        ;XY =       (Mark2-Mark1) - size of block to be copied.
        SEC
        LDA     UMATLO + 1
        SBC     UMATLO
        TAX
        LDA     UMATHI + 1
        SBC     UMATHI
        TAY
        LDA     MARKSB
        BEQ     MKCPYO
        STX     STRING
        STY     STRING + 1
        SEC
        LDA     SMATLO
        SBC     STRING
        STA     SMATLO
        LDA     SMATHI
        SBC     STRING + 1
        STA     SMATHI
        LDA     SMATLO + 1
        SBC     STRING
        STA     SMATLO + 1
        LDA     SMATHI + 1
        SBC     STRING + 1
        STA     SMATHI + 1
MKCPYO
        JSR     CHECKR
        ;Copy the block, then normalize text.
        LDA     UMATLO
        STA     ARGP
        LDA     UMATHI
        STA     ARGP + 1
        STX     GE
        STX     VARP
        STY     GE + 1
        STY     VARP + 1
        JSR     CPFD2
        LDXIM   1
        STX     MODFLG
        INX
        STX     MARKX
        JSR     STATUS
        JMP     NORMAL
MKMVE
        ;If marks are before cursor, then do a bit of tweaking to
        ;change it into case where thay are after it.
        JSR     MVBLOK
        ;Initialize pointers for iterative swap block routine.
        LDX     UMATLO
        LDY     UMATHI
        LDA     MARKSB
        BEQ     MVBEFC
        STX     ARGP
        STY     ARGP + 1
        LDA     UMATLO + 1
        STA     VARP
        LDA     UMATHI + 1
        STA     VARP + 1
        LDX     GS
        LDY     GS + 1
        BRA     MVSTP3
MVBEFC
        STX     VARP
        STY     VARP + 1
        LDA     GE
        STA     ARGP
        LDA     GE + 1
        STA     ARGP + 1
        LDX     UMATLO + 1
        LDY     UMATHI + 1
MVSTP3
        STX     ENDP
        STY     ENDP + 1
MVLOOP
        SEC
        LDA     VARP
        SBC     ARGP
        STA     SIZE
        LDA     VARP + 1
        SBC     ARGP + 1
        STA     SIZE + 1
        LDA     ENDP
        SBC     VARP
        TAX
        LDA     ENDP + 1
        SBC     VARP + 1
        TAY
        CPX     SIZE
        SBC     SIZE + 1
        BCS     MV2GE
        STX     SIZE
        STY     SIZE + 1
MV2GE
        LDA     SIZE
        ORA     SIZE + 1
        BEQ     MVNORM
        BCS     MV2GE1
        LDX     VARP
        LDY     VARP + 1
        JSR     MVSWAP
        CLC
        TYA
        ADC     TEMP
        STA     ARGP
        LDAIM   null
        ADC     TEMP + 1
        STA     ARGP + 1
        BCC     MVLOOP
MV2GE1
        SEC
        LDA     ENDP
        SBC     SIZE
        STA     ENDP
        TAX
        LDA     ENDP + 1
        SBC     SIZE + 1
        STA     ENDP + 1
        TAY
        JSR     MVSWAP
        BRA     MVLOOP
MVNORM
        LDAIM   FULLSC
        STA     UPDATE
        JSR     NORMAL
        JMP     MODIFY
MVSWAPBYTES
        ;Swap size bytes ARGP <-> XY
        LDA     ARGP
        STA     TEMP
        LDA     ARGP + 1
        STA     TEMP + 1
        STX     ADDR
        STY     ADDR + 1
        INC     SIZE + 1 ;To allow dec to zero below.
        LDYIM   null
MVNINC
        CPY     SIZE
        BNE     MVSWLP
        DEC     SIZE + 1
        BEQ     TEMPSE
MVSWLP
        LDAIY   TEMP
        TAX
        LDAIY   ADDR
        STAIY   TEMP
        TXA
        STAIY   ADDR
        INY
        BNE     MVNINC
        INC     TEMP + 1
        INC     ADDR + 1
        BRA     MVNINC
TEMPSX
        LDA     SCRNX
        STA     LINE
        LDA     CURRLEN
        CMP     SCRNX
        BCS     TEMPSE
        STA     SCRNX
TEMPSE
        RTS

        [ curtyp=1
                                ; different types of display cursor
                                ;
                                ; block/slow flash INSERT
                                ; line/slow flash  OVER
                                ; block/fast flash FOUND search items (f4)
                                ; line/fast flash  CURSOR EDITING
                                ; line/slow flash  COMMAND LINE entry
                                ;

                                ; blink         ; blink
                                ; fblink        ; Fast blink
                                ; fcstrt        ; Full cursor start line
                                ; ncstrt        ; Normal start line

                                ; VDU 23,0,10,value,0,0,0,0,0,0

curupd                          ; cursor update
                                ; 'tutmod' holds editing state
        PHA
                                ; bit4 = Insert/Over mode
        LDAZ    tutmod
        ANDIM   bit4
        BEQ     ovrcur
           
        LDAZ    cursed
        BEQ     slowc1

        JSR     bff
        BRA     curex
slowc1
        JSR     bsf
        BRA     curex
ovrcur
        LDAZ    cursed
        BEQ     slowc2

        JSR     lff
        BRA     curex
slowc2
        JSR     lsf
curex
        PLA
        RTS

bsf                             ; block slow flash
        PHA
        PHX

        LDAIM   fcstrt
        BRA     sf
bff                             ; block fast flash
        PHA
        PHX

        LDAIM   fcstrt
        BRA     ff
lff                             ; line slow flash
        PHA
        PHX

        LDAIM   ncstrt
        BRA     ff
lsf                             ; line fast flash
        PHA
        PHX

        LDAIM   ncstrt
sf
        ORAIM   fblink          ; add the fast flash
ff                              ; slow flash
        ORAIM   blink           ; and add the blink
                                ; at this point A holds value
        TAX

        LDAIM   23
        JSR     oswrch
        LDAIM   &00
        JSR     oswrch
        LDAIM   &0A             ; cursor control register
        JSR     oswrch
        TXA
        JSR     oswrch

        LDXIM   &05
        LDAIM   &00
bloop
        JSR     oswrch
        DEX
        BPL     bloop

        PLX
        PLA

        RTS                     ; and away..
        ]

        [ extgf=1               ; extended search and replace texts

                                ; we will use the function and <Shift> function
                                ; keys to insert the match characters

                                ; when these keys are pressed the relevant
                                ; text will be displayed and the correct
                                ; (existing) match character inserted into
                                ; the text - if a normal existing character
                                ; is entered it will be translated to "\c"
                                ; and the existing routines called

        ; KEYS       TWIN                 EDIT
        ;
        ;       f0 - newline            - "$"
        ;       f1 - found section      - "%"
        ;       f2 - found string       - "&"
        ;       f3 - most items         - "^"
        ;       f4 - many items         - "*"
        ;       f5 - replace by         - "/"
        ;       f6 - NOT item           - "~"
        ;       f7 - any character      - "."
        ;       f8 - alpha-numeric      - "@"
        ;       f9 - digit              - "#"
        ;
        ; Shift f0 - start set          - "["
        ;       f1 - end set            - "]"
        ;       f2 - sub range          - "-"
        ;       f3 - control character  - "|"
        ;       f4 - set top bit        - "|!|"
        ;       f5 - exactly            - "\"
        ;       f6 - toggle case        - not supported
        ;       f7 -                    -
        ;       f8 -                    -
        ;       f9 -                    -
        ;

        ^       128
nlnc    #       &01
fsnc    #       &01
fstc    #       &01
mstc    #       &01
manc    #       &01
rbyc    #       &01
notc    #       &01
anyc    #       &01
alpc    #       &01
digc    #       &01

        ^       144
setc    #       &01
stcc    #       &01
subc    #       &01
ctrc    #       &01
stbc    #       &01
exac    #       &01
ntc1    #       &01
ntc2    #       &01
ntc3    #       &01
ntc4    #       &01

kttab   ; key translation table

        =       nlnc,"newline",null           ; f0
        =       fsnc,"section",null           ; f1
        =       fstc,"match",null             ; f2
        =       mstc,"most",null              ; f3
        =       manc,"many",null              ; f4
        =       rbyc,"replace by",null        ; f5
        =       notc,"NOT",null               ; f6
        =       anyc,"any",null               ; f7
        =       alpc,"alpha",null             ; f8
        =       digc,"digit",null             ; f9

        =       setc,"[",null                 ; s+f0
        =       stcc,"]",null                 ; s+f1
        =       subc,"-",null                 ; s+f2
        =       ctrc,"control",null           ; s+f3
        =       stbc,"set top bit",null       ; s+f4
        =       exac,"exactly",null           ; s+f5
        =       ntc1,"",null                  ; s+f6
        =       ntc2,"",null                  ; s+f7
        =       ntc3,"",null                  ; s+f8
        =       ntc4,"",null                  ; s+f9

kttabe  ; end of table

nktent  *       ( kttabe - kttab )


readlf                          ; read line for find and replace
                                ; convert special keys to text when displaying

                                ; text into 'linbuf'
                                ; Y = number of chars excluding cr
        LDAIM   space
        JSR     oswrch

        LDAIM   thelot
        STA     update

        JSR     rdline
        BCC     noESC

        JSR     vstrng
        =       &03,&0F,&0D,&EA

        LDA     BRKact
        CMPIM   &02
        BNE     ESCso

        JSR     closeX
        JSR     stFILE
ESCso
        STZ     cursed
        JMP     ESCcon

rdline
        LDYIM   &00             ; index into 'linbuf'
rdloop
        LDAIM   "r"
        JSR     oswrch

        JSR     osrdch
        BCS     rdexit

        STAAY   linbuf          ; store the relevant value

        CMPIM   &7F
        BNE     rdlin2

        CPYIM   &00
        BEQ     rdloop

        DEY

        PHY

        LDAAY   linbuf

        JSR     sttadt          ; delete the character(s)
        PLY

        BCC     rdloop

        LDAIM   &7F             ; then let us delete it ourselfs
        JSR     oswrch

        BRA     rdloop

rdlin2
        CMPIM   &15
        BNE     rdlin3
rdlind
        TYA
        BEQ     rdloop

        PHY

        LDAAY   linbuf - 1

        JSR     sttadt          ; delete the character(s)
        PLY

        BCC     decY

        LDAIM   &7F             ; then let us delete it ourselfs
        JSR     oswrch
decY
        DEY
        BRA     rdlind

rdlin3
        INY
        CMPIM   cr
        BEQ     rdlicr

        JSR     sttapt

        BCC     rdloop

        JSR     paswrc          ; write character after parsing
                                ; ctrl chars - inverse
                                ; delete     - inverse "?"
                                ; any other character just echoed
        BRA     rdloop

rdlicr
        PHY
        JSR     curOFF
        PLY
        DEY
        CLC
rdexit
noESC
        RTS


sttapt                          ; search through the table and print the text
                                ; Entry..  A - character value
                                ; Exit...  A - character value        
                                ;         CC - found - text printed
                                ;         CS - not found
        LDXIM   :LSB: kttab
        LDYIM   :MSB: kttab
        STXZ    ctptr
        STYZ    ctptr + 1

nctest
        PHA

        CMPI    ctptr
        BEQ     gotit1

        JSR     nxtstr          ; no match so onto the next
        BCC     nctest

        PLA
        RTS                     ; well it wasn't one of ours

gotit1
        JSR     startI

        LDYIM   &01             ; the index to the text
ncoutl        
        LDAIY   ctptr
        BEQ     tdone

        JSR     oswrch

        INY
        BRA     ncoutl
tdone
        JSR     stopIN

        PLA
        CLC
        RTS



sttadt                          ; search through table and delete text
                                ; if it is one of our expanded characters
                                ; then delete the relevant number of chars
                                ;
                                ; Entry.. A - character value
                                ; Exit..  relevant number of &7F's printed
        LDXIM   :LSB: kttab
        LDYIM   :MSB: kttab
        STXZ    ctptr
        STYZ    ctptr + 1
nctst2
        LDAI    ctptr
        BEQ     gotit2

        JSR     nxtstr
        BCC     nctst2

        RTS                     ; not matched - so delete manually

gotit2
                                ; it is one of ours
        LDYIM   &FF
gndspc
        INY

        LDAIY   ctptr
        BNE     gndspc

        LDAIM   &7F
dndspc
        JSR     oswrch          ; and delete the relevant number of characters
        DEY
        BPL     dndspc

        CLC
        RTS


nxtstr                          ; pass onto the next string, checking
                                ; to see if we have reached the end of the
                                ; table
                                ; step to character after 'null'
                                ; update 'ctptr' until = kttabe
        LDAI    ctptr
        BEQ     outup

        INCZ    ctptr
        BNE     nxtstr
        INCZ    ctptr + 1
        BRA     nxtstr

outup
        INCZ    ctptr
        BNE     nihii2
        INCZ    ctptr + 1
nihii2
        SEC
        LDAZ    ctptr + 1
        CMPIM   :MSB: kttabe
        BNE     maybe1
        LDAZ    ctptr
        CMPIM   :LSB: kttabe
        BCS     outdwn          ; and around for the next
maybe1
        PLA
        CLC
        RTS
outdwn
        PLA
        SEC
        RTS
        ]

        ; ------------------------------------------------------------ ;

        [ origin=&8000
theend
        |
        =       "Roger Wilson",null
theend
        ]

romlen  *       (theend - origin)

        END
