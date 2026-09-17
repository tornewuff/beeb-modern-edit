# beeb-modern-edit

A work in progress to reconstruct what I subjectively think constitutes reasonable source code for the Edit 1.50r ROM included in the BBC Master 128's MOS 3.50 in a modern style, and then perhaps more.

Based on the period source code for a modified earlier version of Edit and the ROM dumped from my own BBC Master.

All credit is due to the various original authors.

## Requirements

- The code is built using [Baron](https://github.com/waitingforvsync/baron), a modern cross-assembler for BBC Micro development.

- The build process is handled by [just](https://github.com/casey/just), a straightforward command runner.

## Building

The code has been adapted to the modern syntax Baron expects, and the inconsistently-spelled/capitalized labels (Acorn's assembler only considered the first six characters of labels to be significant, and compared them case-insensitively) have been made consistent.

You can run `just check` to see that Baron now emits no errors.
