#!/bin/bash

find "${_vtemplates}/aliases/" -type f | while read a; do
    source $a
done 2>/dev/null

