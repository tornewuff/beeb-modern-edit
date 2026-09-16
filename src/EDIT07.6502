        ; Find replace section -> EDIT07
        ; Use recursive descent to check syntax ; 
        ; F_str ::= find_part CR
        ; find_part ::= { ['*'] (simple_item | set_item) }
        ; set_item  ::= ['~'] ( '[' simple_item { simple_item } ']' )
        ; simple_item ::= ['~'] ( character_specifier | subrange_specifier |
        ;                         wildcard_specifier )
        ; character_specifier ::= ['|!'] (non_meta | '\' non_eoln
        ;                                               | '$' | '|' non_eoln)
        ; subrange_specifier ::= character_specifier '-' character_specifier
        ; wildcard_specifier ::= '.' | '@' | '#'
        ; R_str ::= find_part '/' repl_part CR
        ; repl_part ::= { ( field_item | character_specifier ) }
        ; field_item ::= '&' | '%' digit
        ; non_meta ::= NOT < ~ * [ ] , \ $ | - . @ # & % / eoln >
        ; Subranges should translate into subrange_sym <ch> <ch>
        ; Set constructs should translate into :
        ; set_sym <nextX> ... <next item>
        ;                     ^
        ;                     nextX
        ; Matching of subranges & sets should be internal to compmobj. nextX is
        ; used to step on to the next find item after successfully matching one
        ; of the set alternatives (set match fails when hit tes_sym).

FRSTRINIT
        ; Exit  -  Y = 0
        CLR     OUTINDEX
        CLR     REPLFLAG
        CLR     FIELDINDEX
        CLR     MMX
        CLR     OFFSET
        CLR     SENSFLAG
MININIT
        CLR     INPINDEX
        BRA     NEXTCH
GENNEXTCH
        JSR     GENBYTE
NEXTCH
        ; A,atemp = linbuf,inpindex +  + . Exit - Z = (A = CR)
        LDY     INPINDEX
        LDAAY   LINBUF
        STA     ATEMP
        INC     INPINDEX
        CMPIM   CR
        RTS
        ; Translate & store FR string into stracc.
        ; Exit  - Find part translated into stracc, replindex holds start of
        ;        replace string (when translated) in stracc. 
        ;      - fieldindex = No. of fields (max 10) in find string.
        ;      - For each field n (n> 0) -
        ;        'mulf' (* ..)  -  fieldmmxtab,n = (mmx :OR: &80)
        ;        'conf' (?)     -  fieldmmxtab,n = mmx of previous mulf
        ;                          fieldofftab,n = offset from above
        ;      - replindex = stracc index of replace part (when translated)
        ;      - replflag = 0  No replace part supplied
        ;                   1  Replace part supplied
FINDTRANS
        JSR     FRSTRINIT
FINDPART
        CLR     MULFFLAG ; Don't yet know whether next object is either a
        CLR     METAFLAG ; star or wildcard field.
        CLR     BUTTFLAG ; or ^
        LDA     ATEMP
        CMPIM   CR
        BEQ     FIPAEXIT
        CMPIM   "/"
        BEQ     FIPAEND
        CMPIM   "^"
        BNE     FIPANHA
        INC     BUTTFLAG
        BRA     FIPAMUL
FIPANHA
        CMPIM   "*"
        BNE     FIPANMUL
FIPAMUL
        INC     MULFFLAG
        LDXIM   MULTSYM
        JSR     GENNEXTCH
FIPANMUL
        CMPIM   "~"
        BNE     FIPANNOT
        LDXIM   NOTSYM
        JSR     GENNEXTCH
FIPANNOT
        CMPIM   "["
        BNE     FIPASIMP
        INC     SENSFLAG
        LDXIM   SETSYM
        JSR     GENBYTE
        JSR     GENBYTE ; Leave room for nextX, and remember position.
        STY     NEXTX
        JSR     NEXTCH
FIPASELT
        JSR     SIMPLEITEM
        LDA     ATEMP
        CMPIM   "]"
        BNE     FIPASELT
        DEC     SENSFLAG
        LDA     OUTINDEX ; End of set construct. Store nextX
        LDY     NEXTX
        STAAY   STRACC
        JSR     NEXTCH
        BRA     FIFIFEEL
