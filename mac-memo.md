
# .bash_profile

.bash_profileはログイン時に実行され主に環境変数を設定する。

.bashrcはbash起動ごとに実行される。
主にシェル変数(exportしないもの)やエイリアスを設定する。

.bashrcは作っても読み込まれないので、先に.bash_profileを作る。

```
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
```

# .bashrc

2017年12月時点はこれ。

```
# $HOME/binを最後に通す
export PATH=$PATH:$HOME/bin

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
export PYTHON_CONFIGURE_OPTS="--enable-framework"
eval "$(pyenv init -)"

# 2.7.14と3.6.3がインストールされている
pyenv global 3.6.3

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
```


# vagrant

このサイトからダウンロードしてインストールする。
https://www.vagrantup.com/downloads.html

環境変数 VAGRANT_HOME を設定しておくか、未指定時は```$HOME/.vagrant.d```にインストールされる。

### インストールしたバージョンの確認。

```
iida-macbook-pro:bin iida$ vagrant --version
Vagrant 2.0.1
```

### ボックスのインストール方法

公開されているボックスの置き場はここ。
http://www.vagrantbox.es/

{tite}は任意の文字列。識別しやすい、わかりやすい文字列を使えば良い。

```
$ vagrant box add {title} {url}
$ vagrant init {title}
$ vagrant up
```

今回はUbuntuのボックスを使う。

Ubuntu 14.04.5 LTS (Trusty Tahr) server amd64 (Guest Additions 5.1.6)
https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box

ボックスのダウンロード（時間かかる）

```
$ vagrant box add ubuntu-14.04.5 https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'ubuntu-14.04.5' (v0) for provider:
    box: Downloading: https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box
==> box: Successfully added box 'ubuntu-14.04.5' (v0) for 'virtualbox'!
iida-macbook-pro:ubuntu-14.04.5 iida$
```

ここにデータが降ってくる

```
~/.vagrant.d/{title}
```

今回の場合は ```~/.vagrant.d/ubuntu-14.04.5/```

### 作業場所を作る

基本的にVagrantfileの存在する場所で作業をすることになる。

```
$ mkdir -p ~/Vagrant/ubuntu-14.04.5
$ cd ~/Vagrant/ubuntu-14.04.5/
```

### 作業場所でvagrantを初期化する

```
vagrant init ボックス名
```

```
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

### Vagrantファイルを編集する

```
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


### 状態確認

```
vagrant status
```

### インスタンスの起動

```
vagrant up
```

### 接続

```
vagrant ssh
```

# Node-RED

このサイトが最初のとっかかりによい。

ローカルインストールからRESTful APIまで
https://qiita.com/noralife/items/4c9b975e9d1d664720a0


# nodejsとnode-redのインストール(Ubuntuボックス)

```
$ vagrant up
$ vagrant ssh
```

以下、ubuntu内で作業
node.jsは安定版だと古すぎてダメ
このやり方だと安定版しか降ってこない。

```
# $ sudo apt-get update
# $ sudo apt-get install nodejs
# $ sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
# $ sudo apt-get install npm
```

最新版を取りに行くには
レポジトリを追加してからインストールする。

```
$ sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
$ sudo apt-get install -y nodejs
$ sudo npm install -g node-red
```

### node-redを実行する

```
$ node-red
```

母艦のMacのブラウザから
http://192.168.100.100:1880/
にアクセスする

node-redのデータ類は ~/.node-red に置かれる。


# MySQLのインストール(Ubuntuボックス)

```
$ sudo apt-get install -y mysql-server
```

インストールの途中でrootユーザのパスワードを設定するように促される

```
$ mysql -uroot -p
Enter password: [rootパスワードの入力]

mysql> CREATE DATABASE nodered;
Query OK, 1 row affected (0.00 sec)

mysql> CREATE TABLE nodered.users(id INT AUTO_INCREMENT, name TEXT, PRIMARY KEY (id));
Query OK, 0 rows affected (0.01 sec)
```

node-red用のmysqlライブラリをインストールする

```
$ cd ~/.node-red/
$ npm install node-red-node-mysql
$ node-red
```

---

# redisサーバ(Ubuntuボックス)


インストール

```
$ sudo apt-get -y install redis-server
```

インストールすると自動で起動する。


設定

/etc/redis/redis.conf

```
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

```
$ sudo systemctl restart redis
```



# tftpサーバ

/usr/libexec/tftpd はデーモンなので通常通りには起動できず、launchctlを経由して起動する。
設定は
```
/System/Library/LaunchDaemons/tftp.plist
```
を編集する。

### 起動

```
sudo launchctl load -w /System/Library/LaunchDaemons/tftp.plist
```


### 終了

```
sudo launchctl unload -w /System/Library/LaunchDaemons/tftp.plist
```

# インベントリ情報

### 2017年購入品

```
ハードウェアの概要:
MacBook Pro (13-inch, 2017, 2 TBT3)
シリアル番号：  C02VC2KCHV2D
購入日：2017/09/28
購入日：確認済み
お客様の製品は Apple 製品限定保証のハードウェア修理サービス保証の対象です。
有効期限 (推定)：2018年10月21日

  機種名: MacBook Pro
  機種ID: MacBookPro14,1
  プロセッサ名: Intel Core i5
  プロセッサ速度: 2.3 GHz
  プロセッサの個数: 1
  コアの総数: 2
  二次キャッシュ（コア単位）: 256 KB
  三次キャッシュ: 4 MB
  メモリ: 8 GB
  ブートROMのバージョン: MBP141.0160.B02
  SMCバージョン（システム）: 2.43f6
  シリアル番号（システム）: C02VC2KCHV2D
  ハードウェアUUID: 96179E35-1645-596C-A1C9-BCC688A61B7D
