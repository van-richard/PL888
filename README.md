# PL888s (n.) /plāt-s/ 

- templates for all things setup, configuration, and whatnot
- May (or may not) improve your workflow

```{warning}
Use with caution
```

## Getting Started

1. clone the repo to local/remote, generally I prefer to:
    - create a github directory in `$HOME`
    - `git clone` to `$HOME/github`

```bash
mkdir -p $HOME/github && git clone https://github.com/van-richard/PL888.git $HOME/github
```

2. add to the shell environment, 2 approaches:
    a) "Don't care, just need things to work"
        - `source` the script `PL888/env.sh`
        - export tp `$PATH` to persist changes 
        - log out and then log in for changes or `source ~/.bashrc` file

```bash
echo 'export \$PATH=\$HOME/github/PL888/env.sh" >> ~/.bashrc
source ~/.bashrc
```

    b) "I like to break things, and it can always be optimized"
        - take a look at `PL888/Setup`
        - modify to your needs, then execute the script

```bash
bash Setup.sh
```

## Example Configuration files

- some sample config files I use for `bash`, `VMD`, `ChimeraX`, etc. can be found in, `PL888/Profiles`

##



