
# .bash_profile

.bash_profileはログイン時に実行され主に環境変数を設定する。

.bashrcはbashを起動するたびに実行される。
主にシェル変数(exportしないもの)やエイリアスを設定する。

.bashrcは作っても自動では読み込まれないので、先に.bash_profileを作る。

2019年1月時点はこれ。

```bash
# bash_completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# load .bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
```

# .bashrc

2020年1月時点はこれ。

```bash
# alias
alias ls='ls -F'

# $HOME/binを最後に通す
export PATH=$PATH:$HOME/bin

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
export PYTHON_CONFIGURE_OPTS="--enable-framework"
eval "$(pyenv init -)"

# pyenv versionsでインストールされているバージョンを確認して指定する
# pyenv global 2.7.14
pyenv global 3.6.4

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:./node_modules/.bin:$PATH

# ansible
export ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q bastion@10.35.158.20"'
```

# .zshrc

2020年3月時点はこれ。.zprofileの中身は空っぽ。

```bash
# alias
alias ls='ls -F'

# zsh-completion
# brew install zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# You may also need to force rebuild `zcompdump`:
# rm -f ~/.zcompdump; compinit


# $HOME/binを最後に通す
export PATH=$PATH:$HOME/bin

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# ansible
# export ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q bastion@10.35.158.20"'

# proxy
# . ~/.proxyrc
# --PROXY--

# # pyenv
# export PYENV_ROOT=$HOME/.pyenv
# export PATH=$PYENV_ROOT/bin:$PATH
# export PYTHON_CONFIGURE_OPTS="--enable-framework"
# eval "$(pyenv init -)"

# pyenv versionsでインストールされているバージョンを確認して指定する
# pyenv global system
# pyenv global 3.6.4

# --PYENV--
# BEGIN ANSIBLE MANAGED BLOCK
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
export PYTHON_CONFIGURE_OPTS="--enable-framework"
eval "$(pyenv init -)"
# END ANSIBLE MANAGED BLOCK

# --PYENV_VERSION--
pyenv global 3.6.5
```

# macOS Mojave 10.14にしてからの作業

ヘッダファイルをインストールする。
Xcode10からは標準の場所にしかヘッダファイルを置いてくれないので、手動でヘッダファイルをインストールする。
これをやらないとhomebrewやpyenvなど、多方面に影響がでる。

```bash
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
```

古い homebrew をアンインストール。
この作業をするとかつてインストールしたものは全て使えなくなる。

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

homebrew を改めてインストール

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

必須ツールを入れ直す。

```bash
brew install openssl
brew install nodebrew
brew install cdrtools
brew install bash-completion
brew install zsh-completions
brew install tree
brew install telnet
brew install tnftp
brew install autoconf
brew install automake
brew install libtool
brew install jq
brew install git
brew install mas  # mas-cli
brew install nodebrew
# sshpassは直接導入できないのでインストールスクリプトを指定する
brew install https://git.io/sshpass.rb
brew install readline
brew install wget
```

awsを使うならawscliを入れる。

```
brew install awscli
```

diagramsを入れるならgraphvizを入れる。

```bash
brew install graphviz
```

追加のフォントを入れる。matplotlibで日本語表示をするため。

```bash
brew tap caskroom/fonts
brew cask install font-ricty-diminished
```

postmanをインストールする。

```bash
brew cask install postman
```

ngrokをインストールする。

```bash
brew cask install ngrok
```

GoogleかGithubのアカウントでログインして、
ダッシュボード<https://dashboard.ngrok.com/get-started>で認証トークンを確認する。

トークンを保存する。

```bash
iida-macbook-pro:~ iida$ ngrok authtoken __token__
Authtoken saved to configuration file: /Users/iida/.ngrok2/ngrok.yml
iida-macbook-pro:~ iida$
```

npmで必要なものをインストールする。

```bash
npm i -g http-server
npm i -g @vue/cli
npm i -g eslint
npm i -g eslint-config-google
```

```bash
npm i -g webpack
```

## pyenv

```bash
pyenv install 2.7.14
pyenv install 3.6.4
pyenv install anaconda3-5.3.1
```

anacondaはインストールできないことがある。

