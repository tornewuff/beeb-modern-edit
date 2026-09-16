        ; -> EDIT02
        ;                                      current
        ;                                      line
        ; PAJE                                                 HYMEM
        ;  v                                   <......>          v
        ; +-+-------------+-------------------+---------------+-+
        ; |$|.............|                 |...............|$|
        ; +-+-------------+-------------------+---------------+-+
        ;    ^             ^                   ^               ^
        ; TSTART           GS                  GE            TMAX
        ; scrnXAs is X coord of cursor. (GE)creenX is char under cursor,
        ; unless $ isA0 in (GE) .. (GE),scrnX (when it is that $).
        ; scrnY is Y coord of current line on screen, and may be forced by the
        ; screen update routine.
        ; Screen update types:-
        ;  none   ; Simple cursor movements
        ;  csronw ; Character insert/delete
        ;  fullsc ; Find,replace etc
        ;  thelot ; Clears screen first. After tload etc
        ;  hardup ; Special case, for cursor movevents
        ;  harddo ; Special case, for cursor movevents
        ;  pagewi ; is max X-coord of screen, and pagelength is max Y-coord of
        ;           screen (thus Y-coord of status line is pagelength + 1).
        ;  scrim  (screen image) holds maximum cursorX position written to each
        ;         line on the screen (including the CR, if any)
EDIT
        JSR     editmd

        [ stamp = 1
        JSR     nstamp
        ]
EDITin
        LDX     tstart          ; Initialize pointers to reflect empty buffer.
        LDY     tstart + 1
EDITgt
        STZ     modflg          ; Re-entry point for Tload. XY = End of file.
EDITgs
        JSR     EDITtd          ; Re-entry from OLDSTA, newmode
EDITco
        LDXIM &FF               ; Re-entry point for brk-handler.
        TXS
        STZ     BRKact
        JSR     inited
        LDAIM   thelot
        STA     update

EDITlo                          ; Update screen to reflect previous command.

        JSR     SCRNUD
        JSR     CSRSCR
        JSR     CURON

        [ curtyp=1
        JSR     curupd          ; update the cursor to relevant state
        ]

        LDAIM   FULLSC
        STA     UPDATE
        ; Read a char, and branch depending on its value
        ;   &00 - &7F     is ASCII input to be entered as text
        ;   &80 - &8F     are softkey values       }
        ;   &90 - &9F     are shift-softkey values } Editor commands
        ;   &A0 - &AF     are ctrl-sofkkey values  }
        ;   &8A, &9A, &AA is the TAB key
        ;   &B0 - &FF     are entered into text (e.g. icelandics)
        JSR     EDRDCH
        TAX
        BPL     EDITTE
        CMPIM   &B0
        BCS     EDITTE

        [ phil = 0
        LDX     CURSED
        BNE     EDITTE
        TAX
        |
        TAX
        LDA     CURSED
        BEQ     PHIL1
        TXA
        ANDIM   &F
        CMPIM   &A
        TXA
        BCC     EDITTE
phil1
        ]

        LDA     TUTMOD
        ANDIM   7
        CMPIM   5
        BNE     GOMAN
        CPXIM   &9C
        BCS     GOMAN
        CPXIM   &90
        BCS     DEFVAL
        CPXIM   &8A
        BCS     GOMAN
DEFVAL
        TXA
        PHA
        ASLA
        TAY
        JSR     VSTRNG
        =       26,30,31,0,8,&EA
        LDAAY   TXTTAB
        STA     STRING
        LDAAY   TXTTAB + 1
        STA     STRING + 1
TUTLIN
        LDYIM   &00
        JSR     osnewl
TUTOUT
        LDAI    STRING
        INC     STRING
        BNE     TUTINC
        INC     STRING + 1
TUTINC
        CMPIM   cr
        BEQ     NEEDWP
        CMPIM   &EA
        BEQ     TUTDON
        JSR     OSWRCH
        INY
        BRA     TUTOUT
NEEDWP
        LDAIM   " "