FIPAEND
        INC     REPLFLAG
FIPAEXIT
        JSR     TERMGEN
        JSR     NEXTCH
        LDA     OUTINDEX
        STA     REPLINDEX
        LDA     REPLFLAG
        BNE     REPLPART
        RTS
FIPASIMP
        JSR     SIMPLEITEM
FIFIFEEL
        ; If last object was a field of some sort, then store the
        ; relevant info, and update indeces as required.
        LDA     BUTTFLAG
        BEQ     FIFICO
        LDXIM   BUTTSYM
        JSR     GENBYTE
FIFICO
        LDA     METAFLAG
        BEQ     FIFIOFFI ; No meta-chars => not a field
        LDX     FIELDINDEX
        CPXIM   10
        BCS     FINDPART ; That's enough fields.
        INC     FIELDINDEX
        LDA     OFFSET
        STAAX   FIELDOFFTAB
        LDA     MULFFLAG
        BNE     FIFIMULF
        LDA     MMX
        STAAX   FIELDMMXTAB
FIFIOFFI
        INC     OFFSET
FINDPCH
        JMP     FINDPART
FIFIMULF
        INC     MMX
        LDA     MMX
        CMPIM   5
        BCS     FRSTERR
        ORAIM   &80
        STAAX   FIELDMMXTAB
        CLR     OFFSET
        BRA     FINDPCH
FRSTERR
        BRK
        = 1,"Too many find multiples",0
REPANXCH
        JSR     NEXTCH
REPAGENB
        JSR     GENBYTE
REPLPART
        LDAIM   &FF
        STA     SENSFLAG
        LDA     ATEMP ; Translate replace part of FR string.
        CMPIM   CR
        BEQ     TERMGEN
        LDXIM   FOUNDSYM
        CMPIM   "&"
        BEQ     REPANXCH
        CMPIM   "\"
        BNE     REPANS
        JSR     NEXTCH
        TAX
        BRA     REPANXCH
REPANS
        LDXIM   FIELDSYM
        CMPIM   "%"
        BNE     RPNFLD
        JSR     GENBYTE
        JSR     NEXTCH
        SEC
        SBCIM   "0"
        BCC     FIELDERR
        CMP     FIELDINDEX
        BCS     FIELDERR
        TAX
        BPL     REPANXCH
RPNFLD
        JSR     CHARACTERSPECIFIER
        STX     SIMPCHAR
        TXA
        BPL     REPAGENBYTE
        LDXIM   ESCSYM
        JSR     GENBYTE
        LDX     SIMPCHAR
        BRA     REPAGENB
FIELDERR
        BRK
        = 1,"Bad replace field number",0
TERMGEN
        LDXIM   TERMSYM ; Generate termsym.
GENBYTE
        ; stracc,outindex +  +  = X
        ; Exit - metaflag set (incremented) if meta-character (field) generated.
        LDY     OUTINDEX
        LDA     SENSFLAG
        BNE     GENBSNS
        CPXIM   "A"
        BCC     GENBSNS
        CPXIM   "z" + 1
        BCS     GENBSNS
        CPXIM   "Z" + 1
        BCC     GENBNSN
        CPXIM   "a"
        BCC     GENBSNS
GENBNSN
        TXA
        ORAIM   &20
        TAX
        LDAIM   NSENSYM
        STAAY   STRACC
        INY
        INC     OUTINDEX
        BEQ     GENBERR
GENBSNS
        TXA
        STAAY   STRACC
        BPL     GENBNMET
        INC     METAFLAG
GENBNMET
        INC     OUTINDEX
        BEQ     GENBERR
        RTS
GENBERR
        BRK
        = 1,"Syntax incorrect",0
SIMPLEITEM
        LDA     ATEMP
        CMPIM   "~"
        BNE     SIITNNOT
        LDXIM   NOTSYM
        JSR     GENBYTE
        JSR     NEXTCH
        BNE     SIITNNOT
        BRK
        = 1,"Error with ~",0
SIITNNOT
        CMPIM   "\"
        BNE     SIITNS
        INC     SENSFLAG
        JSR     NEXTCH
        BNE     SIITNM
        BRK
        = 1,"Error with \",0
SIITNM
        TAX
        JSR     NEXTCH
        JSR     GENBYTE
        DEC     SENSFLAG
        RTS
