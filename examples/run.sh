#!/bin/sh

for example in `ls ./bin/ | grep -v .dwarf`; do
    echo " === Run $example ==="
    if ./bin/$example; then
        echo "  :: DONE ::"
    else
        echo "  !! FAILED !!"
    fi
done