これが設定されているとうまくいかないので、もし設定されてたらunsetしてpyenv installする。

```bash
PYTHON_CONFIGURE_OPTS=--enable-framework
```

それでもだめなら、これ。

```bash
CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include" \
LDFLAGS="-L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib" \
PYTHON_CONFIGURE_OPTS=--enable-unicode=ucs2 \
pyenv install -v anaconda3-5.3.1
```

## pip

```bash
pip install ansible
pip install ansible-lint
pip install graphviz
pip install jinja2
pip install jsonpickle
pip install openpyxl
pip install xlrd
pip install pylint
pip install pyyaml
pip install prettytable
pip install requests
pip install tabulate
pip install textfsm
pip install tinydb
pip install tqdm
pip install yapf
pip install ntfy
pip install pysnooper
pip install nornir
pip install diagrams
pip install xmltodict
pip install pyyang
```

web関係。

```bash
pip install gevent
pip install gunicorn
pip install flask
pip install bottle
```

住所と緯度経度を処理するモジュール。

```bash
pip install geopy
pip install timezonefinder
```



## dockerのインストール

```bash
brew cask install docker
```

GUIでアプリケーションを起動して、インストールを完了する。

```bash
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose
```

インストールされるイメージはここ。

~/Library/Containers/com.docker.docker/

## redisのインストール

何かと使うのでdockerを立ち上げるよりmac本体に入れておいた方が良さそう。

```bash
brew install redis
```

`/usr/local/bin/redis-server`で起動。

```bash
iida-macbook-pro:memo iida$ redis-server
69027:C 02 Jan 2020 23:59:20.027 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
69027:C 02 Jan 2020 23:59:20.027 # Redis version=5.0.7, bits=64, commit=00000000, modified=0, pid=69027, just started
69027:C 02 Jan 2020 23:59:20.027 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 5.0.7 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 69027
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

69027:M 02 Jan 2020 23:59:20.032 # Server initialized
69027:M 02 Jan 2020 23:59:20.032 * Ready to accept connections
```

サーバはフォアグラウンドで走るので`Ctrl-C`で止める。

Python用のモジュールは`pip install redis`でインストールする。

## ansibleのインストール

macにansibleを入れる

pipを最新化

```bash
pip install --proxy=http://user:pass@proxy.server:8080 --upgrade pip
```

普通にインストールする場合

```bash
pip install  --proxy=http://user:pass@proxy.server:8080 ansible
```

最新にアップデートする場合

```bash
pip install -U  --proxy=http://user:pass@proxy.server:8080 ansible
```

バージョンを指定する場合

```bash
pip install  --proxy=http://user:pass@proxy.server:8080 ansible==2.5
```

開発版をインストールするなら、インターネットに直接つないでからこれ。

```bash
pip install git+https://github.com/ansible/ansible.git@devel
```

## Mozcのインストール（10.14 Mojaveではインストールできない）

公式サイト通りに実行する。

<https://github.com/google/mozc/blob/master/docs/build_mozc_in_osx.md>

Mozcの前提条件になっているのは以下の３つ。

- Xcode
- Ninja
- Qt 5

XcodeはMac App Storeからインストールする。

Ninjaはbrewでインストールする。

```bash
brew install ninja
```

GUIツールの利用は諦めて、Qtはインストールしない

コードの取得。とても時間かかる。

```bash
cd ~/tmp
git clone https://github.com/google/mozc.git -b master --single-branch --recursive
```

コンパイル。

```bash
cd src
sw_vers
GYP_DEFINES="mac_sdk=10.14 mac_deployment_target=10.14" python build_mozc.py gyp --noqt --branding=GoogleJapaneseInput
python build_mozc.py build -c Release unix/emacs/emacs.gyp:mozc_emacs_helper
```

## emacsのインストール

古いCarbon Emacs22はtoggle-input-methodとIMEが連動するため非常に快適に利用できる。
新しいmacOSで動かなくなるギリギリまでこれを利用する。

ダウンロード元
<http://th.nao.ac.jp/MEMBER/zenitani/emacs-j.html>

もちろん新しいemacsを併用することもできる。
新しいemacsはbrew castでインストールするのが楽。

