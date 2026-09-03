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

<br><br>

## /tmpを定期的に綺麗にする

Ubuntuの場合はsystemdで制御する。

デフォルト設定を /etc/tmpfiles.d にコピーする。

```bash
sudo cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d/tmp.conf
```

そのファイルを以下のように編集する。

```text
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

# See tmpfiles.d(5) for details

# Clear tmp directories separately, to make them easier to override
# D /tmp 1777 root root -
q /tmp 1777 root root 3d
#q /var/tmp 1777 root root 30d
```

- **q**: サブボリュームやディレクトリを対象とし、必要に応じて作成・クリーンアップする設定
- **/tmp**: 対象のパス
- **1777 root root**: ディレクトリの権限（パーミッションと所有者）を維持
- 3d: 3日間変更がなかったファイルを削除

即座に実行適用する。

```bash
sudo systemd-tmpfiles --clean
```

この設定でシステムが毎日自動でこの設定をチェックし、古いファイルを掃除する。