SIITNS
        LDXIM   WILDSYM
        CMPIM   "."
        BEQ     SIITWILD
        LDXIM   ALPHASYM
        CMPIM   "@"
        BEQ     SIITWILD
        LDXIM   DIGSYM
        CMPIM   "#"
        BNE     SIITNWIL
SIITWILD
        JSR     NEXTCH ; Preserves X
        JMP     GENBYTE
SIITNWIL
        JSR     CHARACTERSPECIFIER
        STX     SIMPCHAR
        LDA     ATEMP
        CMPIM   "-"
        BNE     SIITCGEN
        INC     SENSFLAG
        LDXIM   SUBRSYM
        JSR     GENBYTE
        JSR     NEXTCH
        LDX     SIMPCHAR
        JSR     GENBYTE
        JSR     CHARACTERSPECIFIER
        JSR     GENBYTE
        DEC     SENSFLAG
        RTS
SIITCGEN
        ; Output character as escsym ch if >= &80
        TXA
        BPL     GENBYJ
        LDXIM   ESCSYM
        JSR     GENBYTE
        LDX     SIMPCHAR
GENBYJ
        JMP     GENBYTE
CHARACTERSPECIFIER
        ; Exit  -  X = Character
        CLR     COUNT ; Add 128 count
        LDA     ATEMP
        BMI     CHSPBY
        CMPIM   "|"
        BNE     CHRSCO
        JSR     NEXTCH
        BEQ     CHRSER
        CMPIM   "!"
        BNE     CHRSSO
        INC     COUNT
        JSR     NEXTCH
CHRSCO
        CMPIM   "$"
        BEQ     CHSPCR
        CMPIM   "|"
        BNE     CHSPBY
        JSR     NEXTCH
        BEQ     CHRSER
CHRSSO
        CMPIM   "?"
        BNE     NOTQUE
        LDAIM   &7F
        BRA     CHSPBY
NOTQUE
        BCC     CHSPBY
        ANDIM   &DF
        SBCIM   "@"
        BRA     CHSPBY
CHSPCR
        [ cf8key=1
        LDAZ    clterm
        |
        LDAIM   termin
        ]
CHSPBY
        PHA
        JSR     NEXTCH
        PLA
        LDY     COUNT
        BEQ     CHRSEX
        ORAIM   &80
CHRSEX
        TAX
        RTS
CHRSER
        BRK
        = 1,"Error with |",0
        ; Search subroutine , called by find & replace routines.
        ; 'Multiple occurence' matching is achieved by a general backtracking
        ; algorithm, using a stack of records, one for each '*-match', holding
        ; the following data -
        ;  + - + 
        ; |0| linbufX of multsym concerned
        ;  + - + 
        ; |1| lo }
        ;  + - +     } Text address of match start
        ; |2| hi }
        ;  + - + 
        ; |3| lo }
        ;  + - +     } Number of object accepted by match
        ; |4| hi }
        ;  + - + 
        ; The first record is reserved (by chknrep) for match-start pointer.
        ; Entry - MS   --> Search start position
        ;        EOSP    --> Top bit set charcater at required end of search.
        ;        Search-string in stracc, terminated by termch.
        ; Exit  - CC  Occurence of findstring found.
        ;            MS  --> match
        ;            ME  --> matchend  +  1
        ;        CS  Search failed.
SEARCH
        LDYIM   0
        CLR     SSTCKX
        ; Start of attempted match. See if have reached TEXP - either old
        ; cursor position, or end of search block.
        LDA     MS
        STA     ME
        CMP     TEXP
        LDA     MS + 1
        STA     ME + 1
        SBC     TEXP + 1
        BCC     SRCHCT
        LDA     TEXPFLAG
        BNE     SRCHFL
        JSR     MOVETOFOUNDPOSITION
        LDA     GS
        STA     STRING
        LDA     GS + 1
        STA     STRING + 1
        INC     TEXPFLAG
        LDA     ENDP
        STA     TEXP
        LDA     ENDP + 1
        STA     TEXP + 1
        LDYIM   0
        BRA     SRCHCT
SRCHFL
        SEC
        RTS
SRCHL1
        INC     ME
        BNE     SRCHCT
        INC     ME + 1
