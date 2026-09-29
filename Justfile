set minimum-version := '1.55.0'
set unstable
set lists

roots := "src" / ["main"] + ".6502"
build := "build"

verify: build
    cd {{ build }} && sha1sum --check --quiet ../orig/hiedit.b800.rom.sha1

build: _prep
    baron -p {{ build }} {{ roots }}

_prep:
    @mkdir -p {{ build }}

check:
    baron --check {{ roots }}

clean:
    rm -rf {{ build }}