TUTWIP
        CPYIM   54
        BCS     TUTLIN
        JSR     OSWRCH
        INY
        BRA     TUTWIP
TUTDON
        JSR     DECWIN
        JSR     CSRSCR
        PLX
GOMAN
        TXA
        ASLA
        TAX
        JSR     IADDRS
        JMP     EDITlo
IADDRS
        JMIX    EDCTBL
EDITTE
        JSR     EDTEXT
        JMP     EDITlo
EDTEXT
        ; Entry - A holds ASCII char to be treated as text input
        ; Exit  - appropraite action taken depending on current
        ;        'mode' (insert, overtype, csr-edit).
        CMPIM   DELETE
        BEQ     ECHRDE
        CLR     OLDSTA + 3
        CMPIM   cr
        BNE     ECHRCO
        JSR     TESTIF ;In insert mode put in the CR
        BNE     ECHRCR
        JSR     ENDTES
        BCS     ECHRCR
        CLR     SCRNX
        JMP     CURDWN ;in overtype mode CR is start of line
ECHRCR
        [ cf8key=1
        LDAZ    clterm
        |
        LDAIM   termin
        ]
ECHRCO
        ; Insert character into text.
        PHA
        JSR     ADDVIR
        ; Don't insert in overtype mode, unless at end of line.
        JSR     TESTIF
        BNE     ECHRMV
        LDY     SCRNX
        LDAIY   GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     ECHRCH
ECHRMV
        LDXIM 1
        LDA     SCRNX
        JSR     INSRTX
ECHRCH
        PLA
        LDY     SCRNX
        STAIY   GE
        ; Write char to screen (cursor OK), wiping tail for TERMIN.
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     ECHRNT
        JSR     PASWCR
        LDA     SCRNX
        LDY     SCRNY
        JSR     WIPETA
EHRCSU
        CLR     SCRNX
        JSR     CURDWN
ECHRUP
        LDA     UPDATE
        BEQ     ECHREL
        JSR     SCRNUD
ECHREL
        LDAIM   CSRONW
        STA     UPDATE
        JMP     MODIFY
ECHRNT
        JSR     PASWRC
        JSR     CURRT
ECHRN0
        LDA     UPDATE
        BEQ     ECHRN1
        JSR     SCRNUD
ECHRN1
        LDAIM   CSRTOC
        STA     UPDATE
        JMP     MODIFY
ECHRDE
        ; Delete virtual space implies csrleft. Can't delete start of file.
        JSR     VSCOUN
        BEQ     EDELST
        JMP     CURLT
EDELST
        LDA     SCRNX
        BNE     EDELCO
        JSR     STARTTEST
        BCS     DELABX
EDELCO
        ; Get char to be deleted under cursor. In absence of VS check,
        ; this will give TERMIN delete when past end of line.
        JSR     CURLT
        JSR     LENGTH          ; different line than current!
        CMP     SCRNX
        BCS     EDELMT
        STA     SCRNX
EDELMT
        ; Branch on text-entry mode (insert/overtype).
        LDY     SCRNX
        JSR     TESTIF
        BNE     EDELSL
        LDAIY   GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     DELABX
        LDAIM   SPACE
        STAIY   GE
        LDAIM   CSRTOC
        STA     UPDATE
        JMP     MODIFY
EDELSL
        LDAIY   GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BEQ     EDELS2
        LDA     CURRLE
        CMP     PAGEWI
        BEQ     EDELS2
        JSR     EDEL1
        BRA     ECHRN0
EDELS2
        JSR     EDEL1
        BRA     ECHRUP
DELLIX
        JSR     DELABV
DELLIN
        CLR     SCRNX
        LDAI    GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     DELLIX
        JSR     LENGTH
        STA     CURRLE
        JSR     DELABV
        JMP     ECHREL
DELABV
        JSR     ENDTES
        BCC     DELABY
        LDA     SCRNX
        CMP     CURRLE
        BCC     DELABY
DELABX
        RTS
