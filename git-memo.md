# git-memo.md
[//]:# ( git / github )

git関連の備忘録。

# git基本コマンド

## 設定の確認

```bash
git config --list
```

## ユーザ名の設定

```bash
git config --global user.name "takamitsu-iida"
git config --global user.email takamitsu.iida@gmail.com
```

## 日本語のファイル名の文字化けを防ぐ

```bash
git config --global core.quotepath false
```

## 改行コードを自動変換しない

```bash
git config --global core.autoCRLF false
```

## ファイルのモード変更を無視する

```bash
git config --global core.fileMode false
```

## プロキシ設定

```bash
git config --global http.https://github.com/.proxy http://username:password@servername:8080
git config --global https.https://github.com/.proxy http://username:password@servername:8080

git config --global url."https://".insteadOf git://
```

## リポジトリの新規作成

```bash
git init
```

## リポジトリの複製(githubからダウンロード)

```bash
git clone --depth 1 <gitのURL>
```

## コミット -aを付けると変更されたファイルを自動検出する

```bash
git commit -a -m "コミットメッセージ"
```

## コミットの取り消し

```bash
git reset
```

## ファイルの追加

```bash
git add -A
```

## ローカルの内容をプッシュ

```bash
git push <送信先リポジトリURL> <送信するブランチ>:<送信先ブランチ>
```

## 新しいブランチを作成

-bオプションでブランチ名を指定

```bash
git checkout -b <branch>
git checkout -b 'FIX-001'
```

## 作業の破棄

```bash
git checkout filename // 特定のファイル
git checkout . // 全部
```

## Untracked filesの表示を消す

```bash
git clean -f
```

## ローカルのmasterを最新にする

```bash
git pull
```

## コミットメッセージをテンプレート化する

~/.gitmessageファイルにテンプレート化する内容を記載し、以下で設定する。

```bash
git config --global commit.template ~/.gitmessage
```

もしくは、.gitconfigを直接書き換える。

```ini
[commit]
  template = ~/.gitmessage
```

# まずい情報を含めてしまった場合

緊急事態の場合はレポジトリを削除して、改めて作りなおせば簡単だが、過去のコミット履歴は全て消えてしまう。
正攻法は、githubのヘルプにある通り。

<https://help.github.com/articles/remove-sensitive-data/>

１．クローンしてローカルにデータを持ってくる

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
```

２．クローンしたフォルダに移動する

```bash
cd YOUR-REPOSITORY
```

３．git filter-branchコマンドで削除

消したいファイルをPATH-TO-YOUR-FILE-WITH-SENSITIVE-DATAとして、次のコマンドで削除する。

```bash
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA' --prune-empty --tag-name-filter cat -- --all
```

４．そのファイルが再びコミットされないように.gitignoreに追加しておく

５．pushしてリモートリポジトリも更新する

```bash
git push origin --force --all
```

６．タグを付けてリリースしたものからも削除する

```bash
git push origin --force --tags
```

７．ガーベージコレクトする

```bash
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now
```

# まずい情報を含めてしまった場合（bfg版）

<https://rtyley.github.io/bfg-repo-cleaner/>

BFG Repo-Cleanerを使うと簡単にできる。javaが必要。

# .gitignoreファイルを作成する

環境に依存する設定を書いたら、あとはgiboに自動生成させる。

## フォルダ単位で無視するものを書く

```text
bin/
data/
```

## giboのインストールと実行

インストールといってもcloneするだけ。
置き場所は任意だが、PATHを通すのは面倒なので、~直下にgiboフォルダを置いて、その中で実行する。

```bash
git clone https://github.com/simonwhitaker/gibo.git
```

gibo list を実行するとgithubからリストを取ってくるのでそれを見て必要な環境を列挙する

```bash
./gibo dump Windows Linux macOS Emacs vim python Node >> .gitignore
```

# GitLab連携

## pipelineをスキップしたい場合

コミットメッセージに

```ini
[ci skip]
```

を含めると、そのときだけパイプラインは走らない。

## GitLabとMattermostの連携

Mattermost側の管理画面→統合機能で内向きのウェブフックを追加する。
追加するとウェブフックのURLが作られるので、それをメモしておく。

GitLabのプロジェクトの設定のIntegrationから
Mattermost notificationを選択すると設定画面がでる。
そこに先に作成したウェブフックのURLを設定する

デフォルトでは、パイプラインは失敗したときしか通知しないので、必要に応じて外しておく。

## GitLab Runnerとの連携

gitlab-runner

<https://docs.gitlab.com/runner/install/linux-repository.html>

１．レポジトリを追加する

社内のプロキシを利用する関係でrootにならないと作業できない場合がある。

```bash
sudo -
```

RHEL/CentOS/Fedoraの場合はこう。

```bash
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash
```

２．インストールする

```bash
sudo dnf install gitlab-runner
```

３．gitlabのプロジェクトのトークンを採取する

参考

<http://nyameji.hatenablog.com/entry/2018/02/18/181445>

採取したトークンをメモする。トークンはこんな文字列→`fpdihywnjY36s9Y38YEe`

４．登録する

```bash
sudo gitlab-runner register
```

GitLabのURLやトークンを聞かれるので入力する。
登録するとGitLabの管理画面でも見れるようになり、設定もWeb画面で変えられるようになる。