SRCHCT
        ; Expects Y (= linbufX), ME --> next char valid.
        JSR     ESCTST
        LDAAY   STRACC
        CMPIM   TERMSYM
        BEQ     SRCHFD
        CMPIM   MULTSYM
        BEQ     SRCHMI
        JSR     COMPMOBJ
        BEQ     SRCHL1
SRCHIN
        ; Increment current multiple match, or advance MS if there
        ; isn't one. Search fails when MS reaches EOT.
        LDX     SSTCKX
        BNE     SRCHFM
        INC     MS
        BNE     SEARCH
        INC     MS + 1
        BRA     SEARCH
SRCHFD
        LDA     MS ; Match found. Set sstk[0] = MS, (ME-MS).
        STA     SSTTLOSTK
        LDA     MS + 1
        STA     SSTTHISTK
        SEC
        LDA     ME
        SBC     MS
        STA     SCNTLOSTK
        LDA     ME + 1
        SBC     MS + 1
        STA     SCNTHISTK
        CLC
        RTS
SRCHFM
        ; Let most recent multiple match accept another occurence of
        ; find-object, if one exists.
        STY     BUTTFLAG
        CLC
        LDAAX   SSTTLOSTK
        ADCAX   SCNTLOSTK
        STA     ME
        LDAAX   SSTTHISTK
        ADCAX   SCNTHISTK
        STA     ME + 1
        LDAAX   SINDEXSTK
        TAY
        JSR     COMPMOBJ
        BNE     SRCHBK
        LDX     SSTCKX
        INCAX   SCNTLOSTK
        BNE     SRCHL1
        INCAX   SCNTHISTK
        BRA     SRCHL1
SRCHBK
        ; Can't increment this multiple-match, so backtrack to the previous one.
        ; unless its hit a ^ with count>0 in which case it continues
        LDX     BUTTFLAG
        LDAAX   STRACC-1
        CMPIM   BUTTSYM
        BNE     SRCHBC
        INY
        LDX     SSTCKX
        LDAAX   SCNTLOSTK
        ORAAX   SCNTHISTK
        BNE     SRCHCT
SRCHBC
        DEC     SSTCKX
        BRA     SRCHIN
SRCHMI
        ; 'Push' a new record onto backtrack-stack. Initially accept
        ; 0 characters into multiple match.
        INC     SSTCKX
        LDX     SSTCKX
        INY
        TYA
        STAAX   SINDEXSTK
        LDA     ME
        STAAX   SSTTLOSTK
        LDA     ME + 1
        STAAX   SSTTHISTK
        CLRAX   SCNTLOSTK
        CLRAX   SCNTHISTK
        JSR     COMPMOBJ ; Cheap way to advance Y to next find-object.
        JMP     SRCHCT
COMOFS
        PLP
COMOFL
        ; Have hit end of search text, so fail match.
        LDAIM   1
        RTS
COMPMOBJ
        ; Compares stracc,Y & (ME).
        ; Exit  - Y indexes next ssobj
        ;        EQ  Objects match.
        ;        NE  Objects don't match.
        ; Match fails if have hit end of seach text.
        LDA     ME
        CMP     ENDP
        BNE     COMOCO
        LDA     ME + 1
        CMP     ENDP + 1
        BEQ     COMOFL
COMOCO
        ; Check for & store absence/presence of notsym, then branch depending
        ; whether trying to match constant, wildcard, subrange or set item.
        LDAAY   STRACC
        CMPIM   NOTSYM
        PHP
        BNE     COMONN
        INY
COMONN
        INY
        LDAAY   STRACC-1
        BMI     COMOME
        CMPI    ME
        BNE     CMOPRN
        BRA     CMOPRY
COMOME
        CMPIM   WILDSYM
        BEQ     CMOPRY
        CMPIM   NSENSYM
        BEQ     CMONSEN
        CMPIM   ALPHASYM
        BEQ     COMOAL
        CMPIM   BUTTSYM
        BEQ     COMOFS
        CMPIM   DIGSYM
        BEQ     CMODG1
        CMPIM   SUBRSYM
        BEQ     CMOSUB
        CMPIM   SETSYM
        BEQ     CMOSET
        ; 
        ; Must be escsym ch
        ; 
        INY
        LDAAY   STRACC-1
        CMPI    ME
        BNE     CMOPRN
        BEQ     CMOPRY