DELABY
        LDA     CURRLE
        CMP     SCRNX
        BCC     DELABX
        LDYIM   CSRTOC
        STY     UPDATE
        CMP     PAGEWI
        BEQ     EDEL0
        LDY     SCRNX
        LDAIY   GE
        [ cf8key=1
        CMPZ    clterm
        |
        CMPIM   termin
        ]
        BNE     EDEL1
EDEL0
        INC     UPDATE
EDEL1
        ; Shift up start of line 'over' deleted character.
        JSR     MODIFY
        CLC
        LDA     GE
        STA     TEMP
        ADC     SCRNX
        STA     ADDR
        LDA     GE + 1
        STA     TEMP + 1
        ADCIM   0
        STA     ADDR + 1
        INC     GE
        BNE     EDELNH
        INC     GE + 1
EDELNH
        LDY     SCRNX
        BRA     EDELDY
EDELLP
        LDAIY   TEMP
        STAIY   GE
EDELDY
        DEY
        BPL     EDELLP
        LDX     MARKX
EDELMK
        DEX
        BMI     DELABX
        LDYAX   SMATLO
        CPY     ADDR
        LDAAX   SMATHI
        SBC     ADDR + 1
        BCS     EDELMK
        INCAX   SMATLO
        BNE     EDELMK
        INCAX   SMATHI
        BRA     EDELMK

EDCTBL
        &       EDITli          ; f0
        &       EDstar          ; f1
        &       LOADfi          ; f2
        &       SAVEfi          ; f3
        &       findre          ; f4
        &       globre          ; f5
        &       setmar          ; f6
        &       mkCPY           ; f7
        &       print           ; f8
        &       oldtex          ; f9
        &       tabkey          ; f10
        &       delabv          ; copy
        &       curLT           ; left
        &       curRT           ; right
        &       curDWN          ; down
        &       curUP           ; up
        ;
        &       crtogg          ; shift-f0
        &       IOtogg          ; shift-f1
        &       insrtf          ; shift-f2
        &       scmclr          ; shift-f3
        &       retlan          ; shift-f4
        &       getmod          ; shift-f5
        &       clearm          ; shift-f6
        &       mkmve           ; shift-f7
        &       mkdel           ; shift-f8
        &       newtex          ; shift-f9
        &       tabctl          ; shift-f10
        &       allowc          ; shift-copy
        &       wordle          ; shift-left
        &       wordri          ; shift-right
        &       pagedn          ; shift-down
        &       pageup          ; shift-up
        ;
        &       EDITlo          ; ctrl-f0
        &       EDITlo          ; ctrl-f1
        &       EDITlo          ; ctrl-f2
        &       EDITlo          ; ctrl-f3
        &       EDITlo          ; ctrl-f4
        &       EDITlo          ; ctrl-f5
        &       tsmcsr          ; ctrl-f6
        &       bsmcsr          ; ctrl-f7
        [ cf8key=1
        &       cf8swt          ; ctrl-f8
        |
        &       EDITlo          ; ctrl-f8
        ]
        &       EDITlo          ; ctrl-f9
        &       EDITlo          ; ctrl-f10
        &       dellin          ; ctrl-copy
        &       curst           ; ctrl-left
        &       curend          ; ctrl-right
        &       curedf          ; ctrl-down
        &       stfile          ; ctrl-up

TXTTAB
        &       F0
        &       F1
        &       F2
        &       F3
        &       F4
        &       F5
        &       F6
        &       F7
        &       F8
        &       F9
        &       F9
        &       F9
        &       F9
        &       F9
        &       F9
        &       F9
        &       SHFF0
        &       SHFF1
        &       SHFF2
        &       SHFF3
        &       SHFF4
        &       SHFF5
        &       SHFF6
        &       SHFF7
        &       SHFF8
        &       SHFF9
        &       SHFTAB
        &       SHFCOP
