# beeb-modern-edit

A work in progress to reconstruct what I subjectively think constitutes reasonable source code for the Edit 1.50r ROM included in the BBC Master 128's MOS 3.50 in a modern style, and then perhaps more.

Based on the period source code for a modified earlier version of Edit and the ROM dumped from my own BBC Master.

All credit is due to the various original authors.

## LLM usage

The small number of commits tagged with "CLAUDE:" were produced by Claude Code to automate a few specific repetitive and tedious tasks, with separate followup commits to correct and amend its output manually after thorough review.

## Requirements

- The code is built using [Baron](https://github.com/waitingforvsync/baron), a modern cross-assembler for BBC Micro development.

- The build process is handled by [just](https://github.com/casey/just), a straightforward command runner.

## Building

Currently this builds HiEdit 1.24 using the default configuration from the period source code, and Edit 1.50r using the appropriate configuration.

- `just build` will build both variants.
- `just verify` verifies that both variants match the original.
- `just disc hiedit` will build an SSD image that boots HiEdit.
- `just disc edit` will build an SSD image that boots Edit 1.50r.
