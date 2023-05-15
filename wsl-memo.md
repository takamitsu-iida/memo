# WSLメモ


<br><br>

## /tmpをキレイにする

WSLを使っていると/tmpに大量のファイルが残る。

```
sudo apt install tmpreaper
sudo vi /etc/tmpreaper.conf
```

SHOWWARNING=true はコメント化して無効にする。

TMPREAPER_DELAY='256' は'0'に変更する。

TMPREAPER_TIME=7d はコメントアウトして有効にする。

即時で実行するにはこうする。

```
sudo /etc/cron.daily/tmpreaper
```

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

## node.jsのインストール

マイクロソフトのサイトを参考に。

https://docs.microsoft.com/ja-jp/windows/dev-environment/javascript/nodejs-on-wsl


curlがなければインストール

```bash
sudo apt-get install curl
```

nvmの最新バージョンが何かを確認する

https://github.com/nvm-sh/nvm


nvmをインストール

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```


<br><br>

# プロキシ設定

認証プロキシのPACファイルはHTTPで入手しなければならない。
ブラウザにこのような設定をしても機能しないので要注意。

```text
file:///C:/SYNC/HOME/auth.pac
```

Windowsで何が設定されているか、コマンドプロンプトで確認する方法。

```bash
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
```

<br><br>

## Dockerのプロキシ設定

```bash
$ mkdir /etc/systemd/system/docker.service.d
```

/etc/systemd/system/docker.service.d/http-proxy.conf

```text
[Service]
Environment="HTTP_PROXY="
Environment="NO_PROXY=localhost,127.0.0.0/8,docker-registry.somecorporation.com"
```

```bash
$ systemctl stop docker
$ systemctl start docker
$ docker run hello-world
```

サーバ起動時に有効にするなら

```bash
$ systemctl enable docker
```

<br><br>

## Python pipのプロキシ利用

モジュールをインストールする際にその都度プロキシを指定する

例

```bash
pip install unirest --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
pip install requests --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
pip install gevent --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
pip install greenlet --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
pip install demjson --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
pip install pylint --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
pip install requests --proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
```

<br><br>

## /etc/bashrc

シェルの環境変数に設定しておけば、ほとんどのシステムはプロキシを使うようになる

```bash
export http_proxy="http://USERNAME:PASSWORD@somecorporation.com:8080"
export https_proxy="http://USERNAME:PASSWORD@somecorporation.com:8080"
```

<br><br>

## /etc/environment

`/etc/environment` は極力使わないほうがよい。

/etc/environment

```bash
http_proxy="http://USERNAME:PASSWORD@somecorporation.com:8080"
https_proxy="http://USERNAME:PASSWORD@somecorporation.com:8080"
ftp_proxy="http://USERNAME:PASSWORD@somecorporation.com:8080"
no_proxy="localhost,127.0.0.1,localaddress,.localdomain"

HTTP_PROXY="http://USERNAME:PASSWORD@somecorporation.com:8080"
HTTPS_PROXY="http://USERNAME:PASSWORD@somecorporation.com:8080"
FTP_PROXY="http://USERNAME:PASSWORD@somecorporation.com:8080"
NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain"
```

<br><br>

## yumのプロキシ設定

RedHat、CentOS、Fedoraはyumを使う。

/etc/yum.conf

```text
proxy=http://USERNAME:PASSWORD@somecorporation.com:8080
```

プロキシを設定したら yum -y update でOSを最新化する

<br><br>

## dnfのプロキシ設定

Fedora22からはyumではなく、dnfコマンドに変わっている。

/etc/dnf/dnf.conf

```text
proxy = http://proxy.somecorporation.com:8080
proxy_username = USERNAME
proxy_password = PASSWORD
```

<br><br>

## Ubuntuのapt-getプロキシ設定

/etc/apt/apt.conf

```text
Acquire::ftp::proxy "http://USERNAME:PASSWORD@somecorporation.com:8080";
Acquire::http::proxy "http://USERNAME:PASSWORD@somecorporation.com:8080";
Acquire::https::proxy "http://USERNAME:PASSWORD@somecorporation.com:8080";
```

<br><br>


## curlのプロキシ設定

~/.curlrc


```text
proxy = "http://proxy.somecorporation.com:8080"
proxy-user = "USERNAME:PASSWORD"
noproxy = "localhost,127.0.0.1,localaddress,.localdomain"
```

<br><br>

## wgetのプロキシ設定

~/.wgetrc


```text
http_proxy=http://somecorporation.com:8080
https_proxy=http://somecorporation.com:8080
proxy_user=USERNAME
proxy_password=PASSWORD
no_proxy="localhost,127.0.0.1,localaddress,.localdomain"
```

<br><br>

## gitのプロキシ設定

```bash
yum -y install git

git config --global http.proxy http://USERNAME:PASSWORD@somecorporation.com:8080
git config --global https.proxy http://USERNAME:PASSWORD@somecorporation.com:8080
git config --global url."https://".insteadOf git://
```

上記コマンドを実行すると、以下が作られる。

~/.gitconfig

```text
[http]
        proxy = http://USERNAME:PASSWORD@somecorporation.com:8080
[https]
        proxy = http://USERNAME:PASSWORD@somecorporation.com:8080
[url "https://"]
        insteadOf = git://
```