CMOSUB
        INY
        INY
        LDAI    ME
        CMPAY   STRACC-2
        BCC     CMOPRN
        CMPAY   STRACC-1
        BCC     CMOPRY
        BNE     CMOPRN
        BRA     CMOPRY
CMONSEN
        INY
        LDAI    ME
        ORAIM   &20
        CMPAY   STRACC-1
        BNE     CMOPRN
        BRA     CMOPRY
COMOAL
        LDAI    ME
        CMPIM   "_"
        BEQ     CMOPRY
        CMPIM   "A"
        BCC     CMODG2
        CMPIM   "z" + 1
        BCS     CMOPRN
        CMPIM   "Z" + 1
        BCC     CMOPRY
        CMPIM   "a"
        BCC     CMOPRN
        BRA     CMOPRY
CMODG1
        LDAI    ME
CMODG2
        CMPIM   "0"
        BCC     CMOPRN
        CMPIM   "9" + 1
        BCS     CMOPRN
        BRA     CMOPRY
CMOSET
        LDAAY   STRACC
        STA     NEXTX
        INY
CMOSEL
        JSR     COMPMOBJ
        BEQ     CMOSEY
        CPY     NEXTX
        BNE     CMOSEL
CMOPRN
        PLP
        RTS
CMOSEY
        LDY     NEXTX
CMOPRY
        PLA
        ANDIM   2
        RTS
CHKNREP
        ; Check for size, then replace found string with replace string.
        ; Entry - Match just found; s*****stk[0] set up for %0 ('&')
        ;        replindex = start index of replace part in stracc
        ; Exit  - Found string replaced.
        JSR     MOVETOFOUNDPOSITION
        LDAIM   1
        STA     MODFLG
        LDA     ME
        STA     GE
        LDA     ME + 1
        STA     GE + 1
        LDA     REPLINDEX
        STA     LNBUFX
CHNRLP
        LDA     GS
        CMP     MS
        LDA     GS + 1
        SBC     MS + 1
        BCS     CHNRRERR
        LDY     LNBUFX
        INC     LNBUFX
        LDAAY   STRACC
        BPL     CHNRSI
        CMPIM   TERMSYM
        BEQ     CHNREX
        CMPIM   FIELDSYM
        BEQ     CHNRFI
        CMPIM   FOUNDSYM
        BEQ     CHNRFO
        ; Must be escsym ch
        INC     LNBUFX
        LDAAY   STRACC + 1
        BRA     CHNRSI
CHNRFO
        ; '&' has been frigged to look like MM 0
        LDYIM   0
        BRA     CHNRAM
CHNRFI
        INC     LNBUFX
        LDAAY   STRACC + 1
        TAX
        LDAAX   FIELDMMXTAB
        BMI     CHNRMF
        TAY
        BEQ     CHNRMS
        CLC       
        LDAAY   SSTTLOSTK
        ADCAY   SCNTLOSTK
        STA     TEMP
        LDAAY   SSTTHISTK
        ADCAY   SCNTHISTK
        BNE     CHNRTM
CHNRMS
        LDA     MS
        STA     TEMP
        LDA     MS + 1
CHNRTM
        STA     TEMP + 1
        LDYAX   FIELDOFFTAB
        LDAIY   TEMP
CHNRSI
        STAI    GS
        INC     GS
        BNE     CHNRLP
        INC     GS + 1
        BRA     CHNRLP
CHNRRERR
        BRK
        = 2,"No room",0
CHNRMF
        ANDIM   &7F
        TAY
CHNRAM
        LDAAY   SSTTLOSTK
        STA     ARGP
        LDAAY   SSTTHISTK
        STA     ARGP + 1
        LDA     GS
        STA     VARP
        LDA     GS + 1
        STA     VARP + 1
        CLC
        LDAAY   SCNTLOSTK
        TAX
        ADC     GS
        STA     GS
        LDAAY   SCNTHISTK
        TAY
        ADC     GS + 1
        STA     GS + 1
        JSR     COPYBK
        JMP     CHNRLP
CHNREX
        RTS

        LNK     EDIT08
