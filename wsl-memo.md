# WSLメモ

<br><br>

## バックアップ

- WSLのバックアップ

```bash
wsl.exe --list
wsl.exe --export Ubuntu-20.04 ubuntu-20.04-20220618.tar
```

- WSLのリストア

```bash
wsl.exe --import <NAME> <PATH> <FILE>
```

<br><br>

## .bashrcを書き損じて起動しなくなった場合

これで救われた。

```bash
wsl.exe -e bash --norc
```

<br><br>

## 最新化

```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```