参考文献
<http://keisanbutsuriya.hateblo.jp/entry/2016/04/10/115945>

参考文献
<https://github.com/railwaycat/homebrew-emacsmacport>

```bash
brew tap railwaycat/emacsmacport
brew cask install emacs-mac
```

実行結果。emacs-26.1がインストールされた。
/Applicationにも自動登録されるので、古いemacsが存在する場合は事前に名前を変えておく。

```bash
iida-macbook-pro:src iida$ brew cask install emacs-mac
==> Satisfying dependencies
==> Downloading https://s3.amazonaws.com/emacs-mac-port/emacs-26.1-mac-7.2-10.14.zip
Already downloaded: /Users/iida/Library/Caches/Homebrew/downloads/0f62846e0affb78710f72d13aec0aa91149385e60648cdc33b2f9b38081aae68--emacs-26.1-mac-7.2-10.14.zip
==> Verifying SHA-256 checksum for Cask 'emacs-mac'.
==> Installing Cask emacs-mac
==> Moving App 'Emacs.app' to '/Applications/Emacs.app'.
==> Linking Binary 'Emacs' to '/usr/local/bin/emacs'.
==> Linking Binary 'ebrowse' to '/usr/local/bin/ebrowse'.
==> Linking Binary 'emacsclient' to '/usr/local/bin/emacsclient'.
==> Linking Binary 'etags' to '/usr/local/bin/etags'.
🍺  emacs-mac was successfully installed!
```

# キーボード設定　Ctrl-Spaceの解除

Ctrl-Spaceのキーバンドは日本語入力に持って行かれるので、emacsのマークセットができなくなってしまう。
キーボードの設定でCtrl-Spaceを利用しているチェックボックスを外しておくこと。

# キーボード設定　バックスラッシュの入力

Macでは＼と￥が違う扱いになっている。

プログラムを書くときには＼でないと都合が悪い。
Pythonで￥nをprintしても改行しない。

＼の出し方は、

- optionキーを押しながら￥キーを押す

というキーストロークで入力可能。

IMEごとに￥と＼のどっちを使うか設定可能。
Google日本語入力の場合は以下の通り。

1. 画面右上に、青字で白文字の「A」が出るように選択
1. 「環境設定...」を選択
1. 「一般」の「¥キーで入力する文字」を「\（バックスラッシュ）」に変更

# キーボード設定　アプリケーションごとに入力ソースを自動的に切り替える

他のアプリからターミナルに移るたびに日本語入力状態を確認するのは面倒なので必ず設定を変えること。

システム環境設定　→　キーボード　→　入力ソース

- [x] 書類ごとに入力ソースを自動的に切り替える

デフォルトはチェックがついてないので、つけること。

# sshの設定

古いデバイスとは暗号化のパラメータが一致せずSSH接続できないので設定で対応する。

~/.ssh/config

```ini
Host *
  KexAlgorithms +diffie-hellman-group1-sha1
  Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc

Host pg04
  User admin

Host 172.20.0.101
  ProxyCommand ssh -W %h:%p 10.35.158.20
  User ansible

Host 172.20.0.21
  ProxyCommand ssh -W %h:%p 10.35.158.20
  User cisco

Host 172.20.0.22
  ProxyCommand ssh -W %h:%p 10.35.158.20
  User cisco

Host 172.20.0.23
  ProxyCommand ssh -W %h:%p 10.35.158.20
  User cisco

Host 172.20.0.24
  ProxyCommand ssh -W %h:%p 10.35.158.20
  User cisco
```

# vagrant

このサイトからダウンロードしてインストールする。

<https://www.vagrantup.com/downloads.html>

環境変数 VAGRANT_HOME を設定しておくか、未指定時は```$HOME/.vagrant.d```にインストールされる。

## インストールしたバージョンの確認

```bash
iida-macbook-pro:bin iida$ vagrant --version
Vagrant 2.0.1
```

## ボックスのインストール方法

公開されているボックスの置き場はここ。

<http://www.vagrantbox.es/>

{tite}は任意の文字列。識別しやすい、わかりやすい文字列を使えば良い。

```bash
vagrant box add {title} {url}
vagrant init {title}
vagrant up
```

