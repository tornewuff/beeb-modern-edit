        ; -> EDIT06
        ; Entry - scrnY = desired screen Y coord of current line
        ;         (scrnX,scrnY) = final cursor position
        ; Exit  - screen & scrim updated
        ;         scrnY forced if necessary
        ;         update possibly aborted by incoming char.
        ;         currlength valid
SCRNUD
        JSR     LENGTHCALC
        STA     CURRLENGTH
        TAY
        BEQ     SCRNU0
        CMP     PAGEWIDTH
        BNE     SCRNU1
SCRNU0
        LDA     UPDATE
        CMPIM   CSRTOCR
        BNE     SCRNU1
        INC     UPDATE
        ; Update marks set, if any, to locate them for superimposition.
SCRNU1
        JSR     MARKUPDATE
        JSR     CUROFF
        ; If screen messier than would be fixed up by intended update,
        ; then do something about it.
        LDA     SCRNPY
        CMP     UPDATE
        BCC     SCUDCO
        STA     UPDATEREQD
SCUDCO
        CLR     SCRNPY
        LDA     UPDATEREQD
        CMPIM   THELOT
        BNE     SCUDTI
        JSR     CLEARSCREEN
        ; If fullscreen update is required, then find internal start
        ; of screen, possibly forcing scrnY, and update top half.
SCUDTI
        LDA     UPDATEREQD
        BEQ     SCUDEX ; 'none'
        CMPIM   FULLSCREEN
        BCC     SCUDBO
SCUDFS
        LDA     SCRNY
        JSR     TPGSBK
        STA     SCRNY
        DEA
        STA     MAXSCRUPY
        BMI     SCUDBO
        LDAIM   0
        LDX     TP
        LDY     TP+1
        JSR     UPDTLN
        BCS     SCUDAB
SCUDBO
        ; Output bottom half of screen, branching for hardscrolls.
        LDX     UPDATEREQD
        CPXIM   HARDUP
        BEQ     SCUDHU
        CPXIM   HARDDOWN
        BEQ     SCUDHD
        LDY     PAGELENGTH
        STY     MAXSCRUPY
        ; Set up A,X,Y for bottom half update.
        LDA     SCRNY
        LDX     GE
        LDY     GE+1
        JSR     UPDTLN
        BCC     SCUDEX
SCUDAB
        ; Record the fact that screen isn't totally up-to-date.
        LDAIM   CSRONW
        CMP     UPDATEREQD
        BCS     SCUDAS
        LDAIM   FULLSCREEN
SCUDAS
        STA     SCRNPY
SCUDEX
        CLR     UPDATEREQD
        RTS
SCUDHU
        ; Push against bottom to scroll up.
        JSR     CSR0STATUSY
        LDAIM   DOWN
        JSR     OSWRCH
        ; Scroll scrim up.
        LDXIM   &FF
SCHULP
        INX
        LDAAX   SCRIM+1
        STAAX   SCRIM
        CPX     PAGELENGTH
        BNE     SCHULP
        CLRAX   SCRIM+1
        JSR     STATUS
        LDA     PAGELENGTH
        BRA     SCHUDC
SCUDHD
        ; Rewrite status, then push against top to scroll down.
        JSR     VSTRNG
        = HOME,UP,&EA
        ; Scroll scrim down.
        LDY     PAGELENGTH
SCHDLP
        LDAAY   SCRIM
        STAAY   SCRIM+1
        DEY
        BPL     SCHDLP
        CLR     SCRIM
        JSR     STATUS
        LDAIM   0
SCHUDC
        STA     MAXSCRUPY
        LDX     SCP
        LDY     SCP+1
        BNE     UPDTLN
        TAY
WIPELINE
        ; Clear a line, assigning new scrim value. Y is line to clear.
        PHY
        JSR     CSR0Y
        LDAIM   " "
        JSR     OSWRCH
        LDAIM   0
        PLY
