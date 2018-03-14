
# Vagrant用のオリジナルBoxを作成する

参考
- https://qiita.com/KisaragiZin/items/64b664c8b20ea39a6cd1
- https://qiita.com/sims0728/items/306cf0434046296459b5

> 注意：
> 2018年2月時点ではFedora27のボックス化はうまくいかなかった。Fedora26をボックス化する。

## 大まかなやり方

1. Fedora26のISOイメージを取ってくる
1. ホストマシン(Linux)の/var/tmpに置く
1. ホストマシン(Linux)のGUIを開く
1. VirtualBoxを起動する
1. 仮想マシンを新規で作成してFedora26をインストールする
    - インストール中にrootのパスワードをvagrantに設定する
    - インストール中にadminアカウントを作成する
1. インストールしたら仮想マシンをshutdown
1. 仮想マシンを起動してカスタマイズする

カスタマイズは以下の通り。


## GUIでSSHを有効にする

GUIの設定で共有→リモートログインを有効にするとSSHが使えるようになる


## SELINUXを停止する

```
sudo vi /etc/selinux/config
```

 enforcingになっているのをdisabledに変更する

## iptablesを停止する

```
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off
```

## プロキシの設定をする

```
sudo vi /etc/bashrc
```

この環境変数をいれておくと大抵のものはプロキシを踏んでくれる。

```
export http_proxy="http://name:pass@proxy.server:8080"
export https_proxy="http://name:pass@proxy.server:8080"
export no_proxy="127.0.0.1,localhost,10.*,172.16.*,192.168.*,.local"
```

dnfのプロキシ設定は個別に設定しておく。

```
sudo vi /etc/dnf/dnf.conf
```

内容はこれ。

```
proxy = http://proxy.server:8080
proxy_username = name
proxy_password = pass
```

## udevの設定をする

これはよくわからんが、参考リンクに書いてあるのでその通りにする。

```
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
```

## アップデートする

```
sudo dnf -y update
sudo shutdown -r now
```

## ゲストモジュールを動かすために必要なカーネルをインストールする

```
sudo dnf -y install kernel kernel-devel perl gcc
sudo shutdown -r now
```

## vagrantユーザを追加する

```
sudo useradd -m vagrant
passwd vagrant
su - vagrant
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
curl -k -L -o authorized_keys 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant.vagrant /home/vagrant/.ssh
```

## パスワードなしでsudoできるようにする

```
visudo
```

以下の内容を追加する

```
# 新規追加
vagrant ALL=(ALL)       NOPASSWD: ALL
```

## 好きなものをいろいろとインストールする

```
sudo dnf -y install wget
sudo dnf -y install traceroute
sudo dnf -y install git
sudo dnf -y install finger
sudo dnf -y install ibus-mozc
sudo dnf -y install emacs
sudo dnf -y install emacs-mozc


pip3 install --upgrade pip --proxy=http://user:pass@proxy.server:8080
pip3 install requests --proxy=http://user:pass@proxy.server:8080
```

## vbguestをインストールする

仮想マシンを起動した状態で、ホスト側から実行する。

```
vagrant vbguest
```


## きれいにする

ボックスのファイルサイズを小さくするために以下を実行する。

```
sudo dnf clean all
sudo dd if=/dev/zero of=zero bs=4k
sudo rm -f zero
sudo shutdown -h now
```

# パッケージ化する

```
vagrant package --base fedora26
```

--baseオプションはVirtualBoxに付与されている仮想マシン名を指定する。
この作業はとても時間がかかる。

実行場所はどこでもよいが、実行した場所にpackage.boxという大きなファイルができるので、それを好きな名前に変更する。

これがボックスファイルになるので、
あとは`vagrant box add`でvagrantに追加して利用する。

この仮想マシンをさらにカスタマイズしてパッケージ化しくと便利。


---

# Fedora用のVagrantfile

```
# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # 読み込むボックス
  # see, $vagrant box list
  config.vm.box = "fedora-26-20180217-1.box"

  # 秘密鍵を置き換えない
  config.ssh.insert_key = false

  # 自動調整するポートの範囲(大量にVMを作るとよく重複するのでレンジを分ける)
  vm_port_range = (4000..4100)
  config.vm.usable_port_range = vm_port_range

  # vagrant plugin install vagrant-vbguest
  # vagrant vbguest
  # vagrant vbguest --status
  if Vagrant.has_plugin?("vagrant-vbguest")
    # 自動アップデート
    config.vbguest.auto_update = true

    # 最新をリモートから取ってこない
    config.vbguest.no_remote = true
  end

  # vagrant plugin install vagrant-proxyconf
  #if Vagrant.has_plugin?("vagrant-proxyconf")
  #  config.proxy.http = "http://rep.proxy...:8080"
  #  config.proxy.https = "http://rep.proxy...:8080"
  #  config.proxy.no_proxy = "localhost,127.0.0.1,.devel,.local"
  #end

  ## ## ##

  # 複数の仮想マシンを起動するなら、名前とアドレスを追加する
  {
    "fedora-work" => "192.168.33.250"
  }.each do |name, address|

    config.vm.define name do |host|

      # vagrant plugin install vagrant-hostsupdater
      if Vagrant.has_plugin?("vagrant-hostsupdater")
        # 仮想マシンのホスト名
        host.vm.hostname = name + ".local"
      end

      # プライベートネットワークのアドレス設定
      host.vm.network :private_network, ip: address

      # virtualboxの設定
      config.vm.provider :virtualbox do |vb|
        # GUI不要
        vb.gui = false
        # VirtualBoxに登録する仮想マシン名
        vb.name = name
        # メモリ(MB)
        vb.memory = "1024"
        # CPU
        vb.cpus = 1
      end

    end  #config.vm.define

  end  #each

  #config.vm.provision 'shell', inline: <<-SCRIPT
  #  sudo dnf -y update
  #SCRIPT

end

```
