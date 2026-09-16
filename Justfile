set minimum-version := '1.55.0'
set unstable
set lists

roots := "src" / ["main"] + ".6502"

check:
    baron --check {{ roots }}
