        TTL     Header file HI-Edit (CMOS)      > HDRB800


        ORG     &B800   ; Object destination address

        ; ------------------------------------------------------------ ;

        GBLS    $vers
$vers   SETS    "1.24"  ; No more than 4 characters please

phil    *       0       ; assemble with phil's version of "cursor editing"
mouse   *       0       ; assemble with MOUSE options
lerror  *       1       ; assemble with long error box
dchars  *       1       ; assemble with character definitions
syzygy  *       1       ; 'A SYZYGY prog' displayed, was under EXTRAS
stamp   *       0       ; date stamping

lfver   *       0       ; linefeed version
cF8key  *       1       ; ctrl-f8 toggle (cr/lf)
shortm  *       1       ; shorter messages
curtyp  *       1       ; different cursor types

lfarro  *       1       ; linefeed arrow

extgf   *       0       ; extended FIND/REPLACE texts

reladd  *       0       ; relocation address provided
reladr  *       &B800   ; relocation address

        ; ------------------------------------------------------------ ;

        GBLL    $fix100 ; 'EDIT04'
$fix100 SETL    1=1     ; allow single state printing

        ; ------------------------------------------------------------ ;


        LNK     EDIT00
