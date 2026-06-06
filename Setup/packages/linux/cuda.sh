sudo apt install nvidia-cuda-toolkit
export PATH=/usr/lib/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/lib/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
