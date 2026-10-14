# Coding Style

The original code was written for Acorn's assembler, which treated anything starting in the first column as a label (so everything other than labels was indented) and which only considered the first six characters of identifiers significant, ignoring case. It also had various other syntax quirks which I don't think were the most typical even at the time.

The *syntax* itself has been updated, labels made consistently spelled and capitalized, and a significant number of labels have been given clearer, longer names - but overall the influence of the original code on the formatting and style is still significant, as the mechanical rewrites attempted to change the overall formatting as little as possible (though this wasn't perfect).

This means that much of the code does not really follow the style described here very closely - this document is aspirational, and mostly serves to remind me of my own general decisions as I continue to clean up and tweak the code.

So, with those caveats in mind:

## General formatting

- The code is indented using spaces, with a width of 4. No tabs. *What* should be indented is a bit subjective and complex, as I'm trying to merge "traditional" assembler style with nested scoping:
  - Instructions are always indented by one additional level compared to labels in the same context.
  - Labels and instructions in the outermost local scope don't get indented any more than if they were in the global scope, because I don't want to have the instruction indentation depend on whether individual routines are defined as scopes or not.
  - When a local scope is nested inside another, the entire inner scope including its label is indented one more level than the parent.
  - Variable definitions get indented by all scopes: global variables are defined in the first column, and local variables are defined at the same level as instructions in that scope.
  - One-line directives like the EQU family and ASSERT are generally indented like instructions.
  - IF/ELIF/ELSE/ENDIF are at the same indentation level as labels and don't cause an additional level of indentation inside, unless nested, in which case they and their contents are both indented an additional level.

- Baron keywords and functions are in CAPS as in the docs (and BBC BASIC).

- Lines should generally be less than 80 characters, but Baron doesn't currently support [wrapping expressions], only list literals, and some things are more readable kept on a single line (e.g. strings that will be printed on a single line at runtime), so lines can be longer where it's reasonably needed.






[wrapping expressions]: https://github.com/waitingforvsync/baron/issues/25