BIGMES
        JSR VSTRNG
        =       "°shf-f0¦§shf-f1¦§shf-f2¦§shf-f3¦§shf-f4¦§shf-f5¦§shf-f6¦§shf-f7¦§shf-f8¦§shf-f9±"
        =       "©Display©Insert/©Insert ©Remove ©Return © Set   © Clear ©Marked ©Marked ©Clear ©"
        =       "©Returns©Over   © file  ©Margins©Languag© Mode  © Marks ©Move   ©Delete ©text  ©"
        =       "«¦¦f0¦¦¦¯¦¦f1¦¦¦¯¦¦f2¦¦¦¯¦¦f3¦¦¦¯¦¦f4¦¦¦¯¦¦f5¦¦¦¯¦¦f6¦¦¦¯¦¦f7¦¦¦¯¦¦f8¦¦¦¯¦¦f9¦¦­"
        =       "© Goto  ©Command© Load  © Save  ©Find   ©Global © Mark  ©Marked © Print © Old  ©"
        =       "© line  ©line   © file  © file  ©String ©Replace© Place ©Copy   © text  © text ©"
        =       "²¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦¦®¦¦¦¦¦¦³"
        NOP
        RTS
BIGMET
        JSR     VSTRNG
        =       "The Acorn Screen Editor ‡ 1984 Acorn Computers Ver $vers"

        [ mouse = 1
        =       "m"
        |
        =       " "
        ]

        =       "°¦¦¦±Shift: screen up   "      ; EOL 1

        [ syzygy=1      ; "a SYZYGY prog"

        =       "      a"
        =       23,32,&00,&01,&01,&01,&00,&01,&01,&01,32
        =       23,32,&F4,&14,&04,&F3,&10,&10,&10,&E7,32
        =       23,32,&5F,&41,&42,&C4,&48,&50,&50,&9F,32
        =       23,32,&44,&45,&45,&3C,&04,&04,&04,&79,32
        =       23,32,&F4,&14,&14,&F3,&10,&10,&10,&E7,32
        =       23,32,&40,&40,&40,&C0,&40,&40,&40,&80,32
        =       23,32,&00,&00,&00,&00,&00,&00,&00,&00
        =       "prog "
        |
        =       "                  "
        ]

        =       "             Descriptive Mode "

        [ cf8key=1
        =       "CR/LF"
        |
        [ termin=lf
        =       "(LF) "
        |
        =       "     "
        ]
        ]

        =       "   © ‹ ©Control: text start"  ; EOL 2

        =       "TAB performs tabulation controlled by shift TAB.      °¦®¦§¦®¦±Shift: word l/r  "  ; EOL 3

        =       "COPY deletes the character above the cursor.          © ˆ¤©¢‰ ©Control:         "  ; EOL 4

        =       "shift COPY provides normal soft keys and cursor       ²¦§¦®¦§¦³    l/r of line  "  ; EOL 5

        =       "       copying (ESCAPE to leave this mode).             © Š ©Shift: screen down "  ; EOL 6

        =       "control COPY deletes the current line to next new line  ²¦¦¦³Control: text end  "  ; EOL 7
        NOP
        RTS

f0
        =       "f0",cr
        [ shortm=0
        =       "The cursor can be moved to a new line.",cr
        =       "For this operation lines are character sequences",cr
        =       "ended by RETURN (|M).",cr,&EA
        |
        =       "Move the cursor to a new line",cr
        =       "Lines are character sequences ended by RETURN (|M)",cr
        =       cr
        NOP
        ]

shff0
        =       "shf-f0",cr
        [ shortm=0
        =       "The ends of lines can be shown as a special",cr
        =       "character so that they can be seen clearly.",cr
        =       "This alters with each press of shf-f0.",cr,&EA
        |
        =       "Highlight the end of line character",cr
        =       "This is a toggled function",cr
        =       cr
        NOP
        ]

F1
        =       "f1",cr
        [ shortm=0
        =       "Commands to the computer's operating system can be",cr
        =       "given. The result is seen at once. Extra commands",cr
        =       "can be entered until RETURN by itself is typed.",cr,&EA
        |
        =       "Commands can be sent to the Command Line Interpreter",cr
        =       "The function is terminated by RETURN only",cr
        =       cr
        NOP
        ]

