# JavaScript関連の備忘録

[//]:# (javascript / js / typescript / ユニットテスト / unit test / karma / protractor)

[//]:# (@@@)
# web color 色見本

<http://www.htmq.com/color/index.shtml>

[//]:# (@@@)
# グラデーションの色

ColorBrewer2

<http://colorbrewer2.org/#type=diverging&scheme=PRGn&n=9>

[//]:# (@@@ 2016.12.03)

# d3.jsで大量のデータ配列

データ配列を分割して、ちょっとずつバッチ処理することで、ブラウザが固まることを阻止する。

<https://engineering.mongodb.com/post/digging-into-d3-internals-to-eliminate-jank/>

[//]:# (@@@ 2016.12.02)

# d3.jsで一時的なログ表示

```js
var div = d3.select('body').append('div').style('float', 'left');

function log(message) {
  return function() {
    div.append('p')
      .text(message)
      .style('background', '#ff0')
      .transition()
      .duration(2500)
      .style('opacity', 1e-6)
      .remove();
  };
}

.on('click', log('clicked'))
```

[//]:# (@@@ 2016.11.03)
# gruntでjsファイルを連結

ローカルにインストールするので、プロジェクトの位置まで移動する

```bash
cd ディレクトリ
```

```bash
npm init
```

いろいろ質問されるが基本は全部リターンでいい。
package.json
が作られているのを確認する。

```bash
npm install grunt-contrib-concat -save-dev
npm install grunt-contrib-uglify -save-dev
```

設定ファイル```gruntfile.js```を作る。

```js
module.exports = function (grunt) {
    var pkg = grunt.file.readJSON('package.json');
    grunt.initConfig({
        concat: {
            files: {
                // 元ファイルの指定
                src : 'static/site/js/*.js',
                // 出力ファイルの指定
                dest: 'static/site/js/dist/d3iida.js'
            }
        },

        uglify: {
            dist: {
                files: {
                    // 出力ファイル: 元ファイル
                    'static/site/js/dist/d3iida-min.js': 'static/site/js/dist/d3iida.js'
                }
            }
        }
    });

    // プラグインのロード・デフォルトタスクの登録
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.registerTask('default', ['concat', 'uglify']);
};
```

[//]:# (@@@ 2016.09.21)
# JSONデータをtextareaにバインディングする例

<http://codepen.io/maxbates/pen/AfEHz>

[//]:# (@@@ 2016.09.19)
# angular directiveでエレメントのサイズを得る

```js
  angular.module(moduleName).directive('iidaNxShell', ['$timeout', function($timeout) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        // angularのディレクティブでサイズを得るにはこうする
        var width = element.prop('offsetWidth');
        var height = element.prop('offsetHeight');
```

[//]:# (@@@ 2016.09.14)
# angularでgetter setter を使う

```html
<md-switch ng-model="sc.settingParam.debug" ng-model-options="{ getterSetter: true }" aria-label="Switch debug">
  debug: {{ sc.settingParam.debug }}
</md-switch>
```

```js
// 設定パラメータをまとめたオブジェクト
ctrl.settingParam = {
  // getterとsetterを使うので、view側は以下のように指定する
  // ng-model="ctrl.settingParam.debug"
  // ng-model-options="{ getterSetter: true }"
  debug: function(_) {
    if (arguments.length) {
      svc.debug = _;
    }
    return svc.debug;
  },
  showConf: function(_) {
    if (arguments.length) {
      svc.showConf = _;
    }
    return svc.showConf;
  }
};
```

[//]:# (@@@ 2016.09.11)
# 画面の右側にmd-contentを付ける例

```html
      <!-- メインコンテンツ右側 -->
      <md-content id="main-right" md-component-id="main-right" class="md-whiteframe-3dp" flex-sm="35" flex-gt-sm="30" flex-gt-md="25" layout-align="end start">
        <!-- サービスが保持しているデータ一覧を常時表示する -->
        <h4>users配列</h4>
        <md-list ng-controller="dataController as dataCtrl">
          <md-list-item class="md-2-line" ng-repeat="user in dataCtrl.users" ng-click="null">
            <div class="md-list-item-text" layout="column">
              <h3>{{ user.name }}</h3>
              <h4>{{ user.message }}</h4>
            </div>
            <md-divider></md-divider>
          </md-list-item>
        </md-list>
      </md-content>
      <!-- メインコンテンツ右側・おわり -->
```

[//]:# (@@@)
# AngularJS利用時に役立つChromeプラグイン

Chromeの拡張機能

- angular watchers

を使うと双方向バインディングしている数が分かる。

[//]:# (@@@)
# E2Eテスト

Protractorを使う

## ホームページ

<http://www.protractortest.org/#/>

## 日本語チュートリアル

<http://qiita.com/weed/items/30098f7be2f753580f63>

## インストール

```bash
npm install -g protractor

C:\HOME\iida\git\bottle_rest_practice_1\karma>protractor --version
Version 4.0.4
```

## 実行

コマンドプロンプトを2枚使う。
ひとつ目のコマンドプロンプトにて、

```bash
webdriver-manager update
```

別のコマンドプロンプトから

```bash
protractor conf.js
```

[//]:# (@@@)
# karma

ユニットテストのツール。

## 必要なもの

- node.js
- angular-mocks.js
- angular-sanitize.js

## Karmaクライアントをグローバルにインストール

```bash
npm install -g karma-cli
```

Karmaはアプリルートにインストールするのが推奨されているが、
MACではグローバルにインストールしないと動かなかった。

```bash
npm install -g jasmine-core
npm install -g karma
npm install -g karma-jasmine
npm install -g karma-chrome-launcher
```

## Karmaを初期化する

karma initを実行して問われる質問に答える

- テストフレームワーク jasmine
- Require.jsを使うか no
- ランナーが利用するブラウザ Chrome
- テストに利用するファイル 空白 or static/site/js/*.js
- テスト対象から除外するファイル なし
- コード変更時にテストを再実行するか yes

karma.conf.jsが生成される

```js
    // list of files / patterns to load in the browser
    files: [
      'static/angular-1.5.8/angular-mocks.js',
      'static/angular-1.5.8/angular-sanitize.min.js',
      'static/site/js/*.js',

    ],
```

## specフォルダを作成する

spec/index_spec.jsファイルを作成する

環境変数を設定する

```bash
CHROME_BIN
C:\Program Files\Google\Chrome\Application\chrome.exe
```

index_spec.js

```js
describe('テストの基本', function() {
  beforeEach(function() {
    // 初期化処理
  });

  it('基本テスト', function() {
    expect(1 + 1).toEqual(2);
  });

});
```

- expect(テスト対象コード).toBe(期待する値) オブジェクトが同じか

- expect(テスト対象コード).toEqual(期待する値) 同じ値か

- expect(テスト対象コード).toMatch(正規表現) 正規表現に一致するか

- expect(テスト対象コード).toBeDefined() 定義済みかどうか

- expect(テスト対象コード).toBeNull() nullかどうか

- expect(テスト対象コード).toBeTruthy() trueとみなせる値かどうか

- expect(テスト対象コード).toBeFalsy() falseとみなせる値かどうか

- expect(テスト対象コード).toContain(expect) 期待値expectが配列に含まれるか

- expect(テスト対象コード).toBeLessThan(compare) 比較値compareより小さいか

- expect(テスト対象コード).toBeGreaterThan(compare) 比較値compareより大きいか

- expect(テスト対象コード).toBeCloseTo(compare, precision) 精度precisionに丸めた値が比較値compareと同じか

- expect(テスト対象コード).toThrow() 例外が発生するか

- 否定は .not を間に挟む

expect(1 + 1).not.toEqual(2)

実行はコマンドプロンプトから

```bash
karma start
```

終了は
ctrl-c

## $httpBackendモック

- $httpBackend.when('GET', 'url').respond(obj);  このリクエストが来なくてもOK

- $httpBackend.expect('GET', 'url').respond(obj);  このリクエストが来ないとエラーになる

[//]:# (@@@)
# npmの基本

## グローバルにインストールされたパッケージを全て確認する

```bash
npm ls -g
npm la -g
npm list -g
npm ll -g
```

## パッケージをプロジェクトからアンインストールする

```bash
npm uninstall パッケージ
npm r パッケージ
npm remove パッケージ
npm rm パッケージ
npm un パッケージ
npm unlink パッケージ
```

## パッケージの情報を見る

```bash
npm info パッケージ名
npm view パッケージ名
npm show パッケージ名
```

## package.jsonを生成する

```bash
npm init
```

[//]:# (@@@)
# typescript

## コンパイラのインストール

```bash
npm -g install tsc
```

## 使い方

```bash
tsc src/ts/app.ts --outDir dist/ts
```

## もっと便利な使い方

typescriptをコンパイルするならローカルにgulpをインストールする

```bash
npm install gulp
npm install gulp-typescript
```

gulpfile.jsを以下のように記述する

```js
var gulp = require('gulp');
var typescript = require('gulp-typescript');

// static/site/tsをコンパイルしてstatic/site/jsに展開する
gulp.task('compile:ts', function() {
  return gulp.src(['static/site/ts/*.ts'])
    .pipe(typescript())
    .js
    .pipe(gulp.dest('static/site/js/'));
});

// gulpコマンドで実行するデフォルトタスク
gulp.task('default', ['compile:ts']);
```

[//]:# (@@@)
# eslint

## インストール

```bash
npm -g install eslint
npm -g install eslint-config-google
```

.eslintrc.jsを次のように設定する。

(20190223修正)

```js
// npm -g install eslint
// npm -g install eslint-config-google

module.exports = {
  "extends": ["google"],
  // "installedESLint": true,
  "env": {
    "browser": true,
  },
  "parserOptions": {
    "ecmaVersion": 6,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true,
      "modules": true,
      "experimentalObjectRestSpread": true
    }
  },
  "rules": {
    // インデントは2スペース
    "indent": ["error", 2],

    // 改行コード unix or windows
    "linebreak-style": ["error", "unix"],

    // コメント要否
    "require-jsdoc": ["error", {
      "require": {
        "FunctionDeclaration": false,
        "MethodDefinition": false,
        "ClassDeclaration": false
      }
    }],

    // 無視する設定
    "max-len": "off",
    "dot-notation": "off",
    "camelcase": "off"

  }
};
```

[//]:# (@@@)
# angularでドラッグドロップする例

<http://marceljuenemann.github.io/angular-drag-and-drop-lists/demo/#>

[//]:# (@@@)
# md-cardの中にチェックボックスを綺麗に並べる例

## HTMLの記述

```html
<md-card>
  <div layout="row" layout-wrap class="checkboxes">
    <md-checkbox ng-model="ctrl.a">a</md-checkbox>
    <md-checkbox ng-model="ctrl.b">b</md-checkbox>
    <md-checkbox ng-model="ctrl.c">c</md-checkbox>
  </div>
<md-card>
```

## CSSの記述

checkboxesクラスの中の子要素md-checkboxにだけ適用する

```css
.checkboxes > md-checkbox {
  margin: 0; これがないとマージンが大きすぎる
  padding: 16px; これがないと2列になったときにくっついてしまう
  min-width: 300px; これがないと綺麗に並ばない
  flex: 0 0 auto; /* 値を3つ指定: flex-grow | flex-shrink | flex-basis */ なくてもよい
}
```

[//]:# (@@@)
# md-listをvirtual-containerに入れてスクロールする

```html
      <md-virtual-repeat-container id="vertical-container" flex="100" style="border: solid 1px grey;">
        <md-list>
          <div md-virtual-repeat="item in resultCtrl.filtered" class="repeated-item">
            <!-- ui-routerを使って詳細を出す場合
            <md-list-item class="md-3-line" ng-click="resultCtrl.routeDetail(item.id)">
            -->
            <md-list-item class="md-3-line" ng-click="resultCtrl.showBottomSheet($event, item.id)">
              <div class="md-list-item-text" layout="column">
                <h3>{{item.address }} / {{item.port}}</h3>
                <h4>{{item.description }}</h4>
                <p>{{item.hostnames[0] }}</p>
              </div>
            </md-list-item>
          </div>
        </md-list>
      </md-virtual-repeat-container>

      <!-- ここにテンプレートを展開して/vip/detailを表示する -->
      <!--
      <div flex="33">
        <div ui-view></div>
      </div>
      -->
```

[//]:# (@@@)
# angular materialでの色指定

属性値で色を指定する。

```html
md-colors="::{background: 'default-background-500-0.43'}"
```

[//]:# (@@@)
# angular-materialのグリッド

## 横並び

1行の中に子要素を詰め込むので、結果として横並びになる。

```html
<div layout="row">
```

## 縦並び

1列に子要素を詰め込むので、結果として縦並びになる。

```html
<div layout="column">
```

## 位置の指定

layout-alignを左右、上下の順に指定する。

### 左右は真ん中に配備、上下は真ん中に配備する指定

```html
<div layout="row" layout-align="center center">
```

### 左右は均等に配備され、上下は、上に配備される

```html
layout-align="space-between start"
```

### 左右は行の終わりに配備、上下は均等に配備される

レイアウトの方向がカラムだと、左右と上下が逆になるのでややこしい。

```html
<div layout="column" layout-align="space-around end" style="height: 400px; margin-top: 24px;">
```

space-betweenとspace-aroundは、最初の最後の要素の前後にスペースを用意するかどうかの違い。

### layout-margin

自分の周りにマージンができる。

```html
<div layout="row" layout-margin>
```

### layout-padding

子要素の周りにマージンができ、子要素にパディングができ、子要素が大きくなる。

```html
<div layout="row" layout-margin layout-padding style="margin-top: 24px;">
```

### layout-fill

子要素が左右上下に広がる。

```html
<div layout="row" layout-margin layout-padding layout-fill>
```

[//]:# (@@@)
# グリッドの子要素

## flex

領域が広がって調整される。

```html
<div flex>
```

## flex="20"

左右がコンテナの20%に広がる。数字は5の倍数。もしくは33か66。

高さは、コンテナが明示的に高さを指定していないと、広がらない。

```html
<div flex="20">
```

## flex-offset="5"

左側に5%の隙間がでる。

```html
<div flex flex-offset="5">
```

[//]:# (@@@)
# ヘッダ・コンテンツ・フッタの基本構成の例

```html
<body ng-app="myApp" layout="column" layout-fill>
<md-toolbar>
  <div class="md-toolbar-tools">
    <h1>My App's Title</h1>
    <span flex></span> <!-- ボタンを右寄せするためにこれを入れる -->
    <md-button>Right Bar Button</md-button>
    <md-button aria-label="menu" class="md-fab md-primary">
      <md-icon md-svg-src="img/icons/menu.svg"></md-icon>
    </md-button>
  </div>
</md-toolbar>

<md-content flex layout-margin>
  <h2>Content section</h2>
</md-content>

<md-toolbar>
  <h1>Footer row</h1>
</md-toolbar>
```

[//]:# (@@@)
# タブを使う例

```html
<body ng-app="myApp" layout="column" layout-fill>
<md-toolbar>
  <div class="md-toolbar-tools">
    My favorite dive sites
  </div>
</md-toolbar>

<md-content ng-controller="DiveSitesController">
  <md-tabs md-border-bottom md-dynamic-height>
    <md-tab ng-repeat="site in diveSites" label="{{site.toString()}}">
      <md-content layout-padding>
        <h1 class="md-display-1">{{site.toString()}}</h1>
        <p class="md-body-1" ng-repeat="item in getSiteInfo($index + 1)">
          {{item.toString()}}
        </p>
      </md-content>
    </md-tab>
  </md-tabs>
</md-content>
```

[//]:# (@@@)
# サイドバーの例

## html

```html
<body ng-app="myApp" layout="column" ng-controller="DiveLogController">

<md-toolbar>
  <div class="md-toolbar-tools"> Younderwater Dive Log </div>
</md-toolbar>

<md-content layout="row" flex>
  <md-sidenav class="md-sidenav-left md-whiteframe-z2" md-is-locked-open="true">

    <md-toolbar class="md-toolbar-tools">
      <h1>Tags</h1>
    </md-toolbar>

    <md-content layout-padding>
      <md-list>
        <md-list-item ng-repeat="tag in tags">
          <md-button class="md-primary" ng-class="tag.selected ? 'md-raised md-accent' : ''" ng-click="toggleTag(tag)">
            {{tag.name}}
          </md-button>
        </md-list-item>
      </md-list>
    </md-content>

  </md-sidenav>

  <md-content id="main" flex layout="column">
    <section layout="row" layout-wrap>
      <div flex="25" flex-sm="50" flex-xs="100" ng-repeat="dive in getFilteredDives()">

        <md-card>
          <md-card-content>
            <h1>{{dive.depth}} feet | {{dive.time}} min</h1>
            <h2>{{dive.site}}</h2>
            <h3>{{dive.location}}</h3>
          </md-card-content>
          <md-card-footer>
            <span ng-repeat="tag in dive.tags"
              class="tag">
              {{tag.toString()}}
            </span>
          </md-card-footer>
        </md-card>

      </div>
    </section>
  </md-content>

</md-content>
```

## js

```js
    $scope.toggleTag = function(tag) {
      tag.selected = !tag.selected;
    };

    $scope.getFilteredDives = function() {
      var filterTags = $scope.tags.filter(
        function(tag) {
          return tag.selected;
        });
      var filteredDives = $scope.dives.filter(
        function(dive) {
          return filterTags.every(
            function(value){
              return dive.tags.indexOf(value.name) >= 0;
            });
        }
      );
      return filteredDives;
    };
```

## サイドバーをボタンで開く

```html
    <md-button class="md-icon-button"
        ng-show="enableShowTags()"
        ng-click="showTags()"
        ng-class="{'md-accent': isFilterOn()}">
      <md-icon> filter_list </md-icon>
    </md-button>
```

[//]:# (@@@)
# virtual repeat

## html

```html
  <md-content ng-app="virtualRepeatVerticalDemo"  ng-controller="AppController as ctrl" layout="column" >

    <md-virtual-repeat-container id="vertical-container">
      <div class="repeated-item" md-virtual-repeat="i in ctrl.items" md-item-size="220">
        <div>
          <div>{{i}} - John Smith (jts) - 01/01/2015</div><br/>
        </div>
        <div class="description">
          Fusce sed pretium risus. Ut aliquet enim id sagittis finibus.
        </div>
        <br/>
        <div>Priority: changed to 1</div>
        <div>Status: changed to WIP</div>
        <div>Due date: changed to 01/01/2015</div>
      </div>
    </md-virtual-repeat-container>

  </md-content>
```

## CSS

```css
#vertical-container {
  height: 444px;
  width: 600px;
  border: solid 1px grey;
}

.repeated-item {
  border-bottom: 1px solid #ddd;
  padding-left: 16px;
  padding-bottom : 20px;
  padding-top:20px;
}
```

[//]:# (@@@)
# レイアウトをコントローラ側に持たせる

## js

```js
  angular
    .module('layout', [])
    .controller('LayoutController', ['$mdMedia', '$scope', LayoutController]);

  function LayoutController($mdMedia, $scope) {
    var self = this;

    self.title = 'Simple Layout';
    self.sectionTitle = 'Section #1';
    self.sectionBody = 'This is a simple section.';

    $scope.$watch(function() {
      return $mdMedia('xs') ? 'small' : 'large';
    }, function(size){
      self.screenSize = size;
    })
  }
```

## css

```css
    <style>
      md-toolbar h1 {
        margin: auto;
        font-weight: 400;
      }

      md-toolbar.small h1 {
        font-size: 1.25em;
        margin: auto 0;
        padding-left: 16px;
      }

      #content {
        padding: 8px 40px;
      }

      #content.small {
        padding: 8px 16px;
      }
    </style>
```

## html

```html
  <body ng-app="myApp" layout="column" ng-controller="LayoutController as lc">

  <md-toolbar layout="row" ng-class="lc.screenSize">
    <h1>{{lc.title}}</h1>
  </md-toolbar>

  <md-content id="content" ng-class="lc.screenSize">
    <h2>{{lc.sectionTitle}}</h2>
    {{lc.sectionBody}}
  </md-content>
```

[//]:# (@@@)
# フォーム

## インプット系

```html
  <form name="simple" novalidate layout-margin>
    <div layout="column">

      <md-input-container >
        <label>Name</label>
        <input name="name" ng-model="user.name" required maxlength="32" />
      </md-input-container>

      <md-input-container>
        <label>Email</label>
        <input type="email" name="email" ng-model="user.email" required maxlength="64" />
      </md-input-container>

    </div>

    <md-button class="md-raised md-primary" ng-click="register(user)" ng-disabled="simple.$invalid"  >
      Register
    </md-button>

  </form>
```

エラーメッセージを出すならmd-input-container内にこれを入れる。

```html
        <div ng-messages="simple.name.$error" ng-show="simple.name.$dirty">
          <div ng-message="required">Please provide a name!</div>
          <div ng-message="md-maxlength">This name is too long!</div>
        </div>
```

## ラジオボタン

```html
  <form name="simple" novalidate layout-margin>
    <div layout="column" layout-margin>

      <div class="md-body-2">
        Dive type
      </div>

      <md-radio-group ng-model="dive.type" ng-init="dive.type=0">
        <md-radio-button ng-repeat="type in diveTypes" aria-label="{{type.name}}" ng-value="type.id">
          {{type.name}}
        </md-radio-button>
      </md-radio-group>

      <md-divider></md-divider>

      <div class="md-body-2">
        Altitude
      </div>

      <md-radio-group ng-model="dive.altitudeType">
        <md-radio-button ng-repeat="alt in altitudeTypes" aria-label="{{alt.category}}" ng-value="alt.category">
          {{alt.category}}
        </md-radio-button>
      </md-radio-group>

    </div>

    <md-button class="md-raised md-primary" ng-click="register(dive)" ng-disabled="simple.$invalid"  >
      Register
    </md-button>

  </form>
```

## チェックボックス

```html
  <div layout="column" layout-margin ng-init="gear={}">
    <md-checkbox ng-model="gear.fins"> Fins </md-checkbox>
    <md-checkbox class="md-primary" ng-model="gear.suit"> Neoprene suit </md-checkbox>
    <md-checkbox ng-model="gear.bcd"> BCD jacket </md-checkbox>
    <md-checkbox ng-model="gear.regulator"> Regulator </md-checkbox>
    <md-checkbox ng-model="gear.tank"> Tank </md-checkbox>
    <md-checkbox ng-model="gear.weights"> Weights </md-checkbox>
  </div>

  <md-divider></md-divider>

  <div layout-margin>
    <code>
      {{gear | json}}
    </code>
  </div>
```

## セレクトの要素を動的にロードするなら

```html
      <md-input-container>
        <label>Altitude</label>
        <md-select name="altitudeType" ng-model="dive.altitudeType" md-on-open="initAltitudeTypes()" >
          <md-optgroup ng-repeat="alt in altitudeTypes" label="{{alt.category}}">
            <md-option ng-repeat="type in alt.levels">
              {{type.toString()}}
            </md-option>
          </md-optgroup>
        </md-select>
      </md-input-container>
```

```js
    $scope.initAltitudeTypes = function () {
      if ($scope.altitudeTypes) return;
      var deferred = $q.defer();
      setTimeout(function() {
        $scope.altitudeTypes = altitudes;
        deferred.resolve();
      }, 2000);
      return deferred.promise;
    }
```

## スイッチ

```html
    <md-switch ng-false-value="'off'" ng-true-value="'on'" ng-model="settings.beep">
      Beep <small>({{settings.beep}})</small>
    </md-switch>
```

## オートコンプリート

```html
  <form name="simple" novalidate layout-margin>

    <md-autocomplete
        md-input-name="city"
        md-items="city in getMatchingCities(searchKey)" ★検索結果だけをコンプリート候補に出す
        md-search-text="searchKey" ★これが検索に使われる
        md-item-text="city.toString()"
        md-selected-item="selectedCity"
        placeholder="Type a city">
      <span>{{city.toString()}}</span>
    </md-autocomplete>

  </form>

  <md-divider></md-divider>

  <div layout-margin layout-padding>
    <p>Selected city:
      <code>{{selectedCity}}</code>
    </p>
    <p>Control value:
      <code>{{simple.city.$modelValue}}</code>
    </p>
  </div>
```

```js
    $scope.getMatchingCities = function(searchKey) {
      if (!searchKey) return $scope.cities;
      return $scope.cities.filter(function(item) {
        var key = searchKey.toLowerCase();
        return item.toLowerCase().indexOf(key) >= 0;
      })
    }
```

[//]:# (@@@)
# メニュー md-menu

```html
  <md-menu>

    <md-button ng-click="$mdOpenMenu($event)" md-position-mode="target-right target">
      Dive log actions
    </md-button>

    <md-menu-content>

      <md-menu-item>
        <md-button ng-click="handle($event)"> Edit log entry </md-button>
      </md-menu-item>

      <md-menu-item>
        <md-button ng-click="handle($event)"> Remove log entry </md-button>
      </md-menu-item>

      <md-menu-item>
        <md-button ng-click="handle($event)"> Attach pictures </md-button>
      </md-menu-item>

    </md-menu-content>

  </md-menu>
```

[//]:# (@@@)
# ダイアログ

## JavaScript側で起動する

```js
  <md-button class="md-raised md-accent" ng-click="showAlert($event)">
    Show an alert
  </md-button>

  angular
    .module('dialog', [])
    .controller('DialogController', ['$scope', '$mdDialog', DialogController]);

  function DialogController($scope, $mdDialog) {

    $scope.showAlert = function(ev) {
      var dialog = $mdDialog.alert()
        .title('Your battery level is low.')
        .textContent('Now, your battery has a critically low capacity, 8%.')
        .ariaLabel('Battery level is low')
        .ok('OK');

      $mdDialog.show(dialog);
    }

    $scope.showAlert = function(ev) {
      var parentPanel = angular.element(document.querySelector('#sourcePanel'))
      var dialog = $mdDialog.alert()
        .parent(parentPanel)
        .targetEvent(ev)
        .clickOutsideToClose(true)
        .title('Your battery is low.')
        .textContent('Now, your battery has a critically low capacity, 8%.')
        .ariaLabel('Battery level is low')
        .ok('OK');
      $mdDialog.show(dialog);
    }


    $scope.showConfirmation = function(ev) {
      $scope.deleteStatus = "Dialog opened";
      var parentPanel = angular.element(document.querySelector('#sourcePanel'))
      var dialog = $mdDialog.confirm()
        .parent(parentPanel)
        .targetEvent(ev)
        .clickOutsideToClose(true)
        .title('Delete dive log entry')
        .textContent('Are you sure, you really want to delete this dive log entry?')
        .ariaLabel('Delete log entry')
        .ok('Delete')
        .cancel('Leave it');

      $mdDialog.show(dialog).then(
        function(){
          $scope.deleteStatus = "Deleted"
        },
        function() {
          $scope.deleteStatus = "Delete canceled"
        }
      );
    }

  }
```

[//]:# (@@@)
# リスト md-list

```html
  <md-list>
    <md-list-item class="md-3-line" ng-repeat="dive in dives">
      <div class="md-list-item-text">
        <h3>{{dive.site}}</h3>
        <h4>{{dive.location}}</h4>
        <p>{{dive.depth}} feet | {{dive.time}} min</p>
        <md-divider></md-divider>
      </div>
    </md-list-item>
  </md-list>
```

[//]:# (@@@)
# いつものフォント指定

いまはこれを使ってる。

```css
body {
  font-family: Arial, Roboto, 'Droid Sans','游ゴシック',YuGothic,'ヒラギノ角ゴ ProN W3','Hiragino Kaku Gothic ProN','メイリオ',Meiryo,sans-serif;
}
```

まえはこれ。

```css
body {
  font   : 10pt 'Trebuchet MS', Verdana, Helvetica, Arial, Meiryo, sans-serif;
}
```

[//]:# (@@@)
# オブジェクトのdiff

jsfiddle.net/sbgoran/kySNu/

[//]:# (@@@)
# AngularJS

## 一括でダウンロードするには

ここからzipを持っていく

<https://code.angularjs.org/1.5.8/>

## AngularJS HUB

<http://www.angularjshub.com/>

## すぐできるAngularJS

<http://8th713.github.io/LearnAngularJS/#/>

## js Studio

<http://js.studio-kingdom.com/>

## 非同期にデータを取りに行って、結果が帰ってきてから表示する方法

```js
$http.get('data_endpoint').then(function () {
    $scope.isDataFetched = true;
})
```

```html
<div ng-if="isDataFetched">
    <!-- Some complex HTML that needs fetched data -->
</div>
```

## ng-repeatを使う場合は、idでトラックした方が高速

```html
<!-- Normal -->
<li ng-repeat="item in items"></li>

<!-- Better -->
<li ng-repeat="item in items track by item.id"></li>
```

## debounceを指定すると、変化にディレイを入れることができる

```html
<input type="text" name="userName" ng-model="user.name" ng-model-options="{ debounce: 300 }" /><br />
```

[//]:# (@@@)
# Bootstrap

## Bootstrap3日本語リファレンス

<http://bootstrap3.cyberlab.info>

[//]:# (@@@)
# angularでtable内のクリックイベントを制御する

```html
<body ng-controller="MainCtrl">

    <table>
          <tr data-ng-click="do_some_action()">
              <td>
                  cell 1 is clickable
              </td>
              <td>
                  cell 2 is clickable
              </td>
              <td class="not-clickable-cell" ng-click="$event.stopPropagation()">
                  cell 3 is not! clickable
              </td>
          </tr>
    </table>

</body>
```

[//]:# (@@@)
# NeXt UI Project

<https://github.com/opendaylight/next>

Opendaylightの一部？

CiscoとVerizonが使ってる。

[//]:# (@@@)
# JavaScriptで配列から特定の要素を削除する

splice()を使う

```js
      // runningTasksリストからそのタスクを排除する
      stateMap.runningTasks.some(function (v, i) {
        if (v.taskId === task.taskId) {
          stateMap.runningTasks.splice(i, 1);
        }
      });
```

[//]:# (@@@)
# ダイアログ表示

<http://hakuhin.jp/js/dialog.html>

[//]:# (@@@)
# String.startsWith相当は何か

これが一番いい

```js
str.lastIndexOf('prefix', 0) === 0
```

[//]:# (@@@)
# アコーディオン

<http://sample.web-pc.net/accordion/>

<dl class="accordion">
<dt>タイトル１</dt>
<dd>
イメージ確認用のサンプルテキストです。<br>
この部分にはテキストが入ります。<br>
内容に応じたテキストを入力して下さい。
</dd>
<dt>タイトル２</dt>
<dd>
イメージ確認用のサンプルテキストです。<br>
この部分にはテキストが入ります。<br>
内容に応じたテキストを入力して下さい。
</dd>
<dt>タイトル３</dt>
<dd>
イメージ確認用のサンプルテキストです。<br>
この部分にはテキストが入ります。<br>
内容に応じたテキストを入力して下さい。
</dd>
<dt>タイトル４</dt>
<dd>
イメージ確認用のサンプルテキストです。<br>
この部分にはテキストが入ります。<br>
内容に応じたテキストを入力して下さい。
</dd>
</dl>

[//]:# (@@@)
# CSSアニメーション

アイコンに動きを付ける例
<http://tobiasahlin.com/spinkit/>

動きの参考になる22サイト
<https://webkikaku.co.jp/blog/htmlcss/css3animation/>

[//]:# (@@@)
# bpmn

ビジネス・プロセスを記述するための標準

<http://demo.bpmn.io/>

[//]:# (@@@)
# SVGを描画する

JointJS
<http://www.jointjs.com/demos/devs/>

[//]:# (@@@)
# SVGをjQueryで操作する際にハマったので、書き留めておく。

<http://5log.jp/blog/svg-jquery/>

[//]:# (@@@)
# ドラッグドロップでソートする

HTML5 Sortable

rubaxa.github.io/Sortable

[//]:# (@@@)
# jQueryの読み込み方

```html
  <!-- jQueryを読み込む -->
  <!--[if lt IE 9]>
    <script src="/static/js/jquery-1.12.0.min.js"></script>
  <![endif]-->
  <!--[if gte IE9]><!-->
    <script src="/static/js/jquery-2.2.0.min.js"></script>
  <!--<![endif]-->
```

# jQuery決まり文句

```js
$(document).ready(function() {
});
```

```html
<script>
jQuery(function($) {

  //<div id="a"></div>を渡してaモジュールを起動するなら、
  a.initModule( $('#a') );

  //画像等、全部を読み込んだあとでスクリプトを走らせたいなら
  $(window).on("load", function() { });

});
</script>
```

jQuery フェードイン・フェードアウト

```js
var $img = $("img");
$("#fadein").toggle(
 function() {
  $img.fadeOut();
 },
 function() {
  $img.fadeIn();
 }
);
```

showとhide

```js
var $img = $("img");
$("#fadein").toggle(
 function() {
  $img.hide();
 },
 function() {
  $img.show();
 }
);
```

アニメーション

```js
var $img = $("img");
$("#animate").toggle(
 function() {
  $img.animate({
    height: "0px"
  });
 },
 function() {
  $img.animate({
    height: "358px"
  });
 }
);
```

[//]:# (@@@)
# jQuery イベントハンドラ

通常jQueryイベントハンドラを作成したらfalseを返却する。

falseを返却することで以下の効果を得られる。

- リンクをたどったりテキストを選択したり、等をしないようにするにはevent.preventDefault()を呼ぶ
- 親のDOM要素で同じイベントを発行しないようにするにはevent.stopPropagation()を呼ぶ
- 次のハンドラを実行したくなければevent.preventImmediatePropagation()する

[//]:# (@@@)
# CSSの基本

## クラス名

```css
.sample {
  font-size:18px;
  color:red;
}
```

## ID指定

```css
#sample {
  font-size:16px;
}
```

## 子孫要素に適用する場合

```css
p strong {
  font-size:16px;
}
```

pタグの中にあるstrong要素に適用

```css
p.mago strong {
  font-size:16px;
}
```

magoというクラス名がついたp要素のなかにあるstrong要素に適用

## 子要素にのみ適用する場合

```css
div.sample > a {
  font-size:18px;
  font-weight:bold;
}
```

クラス名sampleの直下にあるa要素にのみ適用

## 隣接している要素に適用

```css
h4 + p {
  color:red;
  font-weight:bold;
}
```

h4要素に隣接しているp要素

## 後にある要素に適用

```css
h4 ~ p {
  color:red;
  font-weight:bold;
}
```

h4要素の後ろにあるp要素

[//]:# (@@@)
# CSSレイアウトを学ぶ

大変良い資料。

<http://ja.learnlayout.com/>

[//]:# (@@@)
# jquery ajaxの使い方

<https://medium.com/coding-design/writing-better-ajax-8ee4a7fb95f#.77qh5w2f4>

.success()ではなく .done() を使う

.error()ではなく .fail() を使う

.complete()ではなく .always() を使う

```js
$.ajax({
    data: someData,
    dataType: 'json',
    url: '/path/to/script'
}).done(function(data) {
    // If successful
   console.log(data);
}).fail(function(jqXHR, textStatus, errorThrown) {
    // If fail
    console.log(textStatus + ': ' + errorThrown);
});
```

より汎用には、返却されたpromiseオブジェクトを利用する

```js
var ajaxCall = $.ajax({
    context: $(element),
    data: someData,
    dataType: 'json',
    url: '/path/to/script'
});

ajaxCall.done(function(data) {
    console.log(data);
});
```

複数のajaxコールの完了は、whenで制御できる

```js
var a1 = $.ajax({...}),
    a2 = $.ajax({...});

$.when(a1, a2).done(function(r1, r2) {
    // Each returned resolve has the following structure:
    // [data, textStatus, jqXHR]
    // e.g. To access returned data, access the array at index 0
    console.log(r1[0]);
    console.log(r2[0]);
});
```

複数のajaxコールの順番は、thenで制御できる

```js
var a1 = $.ajax({
             url: '/path/to/file',
             dataType: 'json'
         }),
    a2 = a1.then(function(data) {
             // .then() returns a new promise
             return $.ajax({
                 url: '/path/to/another/file',
                 dataType: 'json',
                 data: data.sessionID
             });
         });

a2.done(function(data) {
    console.log(data);
});
```

[//]:# (@@@)
# d3.js timeline

<https://github.com/alangrafu/timeknots>

[//]:# (@@@)
# d3.jsで外部のSVGを取り込む方法

<http://gappyfacets.com/2014/11/07/d3-js-importing-svg-chart-element/>

<http://jsfiddle.net/J8sp3/4/>

[//]:# (@@@)
# D3.js を使ってcsvからテーブルを出力する

<http://qiita.com/_shimizu/items/0bb1ed4199b500670e69>

<http://codepen.io/shimizu/pen/sdpLE>

[//]:# (@@@)
# WebデザイナーのためのjQuery入門

良書

サンプル
<http://gihyo.jp/book/sp/01/jqbook/>

[//]:# (@@@)
# jQuery入門道場

良書

<http://jquery-master.net>

[//]:# (@@@)
# はじめてのNode.js

良書

サンプル
<http://sourceforge.jp/users/hylom/pf/>

[//]:# (@@@)
# expressのインストール

```bash
npm install -g express-generator
npm install -g ejs

express -e test1

  install dependencies:
    > cd test1 && npm install

  run the app:
    > SET DEBUG=test1:* & npm start
```

Webアプリを置くディレクトリを作ってそこにexpressを配備する。

```bash
npm install express
```

nodemonを使うと再起動不要。

[//]:# (@@@)
# d3.js リユーサブル

<http://bl.ocks.org/n1n9-jp/6238c6e48bff9cd8da12>

[//]:# (@@@)
# d3.js , The Wealth & Health of Nations

<http://bost.ocks.org/mike/nations/>

必読ソースコード

```js
  // A bisector since many nation's data is sparsely-defined.
  var bisect = d3.bisector(function(d) { return d[0]; });

  // Start a transition that interpolates the data based on year.
  svg.transition()
      .duration(30000)
      .ease("linear")
      .tween("year", tweenYear) // ★カスタムtween、"year"は名前、tweenYearはファクトリ(関数を返す関数)
      .each("end", enableInteraction);

  // ★tを引数にして処理をする関数を返す
  function tweenYear() {
    var year = d3.interpolateNumber(1800, 2009);
    return function(t) { displayYear(year(t)); };
  }

  // Updates the display to show the specified year.
  function displayYear(year) {
    dot.data(interpolateData(year), key).call(position).sort(order);
    label.text(Math.round(year));
  }

  // Interpolates the dataset for the given (fractional) year.
  function interpolateData(year) {
    return nations.map(function(d) {
      return {
        name: d.name,
        region: d.region,
        income: interpolateValues(d.income, year),
        population: interpolateValues(d.population, year),
        lifeExpectancy: interpolateValues(d.lifeExpectancy, year)
      };
    });
  }

  // Finds (and possibly interpolates) the value for the specified year.
  function interpolateValues(values, year) {
    var i = bisect.left(values, year, 0, values.length - 1);
    var a = values[i];

    if (i > 0) {
      var b = values[i - 1],
          t = (year - a[0]) / (b[0] - a[0]);
      return a[1] * (1 - t) + b[1] * t;
    }
    return a[1];

  }
```

[//]:# (@@@)
# d3.js ギャラリー

<http://christopheviau.com/d3list/gallery.html>

[//]:# (@@@)
# d3.js 必読

マージンの指定方法
<http://bl.ocks.org/mbostock/3019563>

最初に読むべき
d3.js超初心者向け
<http://qiita.com/daxanya1/items/734e65a7ca58bbe2a98c>

最初に読むべき
チュートリアル
<http://dataisfun.org/category/d3-tutorial/d3-tutorial-elemental>

クロージャー、メソッドチェーンはどうやって実現されているのか
<http://ja.d3js.info/blocks/mike/chart/>

[//]:# (@@@)
# d3.js 基本中の基本

datumは一つの要素に対してデータをまるごと紐付ける。

dataはデータを展開して複数の要素を生成する。

```js
# selection.data([values[, key]])
```

keyは再セレクションするときに重要。
何も指定しないと配列のインデックス番号がキーになってしまう。
配列の後ろに追加していくタイプなら、最後の追加された部分がenter領域になる。

データの名前で束縛するならこうする。

```js
.data(data, function(d) { return d.name; })
```

[//]:# (@@@)
# d3.js , tide chart

<http://phangantide.info/>

[//]:# (@@@)
# d3.js , How Obama Won Re-election

<http://www.nytimes.com/interactive/2012/11/07/us/politics/obamas-diverse-base-of-support.html?_r=0>

```js
function run() {
    paused = false;
    then = Date.now();
    now = then;

    particles.forEach(function(p) { p.t = now + (Math.random() - 1) * duration; });

    d3.timer(function(elapsed) {
      var i = -1,
          n = particles.length;

      // Fade to transparent!
      offscreenContext.clearRect(0, 0, width, height);
      offscreenContext.drawImage(canvas, 0, 0, width, height);
      context.clearRect(0, 0, width, height);
      context.drawImage(offscreenCanvas, 0, 0, width, height);

      now = elapsed + then;

      while (++i < n) {
        var p = particles[i],
            t = (now - p.t) / duration;
        if (t > 1) {
          p.t += duration * Math.floor(t);
          p.y = p.d.centroid[1] + (Math.random() - .5) * 2;
        } else if (t > 0) {
          context.fillStyle = "rgba(" + p.r + "," + p.g + "," + p.b + "," + mirror(1 - t) + ")";
          context.fillRect(p.x + (t - .5) * p.v - .75, p.y - .75, 1.5, 1.5);
        }
      }

      return paused;
    }, 0, now);
  }
}
```

[//]:# (@@@)
# d3.js, forceレイアウトでリンクをカーブさせる例

<http://bl.ocks.org/mbostock/1153292>

```js
// Use elliptical arc path segments to doubly-encode directionality.
function tick() {
  path.attr("d", linkArc);
  circle.attr("transform", transform);
  text.attr("transform", transform);
}

function linkArc(d) {
  var dx = d.target.x - d.source.x,
      dy = d.target.y - d.source.y,
      dr = Math.sqrt(dx * dx + dy * dy);
  return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
}

function transform(d) {
  return "translate(" + d.x + "," + d.y + ")";
}
```

[//]:# (@@@)
# 画面にログ出力

<http://handsontable.com/demo/callbacks.html>

```html
<h3>Events log
  <button onclick="$('#example1_events').empty()">
    Clear
  </button>
</h3>
<div id="example1_events" style="height: 250px; overflow: scroll; background-color: #fdfdfd; font-size: 11px"></div>
```

```js
function log_events(event, data) {
  if (document.getElementById('check_' + event).checked) {
    var now = (new Date()).getTime(),
      diff = now - start,
      vals, str, div, text;

    vals = [
      i,
      "@" + numeral(diff / 1000).format('0.000'),
      "[" + event + "]"
    ];

    for (var d = 0; d < data.length; d++) {
      try {
        str = JSON.stringify(data[d]);
      }
      catch (e) {
        str = data[d].toString(); // JSON.stringify breaks on circular reference to a HTML node
      }

      if (str === void 0) {
        continue;
      }

      if (str.length > 20) {
        str = Object.prototype.toString.call(data[d]);
      }
      if (d < data.length - 1) {
        str += ',';
      }
      vals.push(str);
    }

    if (window.console) {
      console.log(i,
        "@" + numeral(diff / 1000).format('0.000'),
        "[" + event + "]",
        data);
    }
    div = document.createElement("DIV");
    text = document.createTextNode(vals.join(" "));

    div.appendChild(text);
    example1_events.appendChild(div);

    //これは単にスクロールをかけているだけ
    clearTimeout(timer);
    timer = setTimeout(function() {
      example1_events.scrollTop = example1_events.scrollHeight;
    }, 10);

    i++;
  }
}
```

[//]:# (@@@)
# jslintオプション

'''js
/* global global, exports, module, define, $ */
/* jslint browser:true, continue:true, devel:true, indent:2, maxerr:50, newcap:true, nomen:true, plusplus:true, regexp:true, sloppy:true, vars:true, white:true, bitwise:true, sub:true, node:true, unused:vars */
'''

es5:true, はデフォルトになってる。

## evil:true

eval is evilと言われたくない場合はtrueだが、evalは使わない方がよいのでこれは指定しない

## bitwise:true

ビット操作するために必要

## sub:true

a["abc"]を許容するために必要

## node:true

node.jsを使うなら必要

## es5:true

  \で複数行つなげた文字列を書くときに必要

  予約後をプロパティとして使う場合にも必要(angularが使う)

[//]:# (@@@)
# GeoIP

ファイルは２つある

## GeoLiteCity-Location.csv

都市番号と座標を示したもの

```csv
locId ,country,region,city      ,postalCode,latitude,longitude,metroCode,areaCode
114827,"JP"   ,"10"  ,"Tokyo"   ,""        ,35.6850 ,139.7514 ,         ,
21250 ,"JP"   ,"19"  ,"Yokohama",""        ,35.4478 ,139.6425 ,         ,
```

regionってなんだろ？

## GeoLiteCity-Blocks.csv

```csv
startIpNum  ,endIpNum    ,locId
"16777216"  ,"16777471"  ,"17"
"1698000896","1698004991","21250"
"1697996800","1697997823","21250"
```

どうやらIPアドレスは32ビットで書かれている模様。

[//]:# (@@@)
# IPアドレスをJavaScriptで扱う

```js
var ip2long = function(ip){
    var components;

    if(components = ip.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/))
    {
        var iplong = 0;
        var power  = 1;
        for(var i=4; i>=1; i-=1)
        {
            iplong += power * parseInt(components[i]);
            power  *= 256;
        }
        return iplong;
    }
    else return -1;
};

var inSubNet = function(ip, subnet)
{
    var mask, base_ip, long_ip = ip2long(ip);
    if( (mask = subnet.match(/^(.*?)\/(\d{1,2})$/)) && ((base_ip=ip2long(mask[1])) >= 0) )
    {
        var freedom = Math.pow(2, 32 - parseInt(mask[2]));
        return (long_ip > base_ip) && (long_ip < base_ip + freedom - 1);
    }
    else return false;
};
```

## 使い方

```js
inSubNet('192.30.252.63', '192.30.252.0/22') => true
inSubNet('192.31.252.63', '192.30.252.0/22') => false
```

[//]:# (@@@)
# d3.jsでグリッド表示

<http://bl.ocks.org/bunkat/2605010>

[//]:# (@@@)
# d3.jsでヒートマップ

<http://bl.ocks.org/tjdecke/5558084>

[//]:# (@@@)
# d3.jsでRadio Button

ラジオボタンをd3.jsで生成する

<http://jsfiddle.net/jhaRoshan/54559btv/>

```js
var shapeData = ["Triangle", "Circle", "Square", "Rectangle"],
    j = 3;  // Choose the rectangle as default

// Create the shape selectors
var form = d3.select("body").append("form");

labels = form.selectAll("label")
    .data(shapeData)
    .enter()
    .append("label")
    .text(function(d) {return d;})
    .insert("input")
    .attr({
        type: "radio",
        class: "shape",
        name: "mode",
        value: function(d, i) {return i;}
    })
    .property("checked", function(d, i) {return i===j;});
```

[//]:# (@@@)
# d3.js , New York Times

<http://query.nytimes.com/search/sitesearch/#/MIKE+BOSTOCK/>

[//]:# (@@@)
# d3.js , Visual Trace Route Tool

<http://www.monitis.com/traceroute/>

[//]:# (@@@)
# d3.js , 地図の２地点間に線をひく

<http://shimz.me/blog/d3-js/2913>

パスで描画するので一筆書きになる。

```js
	//都市　位置情報
	var pointdata = {"type": "LineString", "coordinates": [
		[139.69170639999993, 35.6894875], //東京
		[-122.41941550000001, 37.7749295], //サンフランシスコ
		[149.1242241, -35.30823549999999], //キャンベラ
		[77.22496000000001, 28.635308], //ニューデリー
		[-47.92916980000001,  -15.7801482], //ブラジリア
		[116.40752599999996,  39.90403], //北京
	]}

	//都市間ライン追加
	var line = svg.selectAll(".line")
		.data([pointdata])
		.enter()
		.append("path")
		.attr({
			"class":"line",
			"d": path,
			"fill": "none",
			"stroke": "red",
			"stroke-width": 1.5
		});

	//都市ポイント追加
	var point = svg.selectAll(".point")
		.data(pointdata.coordinates)
		.enter()
		.append("circle")
		.attr({
			"cx":function(d) { return projection(d)[0]; },
			"cy":function(d) { return projection(d)[1]; },
			"r":6,
			"fill":"red",
			"fill-opacity":1
		});
```

[//]:# (@@@)
# d3.js , スライダー

<http://sujeetsr.github.io/d3.slider/>

[//]:# (@@@)
# d3.js , マウスの動きに追従して点が動く例

<http://bl.ocks.org/duopixel/3824661>

```js
var svg = d3.select("#line").append("svg")
var path = svg.append("path")
      .attr("d", "M0,168L28,95.99999999999997L56,192L84,71.99999999999997L112,120L140,192L168,240L196,168L224,48L252,24L280,192L308,120L336,24L364,168L392,95.99999999999997L420,168L448,95.99999999999997L476,192L504,71.99999999999997L532,120L560,192L588,216L616,168L644,48L672,24L700,192L728,120L756,24L784,192L812,71.99999999999997")
      .attr("fill", "none")
      .attr("stroke", "black");

var circle = svg.append("circle").attr("cx", 100).attr("cy", 350).attr("r", "10").attr("fill", "red");

var pathEl = path.node();
var pathLength = pathEl.getTotalLength();
var BBox = pathEl.getBBox();
var scale = pathLength/BBox.width;
var offsetLeft = document.getElementById("line").offsetLeft;
var accuracy = 10; //lower is better but slower;

svg.on("mousemove", function() {
      var x = d3.event.pageX - offsetLeft;
     for (i = x; i < pathLength; i+=accuracy) {
        var pos = pathEl.getPointAtLength(i);
         if (pos.x >= x) {
           break;
         }
      }
      circle
        .attr("cx", x)
        .attr("cy", pos.y);
    });
```

[//]:# (@@@)
# d3.js , clusterレイアウトを使った興味深い例

<http://jsfiddle.net/doraeimo/JEcdS/>

これをベースにしてshow cdpの表示結果を可視化

[//]:# (@@@)
# forceレイアウトで階層構造を作る方法

```js
var k= 0.1 * e.alpha;
nodes.forEach(function( d ) {
  d.x += ((maxDepth - d.depth) * 100 - d.x) * k;
});
```

[//]:# (@@@)
# d3.js , Div-based Data Grid

データグリッド

<http://bl.ocks.org/syntagmatic/3687826>

```js
 // create data table, row hover highlighting
  var grid = d3.divgrid();
  d3.select("#grid")
    .datum(data.slice(0,10))
    .call(grid)
    .selectAll(".row")
    .on({
      "mouseover": function(d) { parcoords.highlight([d]) },
      "mouseout": parcoords.unhighlight
    });

  // update data table on brush event
  parcoords.on("brush", function(d) {
    d3.select("#grid")
      .datum(d.slice(0,10))
      .call(grid)
      .selectAll(".row")
      .on({
        "mouseover": function(d) { parcoords.highlight([d]) },
        "mouseout": parcoords.unhighlight
      });
  });
```

[//]:# (@@@)
# d3.js , forceでノードをダブルクリックすると固定する例

Sticky Force Layout

<http://bl.ocks.org/mbostock/3750558>

[//]:# (@@@)
# topojson

<http://blog.goo.ne.jp/xmldtp/e/b482b576bf71425e6366df7756e23a31>

<https://dl.dropboxusercontent.com/u/1662536/topojson/japan.topojson>

<http://ja.d3js.node.ws/blocks/mike/map/>

市町村単位の地図はここ。行政区域データ
<http://nlftp.mlit.go.jp/ksj/>

地図から東京都の離島を除かないといけないので、自分で地図を加工した方がいい。
Natural Earthの地図は県名レベルしかはいっていないので、編集が困難。県単位で消えてしまう。
地図は国土地理院のものがよい。
<http://www.gsi.go.jp/kankyochiri/gm_jpn.html>

県レベルだと国土交通省の地図も使える。行政区域を選ぶと、県ごとに指定して落とせる。
<http://nlftp.mlit.go.jp/ksj/>

地図の加工にはQGSIを使う。
QGISアプリ
<http://www2.qgis.org/ja/site/>

mapshaperでtopojsonを小さくすることもできる。

シェープファイルからtopojsonに変換する方法はここに詳しい。
<http://visualizing.jp/shapefile-to-topojson/>

topojsonに変換する際には必要な情報を追加しておかないといけない。

```bash
ogr2ogr -f GeoJSON -where 'geonunit = "Japan"' japan.geojson ne_10m_admin_1_states_provinces.shp

C:\TMP\japan>topojson -p name -p name_local -p latitude -p longitude -o japan.topojson japan.geojson

C:\HOME\iida\javascript\js\data>topojson -p name -p latitude -p longitude -o abura.topojson aburatsubo_20141124.geojson
```

nameやname_local等は d.properties.name で取得可能

```js
Object {name: "Okinawa", name_local: "沖縄県", latitude: 24.3349, longitude: 123.802}
```

## 参考情報

topojsonにはバージョンがv0とv1があり、使い方が全然違う。v0のサンプルは参考にならない。

 ズームの例 <http://bl.ocks.org/mbostock/2374239>

 点を打つ例 <http://bl.ocks.org/mbostock/4342045>

 ツールチップの例 <http://bl.ocks.org/rveciana/5181105>

KMLをGeoJSONに変換するにはMapboxのホームページか、コマンドラインで実行する

```bash
mapbox.github.io/togeojson
togeojson file.kml > file.geojson
```

その後、topojsonに変換する

```bash
topojson -o file.topojson file.geojson
```

[//]:# (@@@)
# jquery , API日本語リファレンス

<http://stacktrace.jp/jquery/api/>

[//]:# (@@@)
# jQuery

## セレクタ

- $('div') タイプセレクタ
- $('.class') クラスセレクタ
- $('#id') IDセレクタ
- $('[name="photo"]') 属性セレクタ

- $('a img')　子孫セレクタ
- $('p, div.huga') グループ化

- $('ul>li') 子セレクタ
- $('dt+dd') 隣接セレクタ
- $('a[target="_blank"]') 属性セレクタ

- $container = $('[data-id="10"]'); 属性セレクタでdata-idを指定
- $container.data('id') 10を返す

- $('li:first') 先頭の物
- $('li:even') 偶数の物
- $('p:contains("重要")') 重要を含む

## ラジオボタン

- $(':radio[name="gender"]:checked').val();

## セレクト

- $('#select').val(); // 値の取得
- $('#select').append($('<option>').html("追加される項目名").val("追加される値")); //追加
- $('#select > option').remove(); //全て取り除く
- $('#select > option:selected').remove(); //選択されたものを取り除くとき

## 複数条件の指定方法

- $('.class1') CLASS名 class1 の要素を選択

- $('.class1 .class2') CLASS名 class1 の要素の中にあるCLASS名 class2 の要素を選択

- $('.class3, .class4') CLASS名 class3、もしくはCLASS名 class4 の要素を選択

- $('.class5', '#id1') ID名 id1 の要素の中にあるCLASS名 class5 の要素を選択

- $('.class6.class7') CLASS名 class6 と class7 2つ持つ要素を選択

- $('a[href]') aタグのhref属性がある要素を選択

- $('a[href = "#pagetop"]') aタグのhref属性の値が「#pagetop」の要素を選択

- $('a[href != "#pagetop"]') aタグのhref属性の値が「#pagetop」でない要素を選択

- $('a[href ^= "#link"]') aタグのhref属性の値が「#link」から始まる要素を選択

- $('a[href $= "bottom"]') aタグのhref属性の値が「bottom」で終わる要素を選択

- $('a[href *= "page"]') aタグのhref属性の値に「page」が含まれている要素を選択

- $('ul li:first') すべてのulタグ内をあわせたliタグの中の最初の要素を選択

- $('ul li:first-child') 各ulタグ内にあるそれぞれのliタグの最初の要素を選択

- $('ul li:last') すべてのulタグ内をあわせたliタグの中の最後の要素を選択

- $('ul li:last-child') 各ulタグ内にあるそれぞれのliタグの最後の要素を選択

- $('li:not(".class6")') liタグでCLASS名 class6 が指定されていない要素を選択

```js
$("h1").next().find("li").eq(1)
  .next() 次の要素を選択
  .find("li") liをすべて見つける
  .eq(1) 0番目、1番目
```

指定のhtmlで囲む

```js
.wrap("<p></p>")
```

子要素を削除して空にする

```js
.empty()
```

要素のコピーを生成

```js
.clone()
```

```js
$("div").click(function() {
  // クリック時に実行されるコード
  $(this).css("color", "red");
});

.dblclick() ダブルクリック
.keydown() キーダウン
.scroll() スクロール時
.resize() ウィンドウのりサイズ時
```

```js
$("div").hover(
  function() { 要素に乗ったとき},
  function() { 要素から外れた時}
);
```

```js
$("div").toggle(
  function() { 一回目のクリック },
  function() { 二回目のクリックで一回目に戻る }
);
```

.attr()ではなく、.prop()を使った方がよい。

ダメな例

```js
$('#chk1').attr("checked", true);
```

良い例

```js
$('#chk1').prop("checked", true);
var isChked = $$('#chk1').prop("checked");
var isChked = $$('#chk1').is(":checked");
```

デフォルトの値をセットする

```js
$('#chk1').prop("defaultChecked", true);
```

フォームの値を取り出すときは.val()を使う方がよい

```js
$("#myselect").val();
```

[//]:# (@@@)
# JavaScript 即時関数の書き方

変数に()をつけると関数として実行される。

無名関数の定義はこう。

```js
function ( ) {

};
```

これを即時実行させたい場合は、うしろに()を付けてあげれば実行されそうだが、実際には構文エラーになる。

```js
function ( ) {

}( );
```

関数部分を()でくくってあげると即時実行される。

```js
(function ( ) {

}) ( );
```

ただし上記だとjslintが警告を出すので、関数部分ではなく、全体を( )でくくってあげる方がよい。

```js
(function ( ) {

}( ));
```

[//]:# (@@@)
# node.js

## 環境変数の設定

- PATH C:\nodejs
- NODE_HOME C:\nodejs
- NODE_PATH C:\nodejs\node_modules

## 動作設定

コマンドプロンプトを管理者権限で実行する。

```bash
npm config edit
```

メモ帳が起動するので、プロキシを設定する。

- proxy=http://ユーザ名:パスワード@プロキシサーバ:8080
- https-proxy=http://ユーザ名:パスワード@プロキシサーバ:8080

[//]:# (@@@)
# 再帰的にディレクトリをたどってくれるモジュール

walkをインストールする。

```bash
npm install walk
```

```js
var walk    = require('walk');
var files   = [];

// Walker options
var walker  = walk.walk('./test', { followLinks: false });

walker.on('file', function(root, stat, next) {
    // Add this file to the list of files
    files.push(root + '/' + stat.name);
    next();
});

walker.on('end', function() {
    console.log(files);
});
```

[//]:# (@@@)
# 正規表現

```js
var foo = 'abc123def456ghi';
var bar = foo.match(/^\D+(\d+)\D+(\d+)\D+$/);
```

- bar[0]はマッチしたもの全体
- bar[1]は()でグループ化した最初
- bar[2]は()でグループ化した２番目

[//]:# (@@@)
# インデックスを付けて検索を容易にする

```js
var obj = [
  {"name": "Afghanistan", "code": "AF"},
  {"name": "Åland Islands", "code": "AX"},
  {"name": "Albania", "code": "AL"},
  {"name": "Algeria", "code": "DZ"}
];

dict = {};
json.forEach(function(x) {
    dict[x.code] = x.name
});

countryName = dict[countryCode];
```

[//]:# (@@@)
# Bracketsの拡張機能

2016.09.11時点、Bracketsはもう使っていない。

- Extensions Rating
- Beautify
- Shizimily Multi-Encoding for Brackets
- Indent Guides
- 全角空白・スペース・タブ表示
- Whitespace Normalizer
- Custom Work
- WordHint
- Interactive Linter　不安定？？？

- Brackets CSS Class Code hint
- Brackets File Icons
- Brackets File Tree
- HTMLHint
- Show Whitespace
- Tabs - Custom Working
- YAML Linter

[//]:# (@@@)
# doLater.js

便利。

```js
/**
 * 後でやる。一回だけやる。
 * やる前に何回言われても一回だけ。
 *
 * @param job 後で実行する処理(関数)
 * @param tmo 実行待ち時間
 * @return なし
 * @author K.Takami
 * @version 2012-01-24
 */

function doLater(job, tmo) {

    //処理が登録されているなら
    //タイマーをキャンセル
    var tid = doLater.TID[job];
    if(tid != undefined) {
        window.clearTimeout(tid);
    }
    //タイムアウト登録する
    doLater.TID[job] = window.setTimeout(
        function() {
            //実行前にタイマーIDをクリア
            doLater.TID[job] = undefined;
            //登録処理を実行
            job.call();
        }, tmo);
}

//処理からタイマーIDへのハッシュ
doLater.TID = {};
```

使い方の例はこちら↓

```js
function dataTable_onScroll() {
    doLater( function () {
        updateScreen();//画面更新処理
    }, 300);//処理内容によって調整
}
```

[//]:# (@@@)
# async.js

```js
series          関数配列で定義された関数の順番通りにそれらが実行される。

parallel        関数配列で定義された関数を並列に実行する。

parallelLimit   parallelと機能的に同じだが、同時に実行する関数の数を制限できる。

whilst          第一引数の関数で繰り返し条件を管理する。第二引数の関数が繰り返し実行される。

doWhilst        whilstと機能的に似ている。whilstとの違いは関数が実行された後に繰り返し条件をチェックするかどうか。

until           whilstと機能的に似ている。whilstとの違いは、条件が逆になる点。

doUntil         untilと機能的に似ている。untilとの違いは、関数が実行された後に繰り返し条件をチェックするかどうか。

forever         無限ループ。終了条件はエラー検出時のみ。

waterfall       第二引数の関数配列の要素順に関数を実行する。エラーがあればその関数で実行を打ち切る

compose         複数の関数から１つの関数を作る。関数は他の関数の入力となる。

applyEach       第一引数で与えられる関数配列の要素(関数)に、第二引数（第三引数以上も可能)で与えられる値を適用する。

applyEachSeries applyEachと機能的に同じだが、配列の要素順に関数が実行される。

queue           関数を待ち行列に入れて実行する。

cargo           関数をコレクションに入れて実行する。実行順は入れた順番とは限らない。

auto            名前を付けた関数のリスト(ハッシュ)に含まれる関数を実行する。

iterator        関数の反復子を作る。これはasyncで内部的に使われるが、ユーザが使うこともできる。

apply           他の制御フロー関数と一緒に使うと、簡略な書き方ができる。

nextTick        この関数は主にブラウザの互換性を維持するため、asyncで内部的に使われる。

times           第一引数で指定した回数、第二引数の関数を実行する。

timesSeries     機能的にはtimesと同じだが、順次実行が保証される。
```

[//]:# (@@@)
# node.jsを使っているときにsleepするには

async.jsで実現する。

asyncで処理完了を告げる

```js
var async = require('async');

var repeating = 0;
async.forever(function(callback) {
    async.series([
        function(callback) {
            console.log("どっこらせー");
            setTimeout(callback, 1000); //1秒後に処理完了を告げる
        },
        function(callback) {
            console.log("よっこいせー");
            setTimeout(callback, 1000); //1秒後に処理完了を告げる
        },
        function(callback) {
            if (++repeating < 5) {
                callback(); //待たずに処理完了を告げる
            } else {
                console.log("おしまい");
            }
        }
    ], callback);
}, function(err) {
    console.log(err);
});
```

[//]:# (@@@)
# 大量の配列データをゆっくり処理する

## 配列データを1秒周期で非同期処理する

```js
// 配列データを1秒周期で非同期処理する
function asyncProcArray( params, onProcess, onFinish ) {
    var paramList = params.concat();    // 配列のコピーを作る

    (function() {
        var slipNo = paramList.shift();

        onProcess( slipNo );
        if ( paramList.length <= 0 ) {
            onFinish();
            return;
        }

        setTimeout( arguments.callee, 1000 );
    })();
}

function asyncRepeat(params, onProcess, onFinish) {
  var paramList = params.concat(); // 配列のコピーを作る

  (function _doFunc() {
    var slipNo = paramList.shift();

    onProcess(slipNo);
    if (paramList.length <= 0) {
      onFinish();
      return;
    }

    setTimeout(_doFunc, 1000);
  }());
}
```

## 画面が固まることなく、出来る限り速く大量のデータを処理したい場合

```js
function runAcyncArray( params, onProcess, onFinish ) {
    var paramList = params.concat();    // 配列のコピーを作る

    (function() {
        var startTime = new Date(); // 開始時刻を覚える

        //-----------------------------------
        // タイムアウトになるまで処理を行う
        //-----------------------------------
        while ( 1 ) {
            var curParam = paramList.shift();

            //----------------------
            // 配列を1要素処理する
            //----------------------
            onProcess( curParam );

            if ( paramList.length <= 0 ) {
                //--------------------------------------
                // 全要素処理を行った -> 終了処理
                //--------------------------------------
                onFinish( params );
                return;
            }

            if ( (new Date()) - startTime > 100 ) {
                //---------------------------------------
                // タイムアウト発生 -> 一旦処理を終わる
                //---------------------------------------
                break;
            }
        }
        //----------------------------------
        // ちょっと待って続きの処理を行う
        //----------------------------------
        setTimeout( arguments.callee, 40 );
    })();
}
```

[//]:# (@@@)
# JavaScriptでオブジェクトをJSON化する

```js
  /*
   * JSON.stringify(obj)はプロトタイプに対して働かない。
   * JSON.stringify(flatten(obj))のようにして使う。
   */
  function flatten(obj) {
    var result = Object.create(obj);
    for(var key in result) {
      result[key] = result[key];
    }
    return result;
  };
```

[//]:# (@@@)
# faviconの作り方

好きな画像をここにアップロードして作るのが楽

<http://realfavicongenerator.net/>
