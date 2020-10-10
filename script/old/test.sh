#!/bin/bash

IP='10.100.100.0/24'

local index=0
for x in ${IP//// }; do
    if [[ $index -eq 1 ]]; then
        local prefix=$x
        while (( $prefix >= 0)); do
            
        done
    fi
    ((index++))
done
