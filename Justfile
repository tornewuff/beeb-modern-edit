set minimum-version := '1.55.0'
set unstable
set lists

roots := "src" / ["edit.1.50r", "hiedit.b800"] + ".6502"
build := "build"

verify: build
    cd {{ build }} && sha1sum --check --quiet ../orig/hiedit.b800.rom.sha1
    cd {{ build }} && sha1sum --check --quiet ../orig/edit.1.50r.rom.sha1

build: _prep
    baron -p {{ build }} {{ roots }}

disc target: _prep
    baron -D build_disc=\"{{ target }}\" --opt 3 -o {{ build }}/disc.ssd {{ roots }} src/disc_boot.6502

_prep:
    @mkdir -p {{ build }}

check:
    baron --check {{ roots }}

clean:
    rm -rf {{ build }}