WIPETAIL
        ; Assign scrim entry for a line, clearing old tail of line.
        ; Entry - A = New scrim entry
        ;        Y = screen Y-coord
        ; Exit  - Tail of line wiped.
        ;        scrim updated
        ;        A,Y preserved.
        STA     ATEMP
        LDAAY   SCRIM
        CMP     ATEMP
        BCC     WTSCRM
        BEQ     WTSCRM
        LDAIM   28
        JSR     OSWRCH
        LDA     ATEMP
        INA
        JSR     OSWRCH
        PHX
        LDA     TUTMODE
        ANDIM   7
        TAX
        TYA
        CLC
        ADCAX   VERTTB
        PLX
        PHA
        JSR     OSWRCH
        LDAAY   SCRIM
        JSR     OSWRCH
        PLA
        JSR     OSWRCH
        LDAIM   12
        JSR     OSWRCH
        PHY
        JSR     DECWIN
        PLY
WTSCRM
        LDA     ATEMP
        STAAY   SCRIM
        RTS
UPDTLN
        ; Entry - A = Y-coord of 1st line to be output.
        ;        XY --> 1st line to be output.
        ;        maxscrupY = last line to be updated.
        ; Exit  - line output, with rest of line wiped if necessary
        ;        scrim,scrupY assigned (top bit set if no <CR> on line)
        ;        If was last line (temp = hymem after update), then
        ;        loop clearing lines until scrupY = pagelength.
        ;        CC - Normal termination
        ;        CS - Update aborted due to incoming character.
        STA     SCRUPY
        STX     TP
        STY     TP+1
        LDXIM   0
        LDA     UPDATEREQD
        CMPIM   CSRTOCR
        BEQ     UPDLC0
        ; If updatereqd = csronwards then start screen update from char under cursor.
        CMPIM   CSRONWARDS
        BNE     UPDLCO
UPDLC0
        LDX     SCRNX
        CPX     CURRLENGTH
        BCC     UPDLCO
        LDX     CURRLENGTH
UPDLCO
        PHX
        LDY     SCRUPY
        JSR     CSRXY
        PLY
        DEY
UPDLLP
        INY
UPDLL2
        LDAIY   TP
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     UPDLCR
        JSR     PASWRCH
        CPY     PAGEWIDTH
        BNE     UPDLLP
        BRA     UPDLEN
UPDLCR
        JSR     PASWCR
UPDLEN
        STY     COUNT ; Max csrX on this line.
        ; Superimpose marks, if any, onto this line.
        LDY     MARKX
MOUTLP
        DEY
        BMI     MOUTEX
        STY     INDEX
        ; If 0 <= (Mark - TP) <= count, then this is csrX within line.
        SEC
        LDAAY   UMATLO
        SBC     TP
        TAX
        LDAAY   UMATHI
        SBC     TP+1
        BCC     MOUTLP
        BNE     MOUTLP
        CPX     COUNT
        BEQ     MOUTMO
        BCS     MOUTLP
MOUTMO
        LDY     SCRUPY
        JSR     CSRXY
        LDA     INDEX
        CLC
        ADCIM   "1"
        JSR     INVWRCH
        LDX     COUNT
        INX
        JSR     CSRXY
        LDY     INDEX
        BRA     MOUTLP
MOUTEX
        ; Update TP, and see if have hit end of file.
        LDA     COUNT
        LDY     SCRUPY
        JSR     WIPETAIL
        JSR     TPPAP1 ; A = count
        BCS     UPDLNE
        LDA     UPDATE
        CMPIM   CSRTOCR
        BEQ     UPDLFI
        LDY     SCRUPY
        CPY     MAXSCRUPY
        BCS     UPDLFI
        ; Test if any characters/commands are being queued in buffer.
        LDA     UPDATER
        CMPIM   THELOT
        BEQ     QUEUEX
        LDA     NEXTREADFLAG
        BNE     QUEUCS
        LDAIM   &81
        LDXIM   0
        LDYIM   0
        JSR     OSBYTE
        CPYIM   &FF
        BEQ     QUEUEX
        JSR     ESCTST
        INC     NEXTREADFLAG
        STX     NXTCHR
QUEUCS
        SEC
        RTS
