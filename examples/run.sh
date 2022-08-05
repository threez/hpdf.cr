#!/bin/sh

for example in ./bin/*; do
    echo " === Run $example ==="
    if $example; then
        echo "  :: DONE ::"
    else
        echo "  !! FAILED !!"
    fi
done
