#!/bin/bash

seq -w 0 15 | while read i; do
cd $i
ln -sf ../../${i}/*npy .
cd ../
done

seq -w 17 21 | while read i; do
printf -v j $(($i-1))
cd $j
ln -sf ../../${i}/*npy . 
cd ..
done

seq -w 23 41 | while read i; do
printf -v j $(($i-2))
cd $j
ln -sf ../../${i}/*npy . 
cd ..
done