QUEUEX
        INC     SCRUPY
        LDXIM   0
        JMP     UPDLCO
        ; Overwrite sentinal EOT TERMIN with EOT character.
UPDLNE
        LDX     COUNT
        LDY     SCRUPY
        JSR     CSRXY
        LDAIM   "*"
        JSR     INVWRCH
        BRA     UDLET1
UDLEOT
        LDY     SCRUPY
        JSR     WIPELINE
UDLET1
        INC     SCRUPY
        CPY     PAGELENGTH
        BCC     UDLEOT
UPDLFI
        CLC
        RTS
PASWRCH
        ; Entry - A = char to output.
        ; Exit  - Y preserved
        ;        ctrl ch     --> inverted or chr(255) depending on mode
        ;        delete      --> inv ?
        ;        other chars --> echoed
        CMPIM   SPACE
        BCC     PASWNC
        CMPIM   DELETE
        BNE     PASWOS
        LDAIM   "?"
        BRA     INVWRCH
PASWOS
        JMP     OSWRCH
PASWCR
        LDAIM   &20
        BIT     TUTMODE
        BEQ     PASWOS
        [ lfarro=1
        LDAIM   nlfarr
        |
        LDAIM   "$"       ; **
        ]
        BRA     INVWRCH   ; **
PASWNC
        ORAIM   &40 ; Output control character as inverted keytop.
INVWRCH
        ; Output character in inverse video (blob in mode 7).
        ; Entry - A = character
        ;        mode IN [0..7]
        PHA
        LDA     TUTMODE
        ANDIM   7
        CMPIM   7
        BNE     INVWN7
        PLA
        LDAIM   255
        BRA     PASWOS
INVWN7
        JSR     STARTINV
        PLA
        JSR     OSWRCH
STOPINV
        LDAIM   17
        JSR     OSWRCH
        LDAIM   128
        JSR     OSWRCH
        LDAIM   17
        JSR     OSWRCH
        LDAIM   7
        JMP     OSWRCH
STARTINV
        JSR     VSTRNG
        = 17,135,17,0,&EA
        RTS
CURLT
        JSR     STARTTEST
        BCC     CLCONT
        LDA     SCRNX
        BEQ     CSREXI
CLCONT
        DEC     SCRNX
        BPL     CSREXI
        LDA     PAGEWIDTH
        STA     SCRNX
        ; C set if at start of text
CURUP
        JSR     STARTTEST
        BCS     CSREXI
        LDAIM   1
        JSR     MVLNBK
        LDA     TSM
        CMP     SCRNY
        BCS     CUUPSC
CUUPNS
        DEC     SCRNY
        BPL     CSREXI
CUUPSC
        LDA     SCRNY ; In Top Scroll Margin. If more than Top Scroll Margin Width
        JSR     TPGSBK ; from top of file, then assign Scroll Pointer, else move cursor up.
        CMP     SCRNY
        CLC
        BNE     CUUPNS
        LDA     TP
        STA     SCP
        LDA     TP+1
        STA     SCP+1
        LDAIM   HARDDOWN
        STA     UPDATEREQD
        RTS
WORDRT
        LDY     SCRNX
        LDAIY   GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     EASYRT
        JSR     CURDWN
        BCS     WORDXX
        JSR     SCRNUD
CURST
        CLR     SCRNX
        BRA     CSREXI
WORDXX
        PLA
        PLA
        RTS
EASYRT
        JSR     CURRT
        JSR     SCRNUD
        BRA     CSREXI
WORDLT
        LDA     SCRNX
        BNE     CURLT
        JSR     CURUP
        BCS     WORDXX
        JSR     SCRNUD
CUREND
        LDA     CURRLENGTH
        STA     SCRNX
CSREXI
        CLR     UPDATEREQD
        RTS
CURRT
        LDA     SCRNX
        CMP     PAGEWIDTH
        BEQ     CURRCO
        INC     SCRNX
        BRA     CSREXI
CURRCO
        JSR     ENDTEST
        BCS     CSREXI
        CLR     SCRNX
        ; C set if at text end
