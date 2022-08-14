# go-memo.md

<br><br>

## install on WSL

https://go.dev/dl/

バージョンを確認する。
2022年6月時点ではversion 1.18.3が最新。

ダウンロードするファイル名はgo1.18.3.linux-amd64.tar.gz

古いバージョンを`/usr/local`から消す。

```bash
sudo rm -rf /usr/local/go* && sudo rm -rf /usr/local/go
```

ダウンロードしてインストールする。

```bash
VERSION=1.18.3
OS=linux
ARCH=amd64

cd $HOME
wget https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz
tar -xvf go$VERSION.$OS-$ARCH.tar.gz
mv go go-$VERSION
sudo mv go-$VERSION /usr/local
```

bashrcを編集する。

```
export GOROOT=/usr/local/go-1.18.3
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

バージョンを確認する。

```bash
iida@FCCLS0008993-00:~$ go version
go version go1.18.3 linux/amd64
```

<br><br>

## gccをインストールする

使用するパッケージによっては `exec: "gcc": executable file not found in %PATH%` というエラーが出る。
その場合はgccのインストールが必要。
最初から入れておくとよい。

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt autoremove -y
sudo apt-get install gcc -y
```
