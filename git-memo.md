# git基本コマンド

## 設定の確認

```
git config --list
```

## ユーザ名の設定

```
git config --global user.name "takamitsu-iida"
git config --global user.email takamitsu.iida@gmail.com
```

## 日本語のファイル名の文字化けを防ぐ

```
git config --global core.quotepath false
```

## リポジトリの新規作成

```
git init
```

## リポジトリの複製(githubからダウンロード)

```
git clone --depth 1 <gitのURL>
```

## コミット -aを付けると変更されたファイルを自動検出する

```
git commit -a -m "コミットメッセージ"
```

## コミットの取り消し

```
git reset
```

## ファイルの追加

```
git add -A
```

## ローカルの内容をプッシュ

```
git push <送信先リポジトリURL> <送信するブランチ>:<送信先ブランチ>
```

## 新しいブランチを作成

-bオプションでブランチ名を指定

```
git checkout -b <branch>
git checkout -b 'FIX-001'
```

## 作業の破棄

```
git checkout filename // 特定のファイル
git checkout . // 全部
```

## Untracked filesの表示を消す

```
git clean -f
```

## ローカルのmasterを最新にする

```
git pull
```

# まずい情報を含めてしまった場合

緊急事態の場合はレポジトリを削除して、改めて作りなおせば簡単だが、過去のコミット履歴は全て消えてしまう。
正攻法は、githubのヘルプにある通り。

https://help.github.com/articles/remove-sensitive-data/

1. クローンしてローカルにデータを持ってくる

```
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
```

2. クローンしたフォルダに移動する

```
cd YOUR-REPOSITORY
```

3. git filter-branchコマンドで削除

消したいファイルをPATH-TO-YOUR-FILE-WITH-SENSITIVE-DATAとして、次のコマンドで削除する。

```
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA' --prune-empty --tag-name-filter cat -- --all
```

4. そのファイルが再びコミットされないように.gitignoreに追加しておく

5. pushしてリモートリポジトリも更新する

```
git push origin --force --all
```

6. タグを付けてリリースしたものからも削除する

```
git push origin --force --tags
```

7. ガーベージコレクトする

```
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now
```


# まずい情報を含めてしまった場合（bfg版）

https://rtyley.github.io/bfg-repo-cleaner/

BFG Repo-Cleanerを使うと簡単にできる。
javaが必要。


# .gitignoreファイルを作成する

環境に依存する設定を書いたら、あとはgiboに自動生成させる。

## フォルダ単位で無視するものを書く

bin/
data/

## giboのインストールと実行

インストールといってもcloneするだけ。
置き場所は任意だが、PATHを通すのは面倒なので、~直下にgiboフォルダを置いて、その中で実行する。

```
git clone https://github.com/simonwhitaker/gibo.git gibo
```

gibo -lを実行するとgithubからリストを取ってくるのでそれを見て必要な環境を列挙する

```
gibo Windows Linux OSX Emacs vim python >> .gitignore
```