CURDWN
        JSR     ENDTEST
        BCS     CSREXI
        LDAIM   1
        JSR     MVLNFD
        LDA     SCRNY
        CMP     BSM
        BCS     CUDOSC
        INC     SCRNY
        BRA     CSREXI
CUDOSC
        ; In Bottom Scroll Margin.
        ; If more than (Pagelength-Bottom Scroll Margin)
        ; from bottom of file, then assign Scroll Pointer, else set SCP+1 to
        ; 0 to indicate wipeline required.

        STZ     SCP+1         ; Initialize SCP+1 to 0 implies
                              ; blank line required for scroll.
        SEC
        LDA     PAGELENGTH
        SBC     BSM
        JSR     TPGEFD
        LDA     COUNT
        BNE     CUDOWS
        LDA     TP
        STA     SCP
        LDA     TP+1
        STA     SCP+1
CUDOWS
        LDAIM   HARDUP
        STA     UPDATE
        CLC
WORDRX
        RTS
WORDRIGHT
        LDA     CURRLE
        CMP     SCRNX
        BCS     WORDR3
        STA     SCRNX
        BRA     WORDR3
WORDR1
        JSR     WORDRT
WORDR3
        LDY     SCRNX
        LDAIY   GE
        JSR     WORDC
        BCC     WORDR1
WORDR2
        LDY     SCRNX
        LDAIY   GE
        JSR     WORDC
        BCC     WORDRX
        JSR     WORDRT
        BRA     WORDR2
WORDL1
        JSR     WORDLT
        LDY     SCRNX
        LDAIY   GE
        JSR     WORDC
        BCC     WORDL1
WORDL2
        LDY     SCRNX
        LDAIY   GE
        JSR     WORDC
        BCC     CURRT
        JSR     WORDLT
        BRA     WORDL2
WORDLEFT
        LDA     CURRLE
        CMP     SCRNX
        BCS     WORDL1
        STA     SCRNX
WORDCX
        SEC
        RTS
        ; C set if not wordc
WORDC
        CMPIM   "0"
        BCC     WORDCX
        CMPIM   "9" + 1
        BCC     WORDCR
        ANDIM   &DF
        CMPIM   "A"
        BCC     WORDCX
        CMPIM   "Z" + 1
WORDCR
        RTS

EDITi2
        LDX     TSTART
        LDY     TSTART + 1

EDITtd
        STX     GS
        STY     GS + 1
        LDA     TMAX
        STA     GE
        LDA     TMAX + 1
        STA     GE + 1
EDITxx
        STZ     CURSED
        STZ     NEXTRE
        STZ     MARKX
        [ cf8key=1
        LDAZ    clterm
        |
        LDAIM   termin
        ]
        STAI    PAJE
        STAI    TMAX
STFILE
        LDX     tstart
        LDY     tstart + 1
        JSR     GPBKXY
        CLR     SCRNX   ; CLR scrnY will be forced by scrnud
STFILX
        RTS

CUREDF
        LDA     BSM     ; Try to glue bottom of file to BSM.
        STA     SCRNY
        LDX     TMAX
        LDY     TMAX + 1
        JSR     GPFDXY
        JMP     NORMAX

IOtogg                  ; Insert/Over toggle
        LDA     tutMOD
        EORIM   bit4    ; the correct bit
        JSR     doMODE
        JMP     CstatU

CHKSCR
        LDAIM   &87     ; select mode if tutmode and screen mode NOT the same
        JSR     OSBYTE
        LDA     TUTMOD
        ANDIM   &07
        TAX
        LDAAX   MODETB
        STY     STRING
        EOR     STRING
        ANDIM   &07
        BEQ     STFILX  ; same ok
SELSCR
        LDAIM   22      ; select the right screen mode
        JSR     OSWRCH
        LDA     TUTMODE
        ANDIM   &07
        TAY
        LDAAY   MODETB
        ORAIM   &80     ; select any shadow around
        JMP     OSWRCH


EDITMD                  ; Set up 'EDIT'
        JSR     selscr