SHFF1
        =       "shf-f1",cr
        [ shortm=0
        =       "Changes between Insert and Over. In Insert mode the",cr
        =       "text typed is inserted causing the existing text to",cr
        =       "move. In Over mode the text is typed over old text.",cr,&EA
        |
        =       "Toggle Insert/Over mode",cr
        =       cr
        =       cr
        NOP
        ]

F2
        =       "f2",cr
        [ shortm=0
        =       "A text file will be loaded, erasing the current text.",cr
        =       "RETURN uses the name at the start of text after a '>'",cr
        =       "COPY, RETURN to use the current file name.",cr,&EA
        |
        =       "Load file, erasing the current text",cr
        =       "RETURN uses the name at the start of text after a '>'",cr
        =       "COPY RETURN to use the current file name",cr
        NOP
        ]

SHFF2
        =       "shf-f2",cr
        [ shortm=0
        =       "A text file will be loaded at the current cursor.",cr
        =       "RETURN uses the name at the start of text after a '>'",cr
        =       "COPY, RETURN to use the current file name.",cr,&EA
        |
        =       "Insert file to current cursor position",cr
        =       "RETURN uses the name at the start of text after a '>'",cr
        =       "COPY RETURN to use the current file name",cr
        NOP
        ]

F3
        =       "f3",cr
        [ shortm=0
        =       "All or 'mark to cursor' text will be saved to a file.",cr
        =       "RETURN uses the name at the start of text after a '>'",cr
        =       "COPY, RETURN to use the current file name.",cr,&EA
        |
        =       "Save text. All or 'mark to cursor' text will be saved",cr
        =       "RETURN uses the name at the start of text after a '>'",cr
        =       "COPY RETURN to use the current file name",cr
        NOP
        ]

SHFF3
        =       "shf-f3",cr
        [ shortm=0
        =       "The top and bottom scroll margins have been removed.",cr
        =       "Set Top scroll margin to cursor line with ctrl-f6",cr
        =       "Set Bottom scroll margin to cursor line with ctrl-f7",cr,&EA
        |
        =       "Remove top and bottom scroll margins",cr
        =       "Set Top scroll margin to current line with ctrl-f6",cr
        =       "Set Bottom scroll margin to current line with ctrl-f7",cr
        NOP
        ]

F4
        =       "f4:- Interactive Find and Replace Function.",cr
        [ shortm=0
        =       "RETURN to use last f4. Special search characters are:",cr
        =       "# digit, $ RETURN, . any, [ ] set of char, a-z a to z",cr
        =       "~ not, * many, ^ many, | control, @ alpha, \ literal.",cr,&EA
        |
        =       "RETURN to use last f4. Special search characters are:",cr
        =       "# digit, $ RETURN, . any, [ ] set of char, a-z a to z",cr
        =       "~ not, * many, ^ many, | control, @ alpha, \ literal.",cr
        NOP
        ]

SHFF4
        =       "shf-f4",cr
        [ shortm=0
        =       "Return to specified language.",cr
        =       "The text in the buffer will be 'transferred' into the",cr
        =       "language.",cr,&EA
        |
        =       "Return to specified language",cr
        =       "Text is transferred to the language",cr
        =       cr
        NOP
        ]

F5
        [ shortm=0
        =       "f5:- Global replace.              All, or marked text.",cr
        =       "RETURN to use last f5. Special replace characters are:",cr
        =       "/ to begin the replace section; & is the found string",cr
        =       "%n found wild section n. See f4 for find characters.",cr,&EA
        |
        =       "f5: Global replace. All or marked text",cr
        =       "RETURN to use last f5. Special replace characters are:",cr
        =       "/ to begin the replace section; & is the found string",cr
        =       "%n found wild section n. See f4 for find characters.",cr
        NOP
        ]

SHFF5
        =       "shf-f5",cr
        [ shortm=0
        =       "The screen mode may be set to a specific mode. Also",cr
        =       "Descriptive (D), or Key legend (K) modes may be set.",cr
        =       "D and K use mode 0.",cr,&EA
        |
        =       "Set screen mode",cr
        =       "D - Descriptive",cr
        =       "K - Key legend",cr
        NOP
        ]

