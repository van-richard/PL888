for i in `seq 0 1200`; do
    ((j = i * 2))
    ((k = j + 1))
    fname_i="$( printf "qmmm.inp_%04d" $i )"
    fname_j="$( printf "qmmm.inp_%04d" $j )"
    fname_k="$( printf "qmmm.inp_%04d" $k )"
    mv ${fname_j} ${fname_i}
    rm ${fname_k}
done