今回はUbuntuのボックスを使う。

Ubuntu 14.04.5 LTS (Trusty Tahr) server amd64 (Guest Additions 5.1.6)

<https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box>

ボックスのダウンロード（時間かかる）

```bash
$ vagrant box add ubuntu-14.04.5 https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'ubuntu-14.04.5' (v0) for provider:
    box: Downloading: https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box
==> box: Successfully added box 'ubuntu-14.04.5' (v0) for 'virtualbox'!
iida-macbook-pro:ubuntu-14.04.5 iida$
```

ここにデータが降ってくる

```bash
~/.vagrant.d/{title}
```

今回の場合は ```~/.vagrant.d/ubuntu-14.04.5/```

## 作業場所を作る

基本的にVagrantfileの存在する場所で作業をすることになる。

```bash
mkdir -p ~/Vagrant/ubuntu-14.04.5
cd ~/Vagrant/ubuntu-14.04.5/
```

## 作業場所でvagrantを初期化する

```bash
vagrant init ボックス名
```

```bash
iida-macbook-pro:ubuntu-14.04.5 iida$ vagrant init ubuntu-14.04.5
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
iida-macbook-pro:ubuntu-14.04.5 iida$

iida-macbook-pro:ubuntu-14.04.5 iida$ ls -alg
total 8
drwxr-xr-x  3 staff    96 12 10 15:53 .
drwxr-xr-x  4 staff   128 12 10 15:48 ..
-rw-r--r--  1 staff  3021 12 10 15:53 Vagrantfile
iida-macbook-pro:ubuntu-14.04.5 iida$
```

## Vagrantファイルを編集する

```bash
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu-14.04.5"
  config.vm.hostname = "ubuntu"
  config.vm.network "private_network", ip: "192.168.11.100"
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
  SHELL
end
```

## 状態確認

```bash
vagrant status
```

## インスタンスの起動

```bash
vagrant up
```

## 接続

```bash
vagrant ssh
```

# Node-RED

このサイトが最初のとっかかりによい。

ローカルインストールからRESTful APIまで

<https://qiita.com/noralife/items/4c9b975e9d1d664720a0>

# nodejsとnode-redのインストール(Ubuntuボックス)

```bash
vagrant up
vagrant ssh
```

以下、ubuntu内で作業
node.jsは安定版だと古すぎてダメ
このやり方だと安定版しか降ってこない。

```bash
# $ sudo apt-get update
# $ sudo apt-get install nodejs
# $ sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
# $ sudo apt-get install npm
```

最新版を取りに行くには
レポジトリを追加してからインストールする。

```bash
sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
sudo apt-get install -y nodejs
sudo npm install -g node-red
```

## node-redを実行する

```bash
node-red
```

母艦のMacのブラウザから
<http://192.168.100.100:1880/>
にアクセスする

node-redのデータ類は ~/.node-red に置かれる。

# MySQLのインストール(Ubuntuボックス)

```bash
sudo apt-get install -y mysql-server
```

インストールの途中でrootユーザのパスワードを設定するように促される

```bash
mysql -uroot -p
Enter password: [rootパスワードの入力]

mysql> CREATE DATABASE nodered;
Query OK, 1 row affected (0.00 sec)

mysql> CREATE TABLE nodered.users(id INT AUTO_INCREMENT, name TEXT, PRIMARY KEY (id));
Query OK, 0 rows affected (0.01 sec)
```

node-red用のmysqlライブラリをインストールする

```bash
cd ~/.node-red/
npm install node-red-node-mysql
node-red
```

---

# redisサーバ(Ubuntuボックス)

インストール

```bash
sudo apt-get -y install redis-server
```

インストールすると自動で起動する。

設定

/etc/redis/redis.conf

```bash
# 待ち受けポート
port 6379

# デフォルトはローカルホストからしか接続しない
# 全て受け入れるなら 0.0.0.0 を指定
bind 127.0.0.1

# データベースの個数
# データベースID は 0 から割り当てられ
# (指定した値-1)の数のデータベースが利用可能となる
databases 16

# 接続パスワードを設定
requirepass password

# データ更新の際は常にディスクに保存する設定 (「yes」 で有効化)
# 有効化するとデータは永続化されるがパフォーマンスは低下する
appendonly no

# 539行目：appendonly を有効化した場合の書き込みのタイミング
# always=常に, everysec=毎秒毎, no=fsyncしない(OSに任せる)
# appendfsync always
appendfsync everysec
# appendfsync no
```

