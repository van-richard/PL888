#!/bin/bash

alias q="squeue --format='%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R"

function me () {
    q --user $USER
}

