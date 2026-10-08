# pasfetch

A small system information tool written in Free Pascal for Linux.

It reads system information directly from files in `/proc`, `/sys`, and `/etc`.

## Build

```bash
fpc pasfetch.pas
```

## Run

```bash
./pasfetch
```

You can also force a distro logo:

```bash
./pasfetch --os=[fedora, debian, ubuntu, arch]
```

## License

GPL-3.0-only
