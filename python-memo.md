[//]:# (@@@)
# テーブル表示

## tabulate.py

ファイル一つでいいのでお気に入り。

<https://pypi.org/project/tabulate/>

## PrettyTable

これも良い。

<https://pypi.org/project/PrettyTable/>


[//]:# (@@@)
# pygments

```bash
C:\TMP\prompt>pip install pygments --proxy=http://username:password@proxy.server:8080
Collecting pygments
  Downloading Pygments-2.2.0-py2.py3-none-any.whl (841kB)
    100% |################################| 849kB 160kB/s
Installing collected packages: pygments
Successfully installed pygments-2.2.0

C:\TMP\prompt>
```

[//]:# (@@@)
prompt_toolkit

```bash
C:\HOME\iida>pip install prompt_toolkit --proxy=http://username:password@proxy.server:8080
Collecting prompt_toolkit
  Downloading prompt_toolkit-1.0.14-py3-none-any.whl (248kB)
    100% |################################| 256kB 729kB/s
Collecting wcwidth (from prompt_toolkit)
  Downloading wcwidth-0.1.7-py2.py3-none-any.whl
Requirement already satisfied: six>=1.9.0 in c:\python35\lib\site-packages (from prompt_toolkit)
Installing collected packages: wcwidth, prompt-toolkit
Successfully installed prompt-toolkit-1.0.14 wcwidth-0.1.7

C:\HOME\iida>
```

[//]:# (@@@)

tinydbの使い方

<http://tinydb.readthedocs.io/en/latest/usage.html>

辞書型を格納する

```python
db.insert({'name': 'John', 'age': 22})
```

全データを配列で取得する

```python
db.all()
```

検索する

```python
q = Query()
db.search(q.name == 'John')
```

アップデートする
nameがJohnになっている辞書型の'age'フィールドを23に変更する

```python
db.update({'age': 23}, q.name == 'John')
```

削除する

```python
db.remove(q.age < 22)
```

全部削除する

```python
db.purge()
```

[//]:# (@@@)
# デコレータの引数を元に関数を動的に呼び出す

@を付けた関数は、定義と同時にデコレータ関数が走るので、
そのタイミングで辞書型に関数を登録してしまえばいい。

@を付けて定義すれば、定義と同時に何か処理をやらせることもできる、ということ。

これを走らせてみれば動作がよく分かる。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
デコレータの動作テスト
"""

import functools  # デコレータを作るのに必要
import os
import sys

def here(path=''):
  """相対パスを絶対パスに変換して返却します"""
  return os.path.abspath(os.path.join(os.path.dirname(__file__), path))

# libフォルダにおいたpythonスクリプトを読みこませるための処理
sys.path.append(here("../lib"))
sys.path.append(here("../lib/site-packages"))

funcdic = {}

def GET(url=""):
  """GETデコレータを定義"""
  print("#####デコレータの中 : " + url + " #####")

  def _outer_wrapper(wrapped_function):
    @functools.wraps(wrapped_function)

    def _wrapper(*args, **kwargs):
      # 前処理

      # 実行
      result = wrapped_function(*args, **kwargs)

      # 後処理
      return result

    # 辞書にデコレータの引数と実行すべき関数を入れておく
    funcdic[url] = _wrapper

    return _wrapper

  return _outer_wrapper


@GET(url='/a')
def func_1(data=""):
  """関数1"""
  print("func_1:" + data)
  return "関数1"


@GET(url='/b')
def func_2(data=""):
  """関数2"""
  print("func_2:" + data)
  return "関数2"

# 定義しかしていないのだが、デコレータが実行されていて、funcdicには関数が登録される
print(funcdic)

if __name__ == '__main__':

  # 呼び出す
  funcdic['/a']("データ1")
  funcdic['/b']("データ2")
```

[//]:# (@@@)
# yapf

```bash
pip install yapf
```

vs codeでの設置

```js
  "python.formatting.yapfArgs": [
    "--style={based_on_style: chromium, indent_width: 4, continuation_indent_width: 4, column_limit: 120}"
  ],
```

[//]:# (@@@)
# pylint

```bash
pip install pylint
```

```bash
pylint --generate-rcfile > .pylintrc
```

[//]:# (@@@)
# print

```python
# endを指定しない場合は"\n"がdefaultとなり出力の最後で改行される
print("aaa") # -> aaa\n

# endに空文字を指定することで改行を防止できる
print("aaa", end="") # -> aaa

# 引数には出力用データを複数指定可能
# データの結合文字はsepで指定する。defaultは半角スペース
print("aaa", "bbb") # -> aaa bbb\n

# sepで結合文字を変更
print("aaa", "bbb", sep=",") # -> aaa,bbb\n

# sepとendは同時に設定可能
print("aaa", "bbb", sep=",", end="") # -> aaa,bbb

# fileで指定したファイルオブジェクトに出力できる
print("test", file=sys.stdout)
```

[//]:# (@@@)
# excel

```python
pip install xlrd
```

ここを参考に
<http://www.python-izm.com/contents/external/xlrd.shtml>

[//]:# (@@@)
# tqdm

コンソールに進捗バーを表示する

普通のループ

```python
for item in items:
  process(item)
```

tqdmでラップしてループさせると進捗バーが表示される

```python
from tqdm import tqdm
for item in tqdm(items):
  process(item)
```

[//]:# (@@@)
# JSONデータのファイル保存

```python
import codecs
import json

def save_json(file_path, data):
  u"""JSON形式のデータをファイルに保存します."""
  try:
    with codecs.open(here(file_path), "w", "utf-8") as file:
      json.dump(data, file, indent=2, ensure_ascii=False)
  except Exception:
    pass


def load_json(file_path):
  u"""JSON形式で保存されているデータをファイルから読んで返却します."""
  try:
    with codecs.open(here(file_path), "r", "utf-8") as file:
      text = file.read()
      data = json.loads(text)
  except Exception:
    data = None
  return data
```

[//]:# (@@@)
# difflibの使い方

```python
#!/usr/bin/env python

# difflib_test

import difflib

file1 = open('/home/saad/Code/test/new_tweets', 'r')
file2 = open('/home/saad/PTITVProgs', 'r')

diff = difflib.ndiff(file1.readlines(), file2.readlines())
delta = ''.join(x[2:] for x in diff if x.startswith('- '))
print delta
```

[//]:# (@@@)
# flake8

C:\HOME\iida\.flake8

```ini
[flake8]
ignore = E111,I100,I201,H306,E121,D203,D204,C901
max-line-length = 200
exclude = log/*,lib/site-packages/*
max-complexity = 10
```

```bash
flake8 --config=.flake8 lib\---.py
```

[//]:# (@@@)
# bottle

```python
@post('/b/data/nodes')
def b_data_nodes():
  u"""ノード一覧情報を返却します."""
  r = HTTPResponse(status=200)
  r.set_header('Content-Type', 'application/json')

  # 戻り値となる辞書型データ
  result_dict = {}
  result_dict["status"] = "SUCCESS"  # or ERROR
  result_dict["result"] = ""  # str

  # キャッシュするファイルのパス
  file_path = './data/nodes.json'

  if VELCOUN_IS_ONLINE:
    data = data_nodes_velcoun()
    if data:
      logging.info(u"VELCOUN-Xからノード一覧取得を取得しました")
      if VELCOUN_SAVE_CACHE:
        data_cache(file_path, data)
      result_dict["result"] = data
      r.body = json.dumps(result_dict, ensure_ascii=False)
      return r
    else:
      logging.warn(u"VELCOUN-Xからのノード一覧取得に失敗しました。ディスクキャッシュを返却します")
  else:
    logging.info(u"オフラインモードのためディスクキャッシュからノード一覧を返却します")

  data = data_cache(file_path)
  if data:
    result_dict["result"] = data
  else:
    result_dict["status"] = "ERROR"
    result_dict["result"] = "read file error of {0}".format(file_path)
  r.body = json.dumps(result_dict, ensure_ascii=False)
  return r


# 注意：完了後もVELCOUNからログアウトしない
def data_nodes_velcoun():
  u"""ノード一覧をVELCOUN-Xから採取してJSON形式で返却します."""
  v = vrest.VelcounRest()
  v.timeout(10)
  if not v.login():
    return None
  j = v.get("/controller/nb/v2/devicemanager/default/nodes")
  # v.logout()
  if j:
    return j
  return None



@post('/b/data/customs')
def b_data_customs():
  u"""拡張機能一覧情報を返却します."""
  r = HTTPResponse(status=200)
  r.set_header('Content-Type', 'application/json')

  # 戻り値となる辞書型データ
  result_dict = {}
  result_dict["status"] = "SUCCESS"  # or ERROR
  result_dict["result"] = ""  # str

  file_path = './data/customs.json'

  if VELCOUN_IS_ONLINE:
    data = data_customs_velcoun()
    if data:
      logging.info(u"VELCOUN-Xから拡張機能一覧を取得しました")
      if VELCOUN_SAVE_CACHE:
        data_cache(file_path, data)
      result_dict["result"] = data
      r.body = json.dumps(result_dict, ensure_ascii=False)
      return r
    else:
      logging.warn(u"VELCOUN-Xからの拡張機能一覧取得に失敗しました。ディスクキャッシュを返却します")
  else:
    logging.info(u"オフラインモードのためディスクキャッシュから拡張機能一覧を返却します")

  data = data_cache(file_path)
  if data:
    result_dict["result"] = data
  else:
    result_dict["status"] = "ERROR"
    result_dict["result"] = "read file error of {0}".format(file_path)
  r.body = json.dumps(result_dict, ensure_ascii=False)
  return r


# 注意：完了後もVELCOUNからログアウトしない
def data_customs_velcoun():
  u"""VELCOUN-Xから拡張機能一覧を採取してJSON形式で返却します."""
  v = vrest.VelcounRest()
  v.timeout(10)
  if not v.login():
    return None
  j = v.get("/controller/nb/v2/custommanager/default/custom")
  # v.logout()
  if not j:
    return None

  # 結果を格納する辞書型オブジェクト
  result = {}
  result["custom"] = j  # 拡張機能のリスト

  # 拡張機能詳細を採取するためのURLは少々難解で、機種タイプ/プロファイル名　を調べないといけない
  detail_paths = []
  functionInfo = j.get("functionInfo", [])
  for fi in functionInfo:
    nodeType = fi.get("targetNodeType", "")
    profileNames = fi.get("profileName", [])
    profileNames = [e.replace('/', '%2f') for e in profileNames]
    profileNames = [nodeType + '/' + e for e in profileNames]
    detail_paths.extend(profileNames)
  detail_paths = list(set(detail_paths))  # 一度setに変換して再度listに戻すと重複が排除される
  # print detail_paths # こうなる→ [u'CSCT/Catalyst_IOS%2ftelnet', u'CSCT/Catalyst_IOS%2fdefault']

  # これらパスに接続して詳細情報を採取する
  prefix = "/controller/nb/v2/custommanager/default/custom/"
  for url in detail_paths:
    j = v.get(prefix + url)
    if j:
      result[url] = j

  return result
```

[//]:# (@@@)
# tailerモジュール

tailコマンドっぽいやつ

```python
# Get the last 3 lines of the file
tailer.tail(open('test.txt'), 3)
# ['Line 9', 'Line 10', 'Line 11']
```

[//]:# (@@@)
# WebSocket

JavaScript側

イベントハンドラ
 onopen 接続イベント
 onclose 切断イベント
 onmessage メッセージ受信イベント
 onerror エラーイベント

メソッド
 send メッセージ送信
 close 切断

[//]:# (@@@)
# pipコマンドの使い方

<http://www.task-notes.com/entry/20150810/1439175600>

インストール済みを確認

```bash
pip list
```

パッケージ情報

```bash
pip show <package>
```

削除

```bash
pip uninstall <pandas>
```

[//]:# (@@@)
# bottle-websocket

bottle-0.12.9
bottle-websocket-0.2.9
gevent-1.1.0
gevent-websocket-0.9.5

```bash
C:\HOME\iida\python\b7>pip install bottle-websocket
Collecting bottle-websocket
  Downloading bottle-websocket-0.2.9.tar.gz
Collecting bottle (from bottle-websocket)
  Downloading bottle-0.12.9.tar.gz (69kB)
    100% |################################| 71kB 1.5MB/s
Collecting gevent-websocket (from bottle-websocket)
  Downloading gevent-websocket-0.9.5.tar.gz
Collecting gevent (from gevent-websocket->bottle-websocket)
  Downloading gevent-1.1.0-cp27-cp27m-win32.whl (354kB)
    100% |################################| 358kB 1.6MB/s
Requirement already satisfied (use --upgrade to upgrade): greenlet>=0.4.9 in c:\
python27\lib\site-packages (from gevent->gevent-websocket->bottle-websocket)
Installing collected packages: bottle, gevent, gevent-websocket, bottle-websocket
  Running setup.py install for bottle ... done
  Running setup.py install for gevent-websocket ... done
  Running setup.py install for bottle-websocket ... done
Successfully installed bottle-0.12.9 bottle-websocket-0.2.9 gevent-1.1.0 gevent-websocket-0.9.5
```

[//]:# (@@@)
# リストのフラット化

[ [1,2], [3,4], [5,6] ]
のようなのをフラット化する方法

d.hatena.ne.jp/xef/20121027/p2

```python
  functionInfo = j.get("functionInfo", []) # これは配列
  profileNames = [fi.get("profileName", []) for fi in functionInfo] # リストの中にリストが存在する
  profileNames = [e for innerList in profileNames for e in innerList] # それをフラットに展開
  profileNames = list(set(profileNames)) # 一度setに変換して再度listに戻すと重複が排除される
  # print profileNames # こんな感じ [u'Catalyst_IOS/default', u'Catalyst_IOS/telnet']
  profileNames = [e.replace('/', '%2f') for e in profileNames] # /を%2fに置き換え
  print profileNames # 最終的にこんな感じ [u'Catalyst_IOS%2fdefault', u'Catalyst_IOS%2ftelnet']
```

[//]:# (@@@)
# ログ解析ツール

クロージャとyieldを使うと楽

<http://t2y.hatenablog.jp/entry/20101124/1290534464>

[//]:# (@@@)
# クロージャ

Pythonにおけるクロージャは、関数を返す関数

返却される内側の関数では、外側の関数で定義した変数を使うことができ、
引数を使ったり、一時記憶として使うことができる。

<http://www.lifewithpython.com/2014/09/python-use-closures.html>

[//]:# (@@@)
# yield

イテレータを抱えた関数を作るためのもの

[//]:# (@@@)
# bottleとMongoDB

<https://myadventuresincoding.wordpress.com/2011/01/02/creating-a-rest-api-in-python-using-bottle-and-mongodb/>

```python
import json
import bottle
from bottle import route, run, request, abort
from pymongo import Connection

connection = Connection('localhost', 27017)
db = connection.mydatabase

@route('/documents', method='PUT')
def put_document():
    data = request.body.readline()
    if not data:
        abort(400, 'No data received')
    entity = json.loads(data)
    if not entity.has_key('_id'):
        abort(400, 'No _id specified')
    try:
        db['documents'].save(entity)
    except ValidationError as ve:
        abort(400, str(ve))

@route('/documents/:id', method='GET')
def get_document(id):
    entity = db['documents'].find_one({'_id':id})
    if not entity:
        abort(404, 'No document with id %s' % id)
    return entity

run(host='localhost', port=8080)
```

[//]:# (@@@)
# bottleとgeventを組み合わせて非同期化する

<http://hamukazu.com/2016/01/04/bottle_and_gevent/>

```bash
pip install gevent
```

[//]:# (@@@)
# HTML Kickstart

<http://www.99lime.com/>

別物に注意。これは違う→ <http://getkickstart.com/>

Font Awesomeが組み込まれている。
<http://fortawesome.github.io/Font-Awesome/>
<http://fortawesome.github.io/Font-Awesome/examples/>

アイコン一覧はここ
<http://fortawesome.github.io/Font-Awesome/cheatsheet/>

```html
<i class="fa fa-check-circle"/>
```

jsonからテーブルに変える

```js
$.ajax({
    type: 'GET',
    url: 'scripts/actions/get.php',
    dataType: 'json',
    success: function(data) {
        $.each(data,function(i,user){
        $('tr:odd').addClass('odd');
            var tblRow =
                "<tr>"
                +"<td><input name='chk' type='checkbox' id='chk' myid = "+user.id+"></td>"
                +"<td>"+user.id+"</td>"
                +"<td>"+user.name+"</td>"
                +"<td>"+user.principal+"</td>"
                +"<td>"+user.admin_contact_person+"</td>"
                +"<td>"+user.telephone_number+"</td>"
                +"<td>"+user.fax_number+"</td>"
                +"<td>"+user.contact_person_email+"</td>"
                +"</tr>";

                $(tblRow).appendTo("#tbody");

                });
            }
        });
```

[//]:# (@@@)
# IPアドレスの操作にはnetaddrモジュールが便利

```bash
pip install netaddr
```

<http://momijiame.tumblr.com/post/50497347245/python-%E3%81%A7-ip-mac-%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9%E6%89%B1%E3%81%86%E3%81%AA%E3%82%89-netaddr-%E3%81%8C%E8%B6%85%E4%BE%BF%E5%88%A9>

[//]:# (@@@)
# bottle

使い方
<http://myenigma.hatenablog.com/entry/2015/06/27/112553>

bottleでMVCの実装例
<http://x1.inkenkun.com/archives/221>

ResponseとRequestオブジェクトの使い方
<http://qiita.com/tomotaka_ito/items/62fc4d58d1be7867a158>

bottle.requestにアクセスすると、現在処理しているリクエストにアクセスできます。

bottle.pyが保持するメモリバッファは小さいので、大きなデータを
POSTするとエラーになる。

```bash
#: Maximum size of memory buffer for :attr:`body` in bytes.
#MEMFILE_MAX = 102400
MEMFILE_MAX = 10240000
```

bottle.pyでは現在処理しているレスポンスとしてresponseオブジェ
クトが用意されているが、マルチスレッド環境で使うと不都合が生
じる。HTTPResponseを毎回インスタンス化して返却すること。

```python
from bottle import HTTPResponse

r = HTTPResponse(status=200)
r.set_header('Content-Type', 'application/json')
 :
r.body = json.dumps(result_dict, ensure_ascii=False)
return r
```

ToDoアプリのチュートリアル
<http://nagaetty.blogspot.jp/2013/02/to-do.html>

ファイル名でルーティングする場合の例

```python
@get('<:re:.*/><filename:re:.*\.(jpg|png|gif|ico)>')
def server_images(filename):
  return static_file(filename, root=here('./static/img'))

@get('<:re:.*/><filename:re:.*\.(eot|ttf|woff|svg)>')
def server_fonts(filename):
  return static_file(filename, root=here('./static/fonts'))
```

一覧を得る場合

```python
param: {
  "cmd": "get",
  "limit": 100,
  "selected": [],
  "offset": 0
}
SELECT * FROM users WHERE 1=1 ORDER BY 1 LIMIT 100 OFFSET 0
```

特定のレコードを取る場合

```python
getRecord()
param: {
  "cmd": "get",
  "recid": "4"
}
SELECT userid, fname, lname, email, login, password FROM users WHERE userid = ?
```

保存する場合

```python
saveRecord()
param: {
  "cmd": "get",
  "limit": 100,
  "selected": [],
  "offset": 0
}
UPDATE users SET lname=?,login=?,password=?,email=?,fname=? WHERE userid = ?
```

削除する場合

```python
deleteRecords()
DELETE FROM users WHERE userid IN (?)
param: {
  "cmd": "delete",
  "limit": 100,
  "selected": [
    9
  ],
  "offset": 0
}

  if cmd == 'get-records':
    sql = "SELECT * FROM users WHERE ~search~ ORDER BY ~sort~"
    data = usersDb.getRecords(sql, param)
    return data


    sql = "SELECT * FROM users WHERE 1=1 ORDER BY 1 LIMIT 100 OFFSET 0"
    cql = "SELECT count(1) FROM (SELECT * FROM users WHERE 1=1 ORDER BY 1)"
    try:
      cursor = conn.cursor()
      # レコード数を数える
      cursor.execute(cql, [])
      data['status'] = 'success'
      data['total'] = cursor.fetchone()[0]

      # sql文を実行する
      data['records'] = []
      rows = cursor.execute(sql, [])
      columns = [ d[0] for d in cursor.description ] # 最後に実行したSQL文のカラム名を配列で得る
      columns[0] = "recid"
      for row in rows:
        record = zip(columns, list(row))
        data['records'].append( dict(record) )
    except Exception as e:
      data['status'] = 'error'
      data['message'] = '%s\n%s' % (e, sql)
    return data
```
