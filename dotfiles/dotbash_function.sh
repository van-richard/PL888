#!/bin/bash

DIRNAME="$(realpath .)/bash_function"

if [ -d "${DIRNAME}" ]; then
    printf "#!/bin/bash\n\n" > ~/.bash_function
    ls ${DIRNAME}/* | while read FNAME; do
        echo "source ${FNAME}" >> ~/.bash_function
    done
    printf "\n" >> ~/.bash_function
fi