起動

```bash
sudo systemctl restart redis
```

# tftpサーバ

/usr/libexec/tftpd はデーモンなので通常通りには起動できず、launchctlを経由して起動する。
設定は

```bash
/System/Library/LaunchDaemons/tftp.plist
```

を編集する。

## 起動

```bash
sudo launchctl load -w /System/Library/LaunchDaemons/tftp.plist
```

## 終了

```bash
sudo launchctl unload -w /System/Library/LaunchDaemons/tftp.plist
```

# emacs

2017年11月時点
emacs25は日本語(IME)の扱いがうまくいかないので、emacs24.3を入れるのがよい。

# システムにPython3をインストールする

システムはPython2のままにして、個人用にpyenvを使ったほうがよい。
システムにPython3を入れるなら、homebrewを使えばいい。

1. homebrewをインストールする
2. homebrewでpython3をインストールする

```bash
brew install python3
```

# Python2とPython3の使いわけ

使い分ける方法には、virtualenvとpyenvがある。
virtualenvは少々使いづらい印象のため、pyenvを使う。

## pyenvのインストール

githubのpyenvをホームディレクトリの.pyenvにクローンする。

```bash
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-update.git ~/.pyenv/plugins/pyenv-update
```

.bashrcを編集する

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYTHON_CONFIGURE_OPTS="--enable-framework"
eval "$(pyenv init -)"
```

pyenv自身をバージョンアップするときは

```bash
pyenv update
```

## pyenv配下にpythonをインストールする

このコマンドでインストールできるpythonのバージョンが表示される。

```bash
pyenv install --list
```

pyenvをインストールして時間が経過している場合は、最新のバージョンが表示されないことがある。
その場合pyenv自身を新しくしたほうがいい。
もともとgitで入れているので、pullすれば最新になる。

```bash
cd ~/.pyenv
git pull
```

ここでは３系と２系、両方入れておく。

```bash
pyenv install 3.6.3
pyenv install 2.7.14
```

これにより~/.pyenv/versions/配下にPythonが配置される。

インストールに失敗したら、
`xcode-select --install`
をやってから、再度実行するとうまくいく。

このコマンドでインストール済みのバージョン一覧が表示される。

```bash
pyenv versions
```

インストール後はリフレッシュする。

```bash
pyenv rehash
```

古い方のバージョンで

```bash
pip freeze > requirments.txt
```

しておいて、新しいバージョンで

```bash
pip install -r requirements.txt
```

するとよい。

Pythonをアンインストールする場合

```bash
pyenv uninstall 3.6.3
```

## 使うPythonを変更する

特定のディレクトリ配下だけで指定したいのであればpyenv localを使う。
どの場所にいてもそのバージョンを使いたい場合はpyenv globalを使う。
通常はglobalを指定しておけばよい。

```bash
pyenv global 3.6.3
```

.bashrcにも上記を追加する。

# node.jsをインストールする

デフォルトではnode.jsはインストールされていない。
nodebrewを使ってインストールする。

```bash
iida-macbook-pro:~ iida$ brew install nodebrew
Updating Homebrew...
==> Downloading https://github.com/hokaccha/nodebrew/archive/v0.9.7.tar.gz
Already downloaded: /Users/iida/Library/Caches/Homebrew/nodebrew-0.9.7.tar.gz
==> Caveats
You need to manually run setup_dirs to create directories required by nodebrew:
  /usr/local/opt/nodebrew/bin/nodebrew setup_dirs

Add path:
  export PATH=$HOME/.nodebrew/current/bin:$PATH

To use Homebrew's directories rather than ~/.nodebrew add to your profile:
  export NODEBREW_ROOT=/usr/local/var/nodebrew

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

zsh completions have been installed to:
  /usr/local/share/zsh/site-functions
