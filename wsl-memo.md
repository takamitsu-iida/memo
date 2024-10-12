# WSLメモ

<br><br>

## Podman

WindowsでのLinuxコンテナは背後でWSL version 2が必要。
podmanのインストールの過程でWSLをインストールすることも可能だが、
事前にWSLが動作する環境を作っておいたほうがよい。

https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md


podmanはgithubのリリースページからインストール用のexeファイルをダウンロードして実行するだけでよい。

https://github.com/containers/podman/releases


コンテナを動作させる母艦のリストを表示。

```bash
podman machine list
```

実行例。podmanをインストールした直後は何もない。

```bash
C:\Users\iida>podman machine list
NAME        VM TYPE     CREATED     LAST UP     CPUS        MEMORY      DISK SIZE
```

コンテナを走らせるための基盤となる仮想マシンをインストールする。

--user-mode-networkingを指定したほうがVPNとの相性は良さそう。

```bash
podman machine init --user-mode-networking
```

実行例

```bash
C:\Users\iida>podman machine init --user-mode-networking
Extracting compressed file: podman-machine-default_fedora-podman-amd64-v39.0.4.tar: done
Importing operating system into WSL (this may take a few minutes on a new WSL install)...
インポート中です。この処理には数分かかることがあります。
この操作を正しく終了しました。
Configuring system...
Generating public/private ed25519 key pair.
Your identification has been saved in podman-machine-default
Your public key has been saved in podman-machine-default.pub
The key fingerprint is:
SHA256:kg8KaE+MRRb2WCXEOI3CFeCW9pD3i7k+jGPFBLSUwO4 root@FCCLS0073460
The key's randomart image is:
+--[ED25519 256]--+
|*++BO+..         |
|o*B++o.          |
|.Oo+..           |
|ooB..  .         |
|oo++ .+ S        |
|.Eo+o..+         |
|  ++..  .        |
| + o.            |
|. oo.            |
+----[SHA256]-----+
Machine init complete
To start your machine run:

        podman machine start
```

名前を指定しない場合は `podman-machine-default` という名前で仮想マシンが作られる。

```bash
C:\Users\iida>podman machine list
NAME                     VM TYPE     CREATED         LAST UP     CPUS        MEMORY      DISK SIZE
podman-machine-default*  wsl         53 seconds ago  Never       0           0B          620MiB
```

起動。特に指定しなければrootレスで起動する。

```bash
podman machine start
```

root特権を使いたい場合は、その旨指定する。

```bash
podman machine start set --rootful
```

もしくはデフォルトでrootフルになるように設定を変えても良い。

```bash
podman machine stop
podman machine set --rootful
podman machine start
```

SSHでログインする。

```bash
podman machine ssh
```

最新化する。

```bash
sudo dnf upgrade -y
```

Windows Terminalを使うと母艦に接続できる。

管理を簡単にするためにpodman desktopもあわせてインストールしておく。

https://podman-desktop.io/


### Visual Studio Codeの設定

拡張機能 Docker をインストールする。

F1キーを押すか、Ctrl-Shift-Pを押す。

Dev Containers: Settings を入力する。

`Dev › Containers: Docker Path` をdockerからpodmanに書き換える。

<br><br>

## ビープ音を止める

コマンドを打ち間違えたときのビープ音がうるさいので抑止する。

```bash
echo 'set bell-style none' > ~/.inputrc
```

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