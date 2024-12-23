# PL888s (n.) /plāt-s/ 

- my templates for setup, configuration, and stuff
- Use with caution: May (or may not) improve your workflow

## Setup

1. clone the repo to local/remote 
    - create a github directory in `$HOME`
    - `git clone` to `$HOME/github`

```bash
mkdir -p $HOME/github && git clone https://github.com/van-richard/PL888.git $HOME/github
```

2. add to the shell environment
    - `source` the `PL888/env.sh`
    - export tp `$PATH` to persist changes 
    - log out and then log in for changes or `source ~/.bashrc` file

```bash
echo 'export \$PATH=\$HOME/github/PL888/env.sh" >> ~/.bashrc
source ~/.bashrc
```