F6
        =       "f6",cr
        [ shortm=0
        =       "The current position of the cursor (_) is remembered.",cr
        =       "The number at the bottom indicates how many (0,1,2)",cr
        =       "marks (",255,") are being used.",cr,&EA
        |
        =       "Set a marker",cr
        =       "The number (0,1,2) of marks (",255,") set is",cr
        =       "given on the status line",cr
        NOP
        ]

SHFF6
        =       "shf-f6",cr
        [ shortm=0
        =       "All place marks are cleared.",cr
        =       "",cr
        =       "",cr,&EA
        |
        =       "Clear markers",cr
        =       cr
        =       cr
        NOP
        ]

F7
        =       "f7",cr
        [ shortm=0
        =       "The text between two marked places is copied to",cr
        =       "the current cursor position.",cr
        =       "The marks are NOT cleared.",cr,&EA
        |
        =       "Text is copied to the current position",cr
        =       "The marks are NOT cleared",cr
        =       cr
        NOP
        ]

SHFF7
        =       "shf-f7",cr
        [ shortm=0
        =       "The text between two marked places is moved to",cr
        =       "the current cursor position.",cr
        =       "The marks are then cleared.",cr,&EA
        |
        =       "Text is moved to current position",cr
        =       "The marks are cleared",cr
        =       cr
        NOP
        ]

F8
        =       "f8",cr
        [ shortm=0
        =       "The whole text is printed out to the screen or printer",cr
        =       "using the built-in formatter/paginator.",cr
        =       "",cr,&EA
        |
        =       "Print text to screen or printer",cr
        =       cr
        =       cr
        NOP
        ]

SHFF8
        =       "shf-f8",cr
        [ shortm=0
        =       "The text between the cursor and the marked place",cr
        =       "is deleted.",cr
        =       "The mark is then cleared.",cr,&EA
        |
        =       "Delete text between marker and current position",cr
        =       "The mark is then cleared",cr
        =       cr
        NOP
        ]

F9
        =       "f9",cr
        [ shortm=0
        =       "The old text in the buffer is recovered after a BREAK",cr
        =       "or immediately after a Clear Text (by shf-f9).",cr
        =       "",cr,&EA
        |
        =       "Recover old text",cr
        =       cr
        =       cr
        NOP
        ]

SHFF9
        =       "shf-f9",cr
        [ shortm=0
        =       "All text in the buffer is deleted.",cr
        =       "Use shf-f9 twice to remove the text beyond hope of a",cr
        =       "recovery by f9.",cr,&EA
        |
        =       "Delete text",cr
        [ stamp=0
        =       "shf-f9 twice will remove text beyond recovery by f9",cr
        =       cr
        |
        =       "shf-f9 Y will select time stamping",cr
        =       "shf-f9 shf-f9 selects 'EXEC' addresses",cr
        ]
        NOP
        ]

SHFTAB
        =       "shf-TAB",cr
        [ shortm=0
        =       "The TAB key may be used to move to zones of eight",cr
        =       "characters across the screen, or to position under",cr
        =       "the first character of the line immediately above.",cr,&EA
        |
        =       "TAB to columns of 8, or to the position under the",cr
        =       "first character of the previous line",cr
        =       cr
        NOP
        ]

SHFCOP
        =       "shf-COPY",cr
        [ shortm=0
        =       "Cursor editing can be used with ‹ˆ¤¢‰Š and COPY.",cr
        =       "User defined soft keys are available as normal.",cr
        =       "All characters except ESCAPE are put into text.",cr,&EA
        |
        =       "Cursor editing mode. ‹ˆ¤¢‰Š and COPY and user",cr
        =       "defined soft keys available as normal",cr
        =       "ESCAPE terminates this mode",cr
        NOP
        ]

        [ cF8key=1
ctrlF8
        =       "Ctrl-f8",cr
        =       "Toggle newline character between LF(|J) and CR(|M)",cr
        =       cr
        =       cr
        NOP
        ]

        ; ------------------------------------------------------------ ;

        LNK     EDIT03