EDITMA
        LDAIM   &83
        JSR     osbyte          ; Read PAJE
        STX     paje
        STY     paje + 1
        LDAIM   &84
        JSR     osbyte          ; Read HIMEM
        STX     hymem
        STY     hymem + 1

        ; Set up edit (text) buffer delimiting pointers.
        CLC
        LDA     paje
        ADCIM   1
        STA     tstart
        LDA     paje + 1
        ADCIM   0
        STA     tstart + 1
        LDA     hymem
        SBCIM   0               ; CC gives -1
        STA     tmax
        LDA     hymem + 1
        SBCIM   0
        STA     tmax + 1
        JSR     intpag          ; initialise pagelength and width
        LDA     pagele
        SEC
        SBCIM   4
        STA     BSM
        LDAIM   4
        STA     TSM
        RTS

tsmcsr
        ; Set Top Scroll Margin to current cursor line.
        LDA     scrnY
        STA     TSM
        BRA     noupda

bsmcsr
        ; Set Bottom Scroll Margin to current cursor line.
        LDA     scrnY
        STA     BSM
        BRA     noupda

scmclr
        ; Clear Scroll Margins.
        CLR     TSM
        LDA     pagele
        STA     BSM

noupda
        STZ     update
        RTS

newtex                          ; Clear text
        JSR     prompt
        [ stamp=1
        =       "Clear text [Y (dated),shf-f9 (exec)]",&EA
        LDAIM   &81
        TAX
        LDYIM   &03
        JSR     osbyte
        JSR     esctst
        TYA
        BEQ     doneW1
newtn
        JMP     status
doneW1
        PHX
        JSR     nstamp
        PLA
        ORAIM   &20
        CMPIM   "y"
        BNE     doneW2
        JSR     mstamp
doneW2
        JSR     memsta
        JMP     editin
        |
        =       "Text will be cleared if a key is hit",&EA
        LDAIM   &81
        TAX
        LDYIM   3
        JSR     osbyte
        JSR     esctst
        CPYIM   0
        BEQ     donew
newtn
        JMP     status
donew
        JSR     memsta
        JMP     editin
        ]

LOADfi
        ; Doesn't zap buffer until new file is correctly loaded.

        [ curtyp=1
        JSR     lsf
        ]

        LDA     MODFLG
        BEQ     LOADF2
        JSR     PROMPT
        =       "Overwrite text [Y,f2]:",&EA
        JSR     OSRDCH
        CMPIM   128+2
        BEQ     LOADF2
        ANDIM   &DF
        CMPIM   "Y"
        BNE     NEWTN
LOADF2
        JSR     PROMPT
        =       "Type filename to load:",&EA
        JSR     READNS
        LDYIM   0
        JSR     TLOAD
        JMP     EDITGT

SAVEfi                          ; Save file
        [ curtyp=1
        JSR     lsf
        ]

        JSR     dfinit
        CMPIM   &01          
        BEQ     marksa

        JSR     promtF
        =       "to save:",&07,&EA

        JSR     readns
        JSR     dfblok
        LDYIM   &00
        JSR     tsave

        STZ     modflg

        LDX     texp
        LDY     texp + 1
        JSR     gpfdXY
        JMP     normax

marksa
        JSR     promtF
        =       "for MARK TO CURSOR save:",&07,&EA
        JSR     readns
        JSR     dfblok
        LDYIM   &00
        LDAI    temp
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     msbad
        CMPIM   &8B
        BEQ     msbad
        LDA     temp
        STA     scratc
        LDA     temp + 1
        STA     scratc + 1
        JSR     inSAVE
        LDX     texp
        LDY     texp + 1
        JSR     gpfdXY
        JMP     normax
msbad
        BRK
        =       &01,"Bad use of stored name",null

insrtF
        [ curtyp=1
        JSR     lsf
        ]

        JSR     mkrefu
        JSR     finepo
        JSR     promtF
        =       "to insert:",&EA
        JSR     readns
        LDA     GS              
        STA     addr
        LDA     GS + 1
        STA     addr + 1
        LDA     GE
        LDX     GE + 1
        LDYIM   0
        JSR     PASLOAD
        STX     GS
        STY     GS+1
        JSR     MODIFY
        LDX     ADDR ; Move to start of inserted file.
        LDY     ADDR+1
        JSR     GPBKXY
        JMP     NORMAL

