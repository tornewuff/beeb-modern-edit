# beeb-modern-edit

A work in progress to reconstruct what I subjectively think constitutes reasonable source code for the Edit 1.50r ROM included in the BBC Master 128's MOS 3.50 in a modern style, and then perhaps more.

Based on the period source code for a modified earlier version of Edit and the ROM dumped from my own BBC Master.

All credit is due to the various original authors.

## Requirements

- The code is built using [Baron](https://github.com/waitingforvsync/baron), a modern cross-assembler for BBC Micro development.

- The build process is handled by [just](https://github.com/casey/just), a straightforward command runner.

## Building

Currently this builds HiEdit 1.24 using the default configuration from the period source code, and a work-in-progress version of Edit 1.50r that is mostly just the same as 1.24.

- `just build` will build both variants.
- `just verify` verifies that HiEdit 1.24 matches the original (but does not check 1.50r because it definitely does not match yet).
- `just disc hiedit` will build an SSD image that boots HiEdit.
- `just disc edit` will build an SSD image that boots Edit 1.50r.
