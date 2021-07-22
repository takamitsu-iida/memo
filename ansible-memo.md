# Ansibleメモ

ここではansibleを使う上での実験的な内容を記します。

<br><br>

# チートシート

## インベントリパラメータ

- ansible_ssh_host
- ansible_ssh_port
- ansible_ssh_user
- ansible_ssh_pass
- ansible_sudo_pass
- ansible_connection
- ansible_ssh_private_key_file
- ansible_python_interpreter

## ビルトインパラメータ

- hostvars (e.g. hostvars[other.example.com][...])
- group_names (groups containing current host)
- groups (all groups and hosts in the inventory)
- inventory_hostname (current host as in inventory)
- inventory_hostname_short (first component of inventory_hostname)
- play_hosts (hostnames in scope for current play)
- inventory_dir (location of the inventory)
- inventoty_file (name of the inventory)

## Facts

```bash
ansible hostname -m setup
```

- ansible_distribution
- ansible_distribution_release
- ansible_distribution_version
- ansible_fqdn
- ansible_hostname
- ansible_os_family
- ansible_pkg_mgr
- ansible_default_ipv4.address
- ansible_default_ipv6.address

## Filter

- {{ var | to_nice_json }}
- {{ var | to_json }}
- {{ var | from_json }}
- {{ var | to_nice_yml }}
- {{ var | to_yml }}
- {{ var | from_yml }}
- {{ result | failed }}
- {{ result | changed }}
- {{ result | success }}
- {{ result | skipped }}
- {{ var | manditory }}
- {{ var | default(5) }}
- {{ list1 | unique }}
- {{ list1 | union(list2) }}
- {{ list1 | intersect(list2) }}
- {{ list1 | difference(list2) }}
- {{ list1 | symmetric_difference(list2) }}
- {{ ver1 | version_compare(ver2, operator='>=', strict=True }}
- {{ list | random }}
- {{ number | random }}
- {{ number | random(start=1, step=10) }}
- {{ list | join(" ") }}
- {{ path | basename }}
- {{ path | dirname }}
- {{ path | expanduser }}
- {{ path | realpath }}
- {{ var | b64decode }}
- {{ var | b64encode }}
- {{ filename | md5 }}
- {{ var | bool }}
- {{ var | int }}
- {{ var | quote }}
- {{ var | md5 }}
- {{ var | fileglob }}
- {{ var | match }}
- {{ var | search }}
- {{ var | regex }}
- {{ var | regexp_replace('from', 'to' )}}

## Lookup

制御ノード上でファイルを開いて中身を取り出すときにつかう。

- {{ lookup('file', '/etc/foo.txt') }}
- {{ lookup('password', '/tmp/passwordfile length=20 chars=ascii_letters,digits') }}
- {{ lookup('env','HOME') }}
- {{ lookup('pipe','date') }}
- {{ lookup('redis_kv', 'redis://localhost:6379,somekey') }}
- {{ lookup('dnstxt', 'example.com') }}
- {{ lookup('template', './some_template.j2') }}

<br><br>

# 個人的コーディング規約

## 文字コードと改行

改行コードはLF(\n)、文字コードはUTF-8で統一すること。
Windowsの改行コードはCRLFなのでWindowsでVisual Studio Codeを使うときには特に気をつけること。

## YAMLの先頭は`---`と１行の空白で始めること

空行を入れない派もいるけど、入れたほうが見栄えがよい。

```yml
---

# 一行空白を入れる
```

## 真偽値はtrue/false

もともとのYAMLの仕様ではこれらが真偽値として扱われる。
<http://yaml.org/type/bool.html>

```none
Regexp:
  y|Y|yes|Yes|YES|n|N|no|No|NO
  |true|True|TRUE|false|False|FALSE
  |on|On|ON|off|Off|OFF
```

流派が多すぎてどれに従えばいいかわからないけど、個人的に好きなのはtrue/false。

Ansibleはpython製なのでTrue/Falseが良さそうだけど、YAML文書の中では見栄えが悪くなるので、一番無難そうなtrue/falseで統一する。

```yml
# Good
gather_facts: false

# Good ? or Bad ?
become: yes
```

## コメントの#の後ろにスペースを入れること

```yml
# Good

#Bad
```

## コメントは行頭ではなくインデントして付けること

```yml
# Good
ios_command:
  commands:
    # - show ip route
    - show version

# Bad
ios_command:
  commands:
#    - show ip route
    - show version
```

## whenの位置はアクションの後ろ側

whenはtrueのときに実行されるので、
**do something when this condition is met**
と考えるのが自然で、プレイブックもその順序で書いたほうがいい。

```yml
# Good
- name: コマンドを打ち込む
  ios_command:
    commands:
      - show ip route
  when:
    - r is success

# Bad
- name
  when:
    - r is success
  ios_command:
    - show ip route
```

## {{}}の中にはスペースを入れる

```yaml
# Good
{{ r.stdout[0] }}

# Bad
{{r.stdout[0]}}
```

# YAMLにおける複数行の文字列

よく使うのは `|` と `>-`

`|` は書いたとおりになる。

`>-` は1行のコマンドにしたいけど横に長く書くのは嫌なときに使う。

## 各行の改行をそのまま保存

```yml
text1: |
  aaa
  bbb
  ccc
```

## 各行の改行と最終行に続く改行を保存

```yml
text1: |+
  aaa
  bbb
  ccc
```

## 各行の改行は保存するが、最終行の改行は削除

```yml
text1: |-
  aaa
  bbb
  ccc
```

## 改行を半角スペースに置き換えて１行にしつつ、最終行の改行は保存

```yml
text1: >
  aaa
  bbb
  ccc
```

## 改行を半角スペースに置き換えて１行にしつつ、最終行に続く改行は保存

```yml
text1: >+
  aaa
  bbb
  ccc
```

## 改行を半角スペースに置き換えて１行にしつつ、最終の改行を取り除く

```yml
text1: >-
  aaa
  bbb
  ccc
```

<br><br>

# serialとfork

同時実行の制御は誤解しやすく、またすぐに忘れてしまう。

インベントリの中から一度に何台の対象装置を取り出すか、を指定するのがserialパラメータ。
デフォルトは0になっているので、一度にすべての対象装置をインベントリから取り出してくる。
取り出した対象装置に対してプレイが終わると、次の対象装置を取り出して、同じプレイを実行する。

プレイブックの中でプレイ単位に指定できる。
前段のプレイはserial=0で、後段のプレイはserial=1にする、といったことも可能。

同時に実行するのは1台だけ、と言われたらserialを1に設定する。
これはよくあるケースだと思う。

対象装置が1,000台あって同時には10台に実行したい、という場合はforkを10にした方がいい。
serialを10にした場合は、

1. インベントリから10台取り出す
1. PLAY [プレイ名] ****************************************
1. 10台にプレイを実行する
1. 終わったら次の10台をインベントリから取り出す
1. PLAY [プレイ名] ****************************************
1. 10台にプレイを実行する
1. 以下繰り返し

という動きをする。
画面をみていると、同じPLAYが何度もでてくることになる。

このPLAYの切替時に何か処理をフックできればおもしろい使い方ができそうだけどな。
10%終わりました、20%終わりました、みたいなのをosx_sayで喋らせる、なんてことができたら有用だと思う。

結局、serialは0(デフォルト)か1を指定するものだと思っておけばいい。
1台づつ順番に実行するときはserialを1にする。
そうでなければデフォルトのままにして、インベントリからの対象装置の取り出しは一度に全部やればいい。

取り出された対象装置に対して同時にタスクを処理する数がforkで、デフォルトは5になっている。
ansible.cfgで設定する。
プレイ単位では変えられない。

スレッドプールのことだと思うので、むやみに大きくすると逆に重くてなりすぎてしまうけど、
fork 5というのは小さすぎる気がするので、10くらいに増やしておいてもいいかも。

<br><br>

# ansible.cfgの探索順序

次の順番でansible.cfgを探す。

- 環境変数 ANSIBLE_CONFIG
- カレントディレクトリの ansible.cfg
- ~/.ansible.cfg
- /etc/ansible/ansible.cfg

<br><br>

# シェルスクリプトでの実行

cronで実行するならシェルスクリプトにするとよい。
ansible.cfgを読み込ませるために環境変数を使う。

```bash
#!/bin/bash

export ANSIBLE_CONFIG="~/git/internal/i-ansible-labo/ansible.cfg"

pb=${1:-site.yml}

ansible-playbook $pb
```

<br><br>

# コマンドタイムアウト

コマンドタイムアウトの値はansible.cfgに設定する。

```ini
[persistent_connection]

# コマンドの応答が返ってくるまでの時間
# デフォルトは10秒
# 通常は10秒で問題ない
# show techやファイルコピー操作をするときはこれを大きくすること
command_timeout = 10
# command_timeout = 180
```

コンフィグの流し込みやファイルのコピーのような操作をするときには、この値を大きくしないと失敗する。

タスクごとにこの値を変えたいが、どうやってもできなそう。

タイムアウトの値はtask_executor.pyが読み込んだ時点で決定される。一度設定値を読んでしまうとそれがコネクションプラグインの中にキャッシュされてしまうため、後から変更しようとしてもできない。

task_executor.py

```python
  self._play_context.timeout = connection.get_option('persistent_command_timeout')
```

<br><br>

# 動的に対象を決める

やり方は複数ある。

プレイブックはリスト形式なので、最初のプレイで対象ホストの情報をadd_hostして、それをつかって次のプレイを実行すればよい。

以下は固定で埋め込んでいるけど、外部からファイルで読んだり、何かスクリプトを走らせた結果をもらってもよい。

```yaml

- hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: add target
      add_host:
        name: TEST_ROUTER
        ansible_host: 127.0.0.1
        ansible_port: 2222
        ansible_network_os: ios
        ansible_user: vagrant
        ansible_password: vagrant
        ansible_ssh_common_args: ""
      no_log: false

- hosts: TEST_ROUTER
  connection: network_cli
  gather_facts: false
```

<br><br>

# 共通の戻り値

マジック変数と同じく暗黙の了解的に使われている戻り値の一覧。

<https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html#common-return-values>

必ず知っておきたいのはこれらくらいかな。

- rc
- changed
- failed
- results
- stdout
- stdout_lines

注意事項。

resultsはループしたときしか使われない。

stdoutは配列なのに複数形じゃないのが気に入らない。

<br><br>

# ios_commandモジュールにループを適用すると期待と動作が違う

これは意外だった。

以下はgig1〜4がすべてupするまで待機するプレイブック。
期待通りに動作する。

```jinja2
  vars:
    cmds:
      - show interface GigabitEthernet1 | inc line protocol is
      - show interface GigabitEthernet2 | inc line protocol is
      - show interface GigabitEthernet3 | inc line protocol is
      - show interface GigabitEthernet4 | inc line protocol is

  tasks:

    - name: 指定のインタフェースが全てupしているか確認
      ios_command:
        commands: "{{ cmds }}"
      register: r
      until: (r.stdout | map('regex_replace', '.* line protocol is (.*)', '\\1') | join(' ')).find('down') == -1
      retries: 100
      delay: 10
```

ところがループを使ってしまうと期待とは異なる動作になる。

```jinja2
  vars:
    target:
      - GigabitEthernet1
      - GigabitEthernet2
      - GigabitEthernet3
      - GigabitEthernet4

  tasks:

    - name: 指定のインタフェースが全てupしているか確認
      ios_command:
        commands:
          - show interface {{ item }} | inc line protocol is
      with_items: "{{ cmds }}"
      register: r
      until: (r.stdout | map('regex_replace', '.* line protocol is (.*)', '\\1') | join(' ')).find('down') == -1
      retries: 100
      delay: 10
```

これ、動くことには変わらないのだけど、例えばGig3がdownしていてそこで判定がNGだったとすると、繰り返すのはGig3だけになってしまう。Gig3がupになるまで延々と待ち続け、Gig3がupすると今度はGig4の判定に移る。
4個のインタフェースを同時に判定しているわけではなく、一つずつupかdownかを判定してしまう。
したがって、Gig4の判定がupで完了したときに、Gig1が本当にupしているのか、定かではないのである。

**「インタフェースが全てアップしているか」** を判定するなら、前者の書き方でなければならない。

<br><br>

# Ansibleでのフィルタ操作と条件判定

これが難関。

プログラム言語じゃないのに条件判定をしようとするわけだから、さすがに無理がでるのも仕方ないけど、それにしても難しい。

ちょっと込み入ったことを判定しようとすると、可読性ナッシングのとんでもなく長い行になってしまう。
Pythonでフィルタを書くのは簡単なので、可読性がないな、と思ったら迷わずフィルタを作った方が良さそう。

Ansibleのフィルタ

<https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html>

Ansibleの条件判定

<https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html>

jinja2の組み込みフィルタ

<https://jinja.readthedocs.io/en/latest/templates.html#list-of-builtin-filters>

## **select** と **match**

リストの中から正規表現に合致するものだけを取り出す。

selectはイテレータを返すのでlistで結果を配列にする。

```jinja2
"{{ 配列 | select('match', 'GigabitEthernet[1-3]') | list }}"
```

## **selectattr** と **match**

selectattrはキーが○○という状態のものを取り出す。
○○はいろいろできて、jinja2のマニュアルにある。

```jinja2
selectattr('キー', 'match', 'GigabitEthernet[1-3])

selectattr('キー', 'defined')

selectattr('キー', 'equalto', true)
```

## **+** で配列を結合

配列と配列を結合したい場合は `+` で連結する。

```jinja2
"{{ 配列 + ['GigabitEthernet5'] }}"
```

別の配列にコピーするときには、ループで回しながら追加する。

```jinja2
with_items: "{{ ansible_net_interfaces | sort }}"
set_fact:
  intf_names: "{{ intf_names + [item] }}"
```

## **map** でリストを順番に処理する

mapは使い方が複数あるので難しい。

基本は配列をとって、配列の中身に対して一つずつ関数を呼び出して処理をするもの。upper関数を通すなら、こうする。

```jinja2
"{{ 配列 | map('upper') | list }}"
```

mapはイテレータを返すのでlistで結果を配列にする。

配列を一つづつ取り出して、それをregex_replaceで書き換えて、空白区切りで連結して、その文字列の中に'down'が入っているかどうかをチェックするならこうする。

```jinja2
register: r
until: (r.stdout | map('regex_replace', '.* line protocol is (.*)', '\\1') | join(' ')).find('down') == -1
```

regex_replace で使う `\\1` は後方参照。１つ目の（）の中を取り出すときの表現。regex_searchではこの表現は使えなかったりするので要注意。

特定のキーの値だけを取り出すなら`attribute=`を使う。

```jinja2
"{{ 配列 | map(attribute='キー') | list}}"
```

## 試したほうが早そうなので

vars_example.ymlを実行して結果がどうなるかを確認したほうが理解できる。

<br><br>

# モジュールを作らないと実現できないこと

Ansibleはリアルタイムに情報を表示できない。

たとえばシスコルータに乗り込んで1秒ごとに

```bash
show process cpu | include CPU
```

を打ち込みたい、というニーズをAnsibleで満たすのは難しい。

`include_tasks` はタスクからタスクへの推移にかなり時間がかかるため、1秒ごとに、を満たすことができない。

またリアルタイムに情報を出すこともできない。

が、独自モジュールを作ればなんとかなる。
画面表示ではなくファイルに追記するようにして `tail -f` で表示すればよい。
コマンドを１秒ごとに打ち込む、という部分もモジュールとして実装すればよい。

実際にモジュールを作ってやってみた結果。

![repeat_ios_cmd](/uploads/8d7e2f51acb767f5e100167bf6fce140/repeat_ios_cmd.gif)

これがあると便利。
シスコルータのフラッシュメモリにIOSイメージを転送するときなんかも、これを使って転送状況を確認するといい。

<br><br>

# debugモジュールのvarとmsg

これをちゃんと理解しておかないと後々困ることになる。

表示したいものが **文字列** の場合はmsgを使う。
変数の中に格納されている内容を文字列として扱いたいなら、jinja2形式で展開しないといけない。

```yml
- debug: msg="{{ result.stdout[0] }}"
```

表示したいものが **辞書型** で中に何が入っているかわからないときはvarを使う。

```yml
- debug: var=result
```

辞書型の変数はjinja2では展開できないので、これ（↓）は間違い。

```yml
- debug: var="{{ result }}"
```

文字列として表示したいんだけど、配列に格納されてしまっている。
ios_commandモジュールで複数のコマンドを打ち込んだときがそう。
そんなときはループを使う。

```yml
- name: 結果を表示する
  with_items: result.stdout
  debug: msg="{{ item }}"
```

見た目が汚くていいならresultオブジェクトをvarで表示しちゃってもいいんだけど。

<br><br>

# debugモジュールで画面表示したときに"\n"ではなく改行する設定

ansibleの画面表示はcallbackプラグインで実現していて、表示形式は選べるようになっている。

ansible.cfgの[defaults]セクションで以下のように設定する。
デフォルトは`skippy`になっているので、それをdebugに変更すると改行がエスケープされずに見栄え良く表示される。

この設定は効果絶大なのでオススメ。

```ini
[defaults]
# stdoutの文字列を"\n"ではなく改行として表示する設定
stdout_callback = debug
```

この設定を使わずに力技で改行表示するなら、表示したいものを一度変数に格納して、'\n'でsplitする。

```yml
- name: DEBUG show system infoを表示
  vars:
    msg: |
      [show system info]
      {{ sysinfo }}
  debug:
    msg: "{{ msg.split('\n')}}"
```

こんなやり方もあるけど、さすがにやりすぎ感がある。

```yml
- set_fact:
    str: |
      {% for stdout in r.stdout %}
      {{ stdout }}
      {% endfor -%}

- set_fact:
    result: "{{ str | trim }}"

- debug:
    msg: "{{ result }}"
```

<br><br>

# 複数のタスクを繰り返す場合

別ファイルでタスクを作って、include_tasksを繰り返す。

`task.yml`

```yml
- name: send command
  ios_command:
    commands:
      - show ver

- name: save log
  template:
    src: ./templates/show_ver.j2
    dest: ./log/show_ver_{{ host }}.log
```

実行するプレイブックでこのようにする。

```yml
- include_tasks: task.yml
  with_items:
    - r1
    - r2
  loop_control:
    loop_var: host
```

このやり方は実行時にプレイブックをその数だけ展開する。

<br><br>

# コマンド応答待ちのタイムアウト値

コマンドを打ち込んで応答が戻ってくるまでのタイムアウトは10秒に設定されている。
期待した応答がその時間内に来ないとコネクションごと切れるという乱暴な仕様になっている。
show techやファイルコピーのような長い時間かかる処理ではこれを伸ばさなければいけない。

network_cli.py のソースコードにはこのように書いてある。

```yml
  persistent_command_timeout:
    type: int
    description:
      - Configures, in seconds, the amount of time to wait for a command to
        return from the remote device.  If this timer is exceeded before the
        command returns, the connection plugin will raise an exception and
        close
    default: 10
    ini:
      - section: persistent_connection
        key: command_timeout
    env:
      - name: ANSIBLE_PERSISTENT_COMMAND_TIMEOUT
```

環境変数で設定するか、ansible.cfgの中で設定するしかない。
ホストごととか、タスクごとに設定できないので、かなり不便。

<br><br>

# Cisco機器の再起動

Ciscoのreloadコマンドは場合によって２度、問い合わせが発生する。
設定を保存する？という問い合わせと、本当にreloadする？という問い合わせ。

ansibleはこの２度連続で聞かれるケースに弱い。
というか対処方法がないので、事前にwrite memoryして問い合わせが２度発生しないようにする。

Cisco機器をreloadするとSSHコネクションが切れてしまう。
reloadコマンドを打ち込むだけなら簡単だけど、ちゃんと装置が立ち上がったことを確認したい。
この接続確認は踏み台を踏む場合と、直接通信する場合とでやり方が違うので要注意。

ルータ起動直後はSSHのポートが開いても、実際にはまだログインできない。
そのためwait_forタスクが完了しても、追加で待ち時間を入れなければいけない。

```yml
---
#
# Ciscoルータをreloaｄします
#
# 2018/07/02 初版
#
# Takamitsu IIDA (@takamitsu-iida)

- name: execute reload command on cisco devices
  hosts: 18f_routers
  gather_facts: False

  tasks:

    - name: running-configに変更があれば保存する
      ios_config:
        save_when: modified

    #
    # reloadコマンドを送るとその後は応答が返ってこないため、ios_commandモジュールは失敗する。
    # ansible.cfgでcommand_timeoutを長く設定していると、無駄な待ちが生じる。
    #
    - name: send reload command
      ios_command:
        commands:
          - command: reload
            prompt: '[confirm]'
            answer: y
      ignore_errors: True
      # 非同期にしても意味はない。
      # async: 1
      # poll: 0

    #
    # SSHがダウンして再びアップするまで待つ(踏み台経由の環境で実行する場合)
    #
    - name: wait for ssh down (bia bastion)
      delegate_to: pg04
      wait_for: host="{{ansible_host}}" port=22 state=stopped delay=10
      when: lookup('env', 'ansible_ssh_common_args')

    - name: wait for ssh up (bia bastion)
      delegate_to: pg04
      wait_for: host="{{ansible_host}}" port=22 state=started delay=30
      when: lookup('env', 'ansible_ssh_common_args')

    #
    # SSHがダウンして再びアップするまで待つ(直接接続できる環境で実行する場合)
    #
    - name: wait for ssh down (local_action)
      local_action: wait_for host="{{ansible_host}}" port=22 state=stopped delay=10
      when: not lookup('env', 'ansible_ssh_common_args')

    - name: wait for ssh up (local_action)
      local_action: wait_for host="{{ansible_host}}" port=22 state=started delay=30
      when: not lookup('env', 'ansible_ssh_common_args')

    #
    # ルータ起動直後は22番ポート(SSH)が開いてもログインできるわけではないので追加で待ちを入れる
    #

    - name: sleep for 30 seconds and continue with play
      local_action: wait_for timeout=30

    #
    # ルータに乗り込んでpingが通るか確認
    #
    - name: ping
      ios_command:
        commands:
          - ping 172.20.0.1
      register: ping_result
      failed_when: not '!' in ping_result.stdout[0]

    - debug: msg={{ping_result.stdout[0]}}
```

2台のルータを同時に再起動し、起動後にpingを打ち込む例。
この例では直接接続できない環境のため踏み台になっているpg04で22番ポートが開くかどうかを確認している。

```bash
iida-macbook-pro:i-ansible-labo iida$ ansible-playbook cisco_reload.yml

PLAY [execute reload command on cisco devices] *******************************************

TASK [running-configに変更があれば保存する] *********************************************************
ok: [r12]
ok: [r13]

TASK [send reload command] ***************************************************************
ok: [r12]
ok: [r13]

TASK [wait for ssh down (bia bastion)] ***************************************************
ok: [r13 -> 10.35.158.20]
ok: [r12 -> 10.35.158.20]

TASK [wait for ssh up (bia bastion)] *****************************************************
ok: [r12 -> 10.35.158.20]
ok: [r13 -> 10.35.158.20]

TASK [wait for ssh down (local_action)] **************************************************
skipping: [r12]
skipping: [r13]

TASK [wait for ssh up (local_action)] ****************************************************
skipping: [r12]
skipping: [r13]

TASK [sleep for 30 seconds and continue with play] ***************************************
ok: [r12 -> localhost]
ok: [r13 -> localhost]

TASK [ping] ******************************************************************************
ok: [r12]
ok: [r13]

TASK [debug] *****************************************************************************
ok: [r13] => {}

MSG:

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.20.0.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/2/4 ms

ok: [r12] => {}

MSG:

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.20.0.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms


PLAY RECAP *******************************************************************************
r12                        : ok=7    changed=0    unreachable=0    failed=0
r13                        : ok=7    changed=0    unreachable=0    failed=0

iida-macbook-pro:i-ansible-labo iida$
```

<br><br>

# デバッガ

<https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html#playbook-debugger>

```ini
  # デバッガ  always/never/on_failed/on_unreachable/on_skipped
  # debugger: always
```

主にpとcを使う。

あまり便利な印象はない。

<br><br>

# jinja2のテンプレートがどう展開されるのかテストしたい場合

templateモジュールをローカルマシンで実行して試すのが簡単。

```bash
ansible all -i localhost, -c local -m template -a "src=test.j2 dest=./test.txt" --extra-vars=@group_vars/all.yml
```

プレイブックの中で変数として取り出すなら、マニュアルにある通りlookupプラグインで取り出せばよい。

```yml
- name: show templating results
  debug: msg="{{ lookup('template', './some_template.j2') }}
```

<https://docs.ansible.com/ansible/2.5/plugins/lookup/template.html#examples>

<br><br>

# マジック変数

定義せずとも使える変数をマジック変数と呼ぶ。
一覧はここ。

<https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html>

マジック変数はplaybookを実行しているターゲットマシン毎に値がセットされる。
`inventory_hostname` はファイルに保存するときのファイル名としてもよく使う。

|変数名|内容|
|:----|:--|
|group_names|このターゲットマシンが属する全グループの一覧|
|groups|指定したグループに属しているマシンの一覧。例　groups['routers']|
|inventory_hostname|インベントリに書かれたホスト名|
|inventory_hostname_short|inventory_hostnameの最初の "." まで|
|play_hosts|Playbookが適用されるホスト一覧|
|inventory_dir|インベントリファイルのあるディレクトリパス|
|inventory_file|インベントリファイルのベース名|

マジック変数はプレイブックの中で取り出せる。

```jinja
{% for host in groups['ios_routers'] %}
```

<br><br>

# 踏み台経由の実行

踏み台はbastionとかjump hostと呼ばれる。

インベントリファイルもしくは該当のgroup_varsに以下を指定する。
踏み台への接続にパスワードは指定できないので鍵認証で接続できるようにしておくこと。

```.bashrc
ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q admin@10.35.158.20"'
```

ansibleを実行する機器によって踏み台を踏む、踏まないがあるのであれば、環境変数に情報を移してしまった方がよい。

.bashrcで以下を設定

```bash
# ansible
export ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q admin@10.35.158.20"'
```

インベントリのgroup_varsで以下を設定する。

```yml
# 踏み台経由で実行するためのSSH設定
ansible_ssh_common_args: "{{ lookup('env','ansible_ssh_common_args') }}"
```

lookupモジュールで環境変数を取り出して、その値をansible_ssh_common_argsに設定しているだけ。環境変数が設定されていなければlookupモジュールから空文字列""が返ってくるので、踏み台は踏まずに直接通信することになる。

<br><br>

# ios_commandやios_factsはシスコ機器にどんなコマンドを打ち込んでるのか？

シスコ機器を操作するios_commandやios_factsモジュールは装置に乗り込んでどんなコマンドを打っているのか確認するには、装置に乗り込んで`show history all`を叩けばいい。

```none
show history all
```

このコマンドは装置が起動してからの全てのコマンド入力の履歴を表示する。
ansibleは思ったよりもたくさんコマンドを叩いているので、一度確認してみるとよい。

<br><br>

# logディレクトリがなければ作る

プレイブックの中で対処するならこうする。

```yml
pre_tasks:
  - name: create log directory if not found
    local_action:
      module: file
      path: ./log
      state: directory
      mode: 0755
    run_once: True
```

プレイブックをgitで管理するなら、最初からlogディレクトリを作っておいて.gitkeepというファイルを作ってgitの管理対象にしてしまえばいい。
.gitignoreファイルでlogディレクトリは無視しているので、それを強制的にgitの管理対象にする。

```bash
mkdir log
touch log/.gitkeep
git add -f log/.gitkeep
```

<br><br>

# フィルタの動作が挙動不審？

regex_searchやregex_replaceなど、正規表現を使ったフィルタはどうにもこうにも挙動不審なことがある。そんなときはマニュアルよりもソースコードを見てしまったほうが早い。

<https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/filter/core.py>

引数に取れるのはmultilineとignorecaseのみ。

後方参照を使うときには明示的にグループ名を付けること。
ウェブによく例として書かれている `\\1` なんかはregex_searchには通じない。regex_replaceなら動く。

```yml
   - set_fact:
        available_memory: "{{ r | regex_search('(?P<mem>\\d+) bytes available', '\\g<mem>', multiline=True) }}"
```

<br><br>

# playbookのアトリビュート

- **name** 任意の文字列。コメントのつもりで日本語で書いてしまったほうがいい。

- **hosts** 対象機器のインベントリ名。グループもしくホスト。コンマで区切って並べる。

- **tasks** タスクの配列。

- **pre_tasks**

- **post_tasks**

- **notify** タスクがchangedになった場合に呼び出すhandlersを指定する。配列でもよい。

- **handlers** タスクのリストを指定する。tasksと同列に書く。notifyと連動。

- **roles** 大きめのプレイブックを作るときにはロールに分割した方が見通しがよい。

- **serial** hostsを何台ごとにplayの処理を区切るか。デフォルトは0、すなわち区切りなし。

- **max_fail_percentage** デフォルトは100、対象ホストの何％が失敗したら停止するか。serialが指定されている場合は、そのserialの台数に対してのパーセンテージになる。

- **run_once** 対象を1台に限定し、さらに1回しか実行しない。対象が複数あるときはリストの先頭に対して実行する。local_actionのときによく使う。

- **gather_facts** factsの収集をするか。ansible.cfgで[defaults] gathering=で指定するのと同じ。ansibleで時刻を取得したいときはこれをTrueにすると時刻情報を収集してくれる。

- **register** 実行結果を保存する変数。変数となる任意の文字列を指定する。実行結果をregisterした後、 **set_facts** で加工した結果を保存するのがよくあるパターン。

- **vars** 変数の定義。ディクショナリを指定する。

- **vars_prompt** 人間に入力させる変数。

- **remote_user** インベントリでansible_ssh_userを指定するので**通常は使わない**。ansible.cfgで[defaults] remote_user 指定するのと同じ。

- **port** どのポート番号で接続するか。指定しなければ22が使われる。ansible.cfgで[defaults] remote_port指定するのと同じ。

- **become** True/Falseを指定。デフォルトはFalse。ansible.cfgで[privilege_escalation] become指定するのと同じ。

- **become_method** "sudo", "su", "pbrun", "pfexec", "runas"のどれか。ansible.cfgで[privilege_escalation] become_method指定するのと同じ。

- **become_user** 接続したユーザ名以外でどのユーザに変更するか。ansible.cfgで[privilege_escalation] become_user指定するのと同じ。

- **changed_when** 条件式、あるいはそのリストを指定する。指定した条件式が真の場合にのみ、taskの実行結果をchangedにする。

- **failed_when** 条件式、あるいはそのリストを指定する。指定した条件式が真の場合にのみ、taskの実行結果をfailedにする。

- **when** 条件式、あるいはそのリストを指定する。指定した条件式が真の場合にのみ、taskを実行する。when系はjinja2形式が前提になっているので `"{{ }}"` は書かないこと。

- **tag** コマンドラインでプレイブックを起動するときに、どのtaskを動作させるかを制御するタグ。playに指定するとplay内のすべてのtaskにそれらのタグが追加される。--tags(-t)オプションで指定したタグ（カンマ区切りで複数指定できる）のどれかとtaskのタグのどれかが一致した場合のみこのtaskは実行される。また--skip-tagsオプションで指定したタグ（こちらもカンマ区切りで複数指定できる）のどれかとtaskのタグのどれかが一致した場合にはこのtaskは実行されない。--tagsオプションにも--skip-tagsオプションにもtaskのタグのどれかが一致した場合は実行されない。

- **until** 条件式、あるいはそのリストを指定する。指定した条件式が真になるかretriesの回数だけ試行を繰り返す。registerが必須。

- **retries** untilの条件を満たすまでに最大何回まで試行するか。デフォルトは3

- **delay** untilの条件を満たすまでの試行の間に何秒間スリープするか。デフォルトは5

- **async** taskを非同期モードで実行し、何秒待つかを指定する。デフォルトは0、つまり無効。装置を再起動したときに、装置が起動して接続できるようになるまで待機するような場面で使う。

- **poll** asyncを使って非同期モードで実行しているtaskが完了しているかどうかを何秒ごとに確認するか。デフォルトは10

- **no_log** パスワードのような文字列が表示されるとまずい場合に使用する。デフォルトはFalse

- **first_available_path** ファイルのパスのリストを指定すると最初に見つかったファイルのパスをcopyモジュールやtemplateモジュールのsrcに渡す。

<br><br>

# 機器に設定を投入する例

投入する設定はgroup_varsやhost_varsに退避しておき、それを読み取って流し込む。

`group_vars`

switches.yml はインベントリグループswitchesに適用される。

```yml
---
vlans:
  - { vlan_id: 15, name: voice15}
  - { vlan_id: 55, name: data55}
```

core.yml はインベントリグループcoreに適用される。

```yml
---
svi_int:
  - name: vlan15
    ip: "{{ vlan15.ip }}"   # host_varから読み取る
    mask: 255.255.255.0
    vip: 10.0.15.252
    pri: "{{ vlan15.pri }}" # host_varから読み取る
```

`host_vars`

core_sw_01.yml はインベントリホストcore_sw_01に対して適用される。

```yml
---
vlan15:
  ip: 10.0.15.252
  pri: 110
```

core_sw_02.yml はインベントリホストcore_sw_02に対して適用される。

```yml
---
vlan15:
  ip: 10.0.15.253
  pri: 90
```

変数を使った例。ios_configモジュールを使ったタスク。

```yml
tasks:
  - name: create vlans
    ios_config:
      lines: name {{ item.name }}
      parents: vlan {{ item.vlan_id }}
    with_items: "{{ vlans }}"

  - name: switch virtual interface
    ios_config:
      lines:
        - ip add {{ item.ip }} {{ item.mask }}
        - delay 200
      parents: interface {{ item.name }}
    with_items: "{{ svi_int }}"
```

<br><br>

# jinja2

## `{{ ... }}`

ステートメント

```jinja
"私の名前は {{ name }} です"
```

プレイブックの中で `set_fact` や `register` した変数がそのまま使える。

## `{% ... %}`

式

```jinja
{% set text='abc' %}
{{ text }}
```

## `{# ... #}`

コメント

## `{% if %}`

```jinja
{% if x > 0 %}
xは正です
{% elif x == 0 %}
xはゼロです
{% else %}
xは負です
{% endif %}
```

## `{% for %}`

```jinja
一覧表示
{% for item in items %}
  {{ item }}
{% endfor %}
```

空行を排除したfor文

```jinja
一覧
{% for item in items -%}
  {{ item }}
{% endfor %}
```

## `|` フィルタ

escapeフィルタはHTMLの特殊文字をエスケープする。

```jinja
{% for itm in items -%}
  {{ item | escape }}
{% endfor %}
```

組み込みフィルタはたくさんあるので、マニュアルを参照。

既存のフィルタで対応が難しいようならpythonで自作すればいい。簡単に作れる。

<br><br>

# whenで使える演算子

条件式で使える演算子はjinja2のもの。

|機能|演算子|利用例|
|:----|:--|:----|
|比較|==, !=, >,<, >=,<=|when: size > 100|
|論理|and, or|when: size > 100 and size < 200|
|真偽値|true, false|when: false|
|含まれる|in, not in|when: name in ['hoge','piyo']|

```yml
when: foo is defined
```

```yml
when: bar is undefined
```

ansible特有の書き方にこんなのもある。

```yml
when: result is failed
```

```yml
when: result is succeeded
```

```yml
when: result is skipped
```

<br><br>

# 実行結果の制御

failedでも次の処理に進めたいときはignore_errorsを指定する。

ただ、これだとfailedであることに変わりないので、ちゃんと成功したのか失敗したのかを制御するにはfailed_whenにする。shellモジュールは戻り値をrcキーの値に格納しているので、実行結果をregisterで変数に保存し、その中身を取り出して判定する。

<br><br>

# macにansibleを入れる

pipを使ってPythonのモジュールとしてインストールすればよい。

```bash
pip install --proxy=http://user:pass@proxy.server:8080 ansible
```

開発版をインストールするなら、インターネットに直接つないでからこれ。

```bash
pip install git+https://github.com/ansible/ansible.git@devel
```

<br><br>

# TextFSMを使う

ansible2.4以降で`network_cli`フィルタが使える。
ただ、これはスペックファイルをYAMLで書かないといけないので難解。

TextFSMを使った`parse_cli_textfsm`の方が便利。

```bash
sudo pip install textfsm
```

ntc-templatesはgithubからダウンロードする。

```bash
git clone https://github.com/networktocode/ntc-templates.git
```

TextFSMを使うなら、ここの解説を一読した方がいい。
<https://pyneng.readthedocs.io/en/latest/book/21_textfsm/index.html#>


<br><br>

# 対象ノードが多数あるときにはset_factの書き方に注意する

対象ノードが多数あるとき、この書き方で`set_fact`をすると処理が重く、コネクションエラーが発生する。

```yml
- set_fact:
```

この書き方であれあ処理が軽い。

```yml
- local_action:
    module: set_fact
```

Wiresharkで通信をみるとどっちの書き方でも変わらないので、単に処理負荷の問題のよう。
対象ノードが多数あるときは`set_fact`の書き方に気をつけるべき。

<br><br>


# モジュールを作る

Developing Modulesの和訳

<http://tzpst.hatenablog.com/entry/2015/07/21/175159>

<br><br>

## モジュールのテスト

モジュールの引数になる情報をJSONファイルにする。

```json
{
  "ANSIBLE_MODULE_ARGS": {
    "source": "hello",
    "target": "world"
  }
}
```

それを作成したモジュールの引数に渡せばよい。

```bash
python my_module.py args.json
```

<br><br>

# 【参考リンク】

## ネットワークベストプラクティス

<http://docs.ansible.com/ansible/latest/network/user_guide/network_best_practices_2.5.html>

## フィルタープラグインの例

<https://github.com/ahes/ansible-filter-plugins>

## CSRとASAの例

ASA
<https://techbloc.net/archives/2360>

IOSXE
<https://techbloc.net/archives/2352>

シスコ機器の設定変更の例
<https://github.com/rynldtbuen/cisco-ansible-lan-switching>

## プレイブックの例たくさん

<https://github.com/vbotka/ansible-examples>