==> Summary
🍺  /usr/local/Cellar/nodebrew/0.9.7: 8 files, 38.1KB, built in 1 second
iida-macbook-pro:~ iida$
```

言われたとおりにする。

```bash
/usr/local/opt/nodebrew/bin/nodebrew setup_dirs
```

~/.nodebrewフォルダができる

~/.bashrcにexport文を追加する

source .bash_profile

```bash
nodebrew -v
```

```bash
nodebrew ls-remote
```

```bash
nodebrew install-binary v8.9.0
```

または

```bash
nodebrew install-binary stable
```

## インストール済みのバージョンをみる

```bash
nodebrew ls

iida-macbook-pro:~ iida$ nodebrew ls
v8.9.0

current: none
```

カレントを指定することで、nodejsを使えるようになる

```bash
nodebrew use v8.9.0
```

# Command Line Toolsのインストール

```bash
xcode-select --install
```

# HomeBrewのインストール

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
```

# mkisofsのためにcdrtoolsをインストールする

mkisofsはcdrtoolsの中に含まれている。
これは`/usr/local/sbin`にリンクを張ろうとするので、予め作成して、グループadminに書き込み権限を与えておく。

```bash
sudo mkdir /usr/local/sbin
sudo chgrp admin /usr/local/sbin
sudo chmod g+w /usr/local/sbin
```

ついでに/etc/pathsに`/usr/local/sbin`を加えておく。

```bash
iida$ cat /etc/paths
/usr/local/bin
/usr/local/sbin
/usr/bin
/bin
/usr/sbin
/sbin
```

cdrtoolsをインストールする。

```bash
iida$ brew install cdrtools
==> Downloading https://homebrew.bintray.com/bottles/cdrtools-3.01_1.high_sierra.bottle.1.tar.gz
Already downloaded: /Users/iida/Library/Caches/Homebrew/cdrtools-3.01_1.high_sierra.bottle.1.tar.gz
==> Pouring cdrtools-3.01_1.high_sierra.bottle.1.tar.gz
🍺  /usr/local/Cellar/cdrtools/3.01_1: 208 files, 4.7MB
```

# bash-completionのインストール

```bash
iida-macbook-pro:src iida$ brew install bash-completion
==> Downloading https://homebrew.bintray.com/bottles/bash-completion-1.3_3.mojave.bottle.tar.gz
######################################################################## 100.0%
==> Pouring bash-completion-1.3_3.mojave.bottle.tar.gz
==> Caveats
Add the following line to your ~/.bash_profile:
  [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d
==> Summary
🍺  /usr/local/Cellar/bash-completion/1.3_3: 189 files, 607.8KB
```

# pythonのインストール(OBSOLETED)

Macには最初から入っているが、都合が悪いので、入れなおす。

```bash
brew install python
brew install python3
```

# virtualenv、virtualenvwrapperのインストール(OBSOLETED)

```bash
sudo pip install virtualenv
sudo pip install virtualenvwrapper

cd ~
mkdir ~/.virtualenvs
```

.bashrcに追加する(.bashrcは最初は存在しないので注意)

```bash
cat << EOF >> .bashrc
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
EOF
```

.bash_profileに追加(.bash_profileは最初は存在しないので注意)

```bash
cat << EOF >> .bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
```

# python仮想環境の作成(OBSOLETED)

```bash
mkvirtualenv --no-site-package --python /usr/local/bin/python2 p2
mkvirtualenv --no-site-package --python /usr/local/bin/python3 p3

workon p3
```

グローバルに戻る

```bash
deactivate
```

不要な環境の削除

```bash
deactivate
rmvirtualenv p3
```

# アーカイバ

The Unarchiver

# メンテナンス系ソフトウェア

MainMenu

# アンインストール系ソフトウェア

AppCleaner

# ディスク状態表示

GrandPerspective

# デスクトップキャプチャ

DesktopToMovie

Jing <http://www.jingproject.com/>

# キーバインディングの変更

慣れればcommandキーも悪くないので、今は設定していない。

^はコントロールを意味する。

~/Library/KeyBindings/DefaultKeyBinding.dictのサンプル

```dict
{
    "^c"="copy:";
    "^x"="cut:";
    "^v"="paste:";
    "^z"="undo:";
    "^m"="insertNewline:";
}
```