edSTAR                          ; OSCLI processing
        LDAIM   &01
        STA     BRKact
        JSR     initus
        JSR     prompt
        =       "Command line",&EA

        [ curtyp = 1
        JSR     lsf             ; slow line flash
        ]
starcn
        JSR     osnewl
starlo
        LDAIM   "*"
        JSR     oswrch
        LDAIM   &00
        LDYIM   :MSB: starCB
        LDXIM   starCB
        JSR     osword
        BCS     stares
        LDA     comman
        CMPIM   cr
        BEQ     starex
        LDXIM   :LSB: comman
        LDYIM   :MSB: comman
        JSR     oscli
        BRA     starlo
starCB
        &       comman
        =       238
        =       " "
        =       &FF
stares
        LDAIM   &7E
        JSR     osbyte
starex
        JSR     vstrng
        =       0,0,0,0,0,0,0,0,0,0,4,3,15,13,26,&EA
        JSR     chkscr
        JSR     inited
        JMP     editco

allowC
        ; Allow cursor editing & softkey use. Terminated by CR.
        LDAIM   &01
        STA     cursED

        [ PHIL=0
        JSR     INITUS
        ]

        JMP     CstatU

BADMODE
        BRK
        =       1,"Only 0,1,3,4,6,7,D or K"     ; followed by 0

verttb
        =       0,0,7,0,0,14,0                  ; plus another 0 in modetb

MODEtb
        =       0,1,0,3,4,0,6,7                 ; and the screen modes

GETMOD
        JSR     PROMPT
        =       "New Mode:",&EA
        JSR     OSRDCH
        JSR     OSWRCH
        JSR     ESCTST
        CMPIM   "7" + 1
        BCS     SETKEY
        SBCIM   "0" - 1
        BCC     BADMOD
        CMPIM   2
        BEQ     BADMOD
        CMPIM   5
        BEQ     BADMOD
        BRA     SETMOD
SETKEY
        ANDIM   &DF
        CMPIM   "D"
        BEQ     SETTUT
        CMPIM   "K"
        BNE     BADMODE
        LDAIM   &02
        BRA     SETMODE
SETTUT
        LDAIM   &05
SETMODE
        PHA

        [ origin=&8000
        TAY
        LDAAY   modetb
        PHA
        JSR     memsta
        LDAIM   &82
        JSR     osbyte
        INX
        BNE     inTUBE
        INY
        BNE     inTUBE
        PLA
        PHA
        ORAIM   &80
        TAX
        LDAIM   &85
        JSR     osbyte
        CPX     GS
        TYA
        SBC     GS + 1
        BCC     MODEsp
inTUBE
        PLX
        ]

        LDAIM   &7
        TRB     tutmod
        PLA
        ORA     tutmod
        JSR     domode

        [ origin=&8000
        JSR     EDITMD
        |
        JSR     CHKSCR
        LDAIM   26
        JSR     OSWRCH
        JSR     EDITMA
        LDA     BSM
        STA     SCRNY
        CLR     SCRNX
        JMP     EDITCO
        ]

OLDTEXT
        LDA     OLDSTA + 3
        CMP     PAJE + 1
        BCC     NOOLD
        CMP     HYMEM + 1
        BCS     NOOLD
        CMP     OLDSTA + 1
        BCC     NOOLD
        LDA     OLDSTA + 1
        CMP     PAJE + 1
        BCC     NOOLD
        LDA     OLDSTA
        STA     ARGP
        LDA     OLDSTA + 1
        STA     ARGP + 1
        SEC
        LDA     OLDSTA + 2
        SBC     ARGP
        TAX
        LDA     OLDSTA + 3
        SBC     ARGP + 1
        TAY           
        BCC     NOOLD
        LDA     TSTART
        STA     VARP
        LDA     TSTART + 1
        STA     VARP + 1
        PHY
        PHX
        JSR     COPYBK
        PLA
        CLC
        ADC     TSTART
        TAX
        PLA
        ADC     TSTART + 1
        TAY
        CLR     OLDSTA + 3
        JMP     EDITGS