```


# emacs

2017年11月時点
emacs25は日本語(IME)の扱いがうまくいかないので、emacs24.3を入れるのがよい。


# Python3のインストール

以下のpyenvを使ったほうがよい。

1. homebrewをインストールする
2. homebrewでpython3をインストールする

```
brew install python3
```

# Python2とPython3の使いわけ

使い分ける方法には、virtualenvとpyenvがある。
virtualenvは少々使いづらい印象のため、pyenvを使う。

# pyenvのインストール

githubのpyenvをホームディレクトリの.pyenvにクローンする。

```
$ git clone git://github.com/yyuu/pyenv.git ~/.pyenv
```

.bashrcを編集する

```
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYTHON_CONFIGURE_OPTS="--enable-framework"
eval "$(pyenv init -)"
```

# pyenv配下にpythonをインストールする

`pyenv install --list` コマンドでインストールできるpythonのバージョンが表示される。

```
$ pyenv install 3.6.3
$ pyenv install 2.7.14
```

これにより~/.pyenv/versions/配下にPythonが配置される。

```
$ pyenv versions
```

コマンドでインストール済みのバージョン一覧が表示される。

インストール後はリフレッシュする。

```
$ pyenv rehash
```

Pythonをアンインストールする場合

```
$ pyenv uninstall 3.6.3
```


# 使うPythonを変更する

特定のディレクトリ配下だけで指定したいのであればpyenv localを使う。
どの場所にいてもそのバージョンを使いたい場合はpyenv globalを使う。
通常はglobalを指定しておけばよい。

```
$ pyenv global 3.6.3
```

.bashrcにも上記を追加する。


# node.jsをインストールする

デフォルトではnode.jsはインストールされていない。
nodebrewを使ってインストールする。

```
$ brew install nodebrew

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

```
$ /usr/local/opt/nodebrew/bin/nodebrew setup_dirs
```

~/.nodebrewフォルダができる

~/.bashrcにexport文を追加する

source .bash_profile


```
$ nodebrew -v
```

```
$ nodebrew ls-remote
```

```
$ nodebrew install-binary v8.9.0
```

または

```
$ nodebrew install-binary stable
```

### インストール済みのバージョンをみる

```
$ nodebrew ls

iida-macbook-pro:~ iida$ nodebrew ls
v8.9.0

current: none
```

カレントを指定することで、nodejsを使えるようになる

```
$ nodebrew use v8.9.0
```


# Command Line Toolsのインストール

```
xcode-select --install
```

# HomeBrewのインストール

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
```

# mkisofsのためにcdrtoolsをインストールする

mkisofsはcdrtoolsの中に含まれている。
これは`/usr/local/sbin`にリンクを張ろうとするので、予め作成して、グループadminに書き込み権限を与えておく。

```
sudo mkdir /usr/local/sbin
sudo chgrp admin /usr/local/sbin
sudo chmod g+w /usr/local/sbin
```

ついでに/etc/pathsに`/usr/local/sbin`を加えておく。

```
$ cat /etc/paths
/usr/local/bin
/usr/local/sbin
/usr/bin
/bin
/usr/sbin
/sbin
```

cdrtoolsをインストールする。

```
$ brew install cdrtools
==> Downloading https://homebrew.bintray.com/bottles/cdrtools-3.01_1.high_sierra.bottle.1.tar.gz
Already downloaded: /Users/iida/Library/Caches/Homebrew/cdrtools-3.01_1.high_sierra.bottle.1.tar.gz
==> Pouring cdrtools-3.01_1.high_sierra.bottle.1.tar.gz
🍺  /usr/local/Cellar/cdrtools/3.01_1: 208 files, 4.7MB
```

# bash-completionのインストール

```
brew install bash-completion

Add the following lines to your ~/.bash_profile:
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
```


# pythonのインストール(OLD)

Macには最初から入っているが、都合が悪いので、入れなおす。

```
brew install python
brew install python3
```

# virtualenv、virtualenvwrapperのインストール(OLD)

```
sudo pip install virtualenv
sudo pip install virtualenvwrapper

cd ~
mkdir ~/.virtualenvs
```

.bashrcに追加する(.bashrcは最初は存在しないので注意)

```
cat << EOF >> .bashrc
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
EOF
```

.bash_profileに追加(.bash_profileは最初は存在しないので注意)

```
cat << EOF >> .bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
```


# python仮想環境の作成(OLD)

```
mkvirtualenv --no-site-package --python /usr/local/bin/python2 p2
mkvirtualenv --no-site-package --python /usr/local/bin/python3 p3

workon p3
```

グローバルに戻る

```
deactivate
```

不要な環境の削除

```
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

Jing http://www.jingproject.com/


# キーバインディングの変更

^はコントロールを意味する。

~/Library/KeyBindings/DefaultKeyBinding.dictのサンプル

```
{
    "^c"="copy:";
    "^x"="cut:";
    "^v"="paste:";
    "^z"="undo:";
    "^m"="insertNewline:";
}
```
