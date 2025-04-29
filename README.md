# Zencode journey

Journey made with [Zencode](https://dev.zenroom.org) using [Zenroom](https://zenroom.org) and [Slangroom](https://dyne.org/slangroom/).

## Quick setup

### with mise-en-place
```
mise install
mise use "aqua:dyne/slangroom-exec"
eval `mise env`
ln -s `which slangroom-exec` bin/slangroom-exec
```

### with shell

```bash
wget https://github.com/dyne/slangroom-exec/releases/latest/download/slangroom-exec-$(uname)-$(uname -m) \
	-O bin/slangroom-exec && chmod +x bin/slangroom-exec
```

### Write Zencode

Put in `src/` your scripts and data files