MODESP
        JSR     STFILE
        BRK
        =       2,"No room"

NOOLD
        BRK
        =       2,"No old text found",0

GETNUM
        STZ     INDEX
        STZ     LINE
        STZ     LINE + 1
EDLIRE
        LDY     INDEX
        LDAIY   TEMP
        CMPIM   CR
        BEQ     EDLIMV
        CMPIM   "9" + 1
        BCS     EDLIBN
        SBCIM   "0" - 1
        BCC     EDLIBN
        STA     ATEMP
        LDAIM   10 ; line = line * 10 + atemp
        LDXIM   0
        LDYIM   0
        CLC

EDLI10
        PHA
        TXA
        ADC     LINE
        TAX
        TYA
        ADC     LINE + 1
        TAY
        BCS     EDLIBN
        PLA
        DEA
        BNE     EDLI10
        TXA
        ADC     ATEMP
        STA     LINE
        BCC     EDLNHI
        INY
        BEQ     EDLIBN
EDLNHI
        STY     LINE + 1
        INC     INDEX
        BNE     EDLIRE
EDLIMV
        RTS

EDITLI
        LDAIM   1               ; Move to specified line number.
        STA     LINE
        CLR     LINE + 1
        LDA     TSTART
        STA     STRING
        LDA     TSTART + 1
        STA     STRING + 1
LOKLINE
        LDAI    STRING
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     LOKLI2
        INC     LINE
        BNE     LOKLI2
        INC     LINE + 1
LOKLI2
        INC     STRING
        BNE     LOKLI3
        INC     STRING + 1
LOKLI3
        LDA     STRING
        CMP     GS
        LDA     STRING + 1
        SBC     GS+1
        BCC     LOKLINE
        JSR     PROMPT
        =       "At line ",&EA
        JSR     WRITLINE
        JSR     VSTRNG
        =       ", new line:",&EA
        JSR     STOPINV
        JSR     readns
        BNE     LOLI4

EDLIBN
        BRK
        =       1,"Bad number"

EDLIBL
        BRK
        =       2,"Line not found",0

LOLI4
        JSR     GETNUM
        ; Number is held in line. Numbers start at 1 ...
        SEC
        LDA     LINE
        SBCIM   1
        STA     LINE
        LDA     LINE + 1
        SBCIM   0
        STA     LINE+1
        BCC     EDLIBN
        JSR     STFILE
        LDA     GE
        STA     TP
        LDA     GE + 1
        STA     TP + 1

EDLIFW
        LDA     LINE
        ORA     LINE + 1
        BEQ     EDLIGO

EDLICR
        LDAIM   1
        JSR     TPFWDA
        BCS     EDLIBL
        LDA     ATEMP
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     EDLICR
        LDA     LINE
        BNE     EDLNHD
        DEC     LINE+1

EDLNHD
        DEC     LINE
        BRA     EDLIFW

EDLIGO
        ; Move to BSM.
        LDA     TSM
        BNE     EDLIGJ
        LDAIM   4

EDLIGJ
        STA     SCRNY
        JMP     GPFDTP

        [ cf8key=1
        ; ------------------------------------------------------------ ;

cf8swt                          ; CR/LF switch
        LDAZ    clterm
        CMPIM   cr
        BEQ     setLF
        LDAIM   cr
        STAZ    clterm
        BRA     cont99
setLF
        LDAIM   lf
        STAZ    clterm
cont99
        STZ     cursed
        STZ     nextre
        STZ     markX

        LDAZ    clterm
        STAI    paje
        STAI    tmax

        STZ     SCRNX           ; CLR scrnY will be forced by scrnud

        JSR     stFILE          ; move the cursor to the top
                                ; of the text
        JMP     EDITco          ; and continue editing

        ; ------------------------------------------------------------ ;
        ]

        LNK     EDIT07
