# Any stdout from ~/.bashrc will break `scp` & `rsync`
# Avoid by checking if shell is interactive or non-interactive 
                                                                                                                                                                

if [ -z "${PS1:-}" ]; then
    return # PS1 not set, this is non-interactive shell
fi
