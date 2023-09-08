# Pon!通

Pon!通は，なぞぷよに関する様々な機能を提供するツールである．
以下の機能が提供されている．
- GUIアプリケーション：なぞぷよを編集したり自分でプレイしたりする．
    - [【ブラウザで試す】](https://izumiya-keisuke.github.io/pon2/playground/index.html?kind=n&mode=e&field=t-&pairs&req-kind=0&req-color=0)
- ソルバー：なぞぷよを解く．
- ジェネレーター：なぞぷよを生成する．
- ツモ探索：なぞぷよのツモを入れ替えて一意解問題を生成する．
- データベース：なぞぷよを管理する．

GUIアプリケーションのキーボードショートカットは[ドキュメント](./docs/gui.md)を参照．

現在のところ以下の機能には対応していない．
- 壁・固ぷよ・鉄ぷよ
- フィーバーモード
- 途中のお邪魔落下

## インストール

### ビルド済バイナリ

[最新リリース](https://github.com/izumiya-keisuke/pon2/releases/latest)の「Assets」から，使用するOSに応じてダウンロードできる．

**注意：** 現在，ビルド済バイナリはmacOSでは動作しないかもしれない．
これは[GTK+3](https://docs.gtk.org/gtk3/)を利用している[NiGui](https://github.com/simonkrauter/NiGui)の制約によるものである．
手動でのインストールは可能であるはずだが，試していない．

### ソースからビルド

```shell
nimble install https://github.com/izumiya-keisuke/pon2
```

## 使い方

以下のドキュメントを参照．
- [GUIアプリケーション](./doc/gui.md)
- [ソルバー](./doc/solve.md)
- [ジェネレーター](./doc/generate.md)
- [ツモ探索](./doc/permute.md)
- [データベース](./doc/db.md)

## 開発者向け

このモジュールは以下を使用しているので，そちらも参照のこと．
- [puyo-core](https://github.com/izumiya-keisuke/puyo-core)
- [nazopuyo-core](https://github.com/izumiya-keisuke/nazopuyo-core)
- [puyo-simulator](https://github.com/izumiya-keisuke/puyo-simulator)

### APIの利用

`import pon2` でこのモジュールが提供する全てのAPIにアクセスできる．
詳しくは[ドキュメント](https://izumiya-keisuke.github.io/pon2)を参照．

### テスト

```shell
nim c -r tests/makeTest.nim
nimble test
```

`tests/makeTest.nim` をコンパイルする際，`-d:bmi2=<bool>` や `-d:avx2=<bool>` を
オプションとして与えることで，使用する命令セットを指定することができる．

### ベンチマーク

```shell
nim c -r benchmark/main.nim
```

### テストの書き方

1. `tests` ディレクトリ直下に新しいディレクトリを作成する．
1. 作成したディレクトリ内に新しい `main.nim` ファイルを作成する．
1. 作成したファイル内に，テストのエントリーポイントを `main()` プロシージャとして記述する．

### 静的ウェブサイト作成

プロジェクトルートで以下を実行する：

```shell
nim js -d:danger -o:www/index.js src/pon2.nim
npx --yes google-closure-compiler --js www/index.js --js_output_file www/index.min.js
cp -r assets www
```

その後，`www` ディレクトリ以下の全ファイルを目的のディレクトリにコピーする．

### 開発への協力

ブランチを切って作業した上で，`main` ブランチへのPRを出してください．

## ライセンス

Apache-2.0，MPL-2.0のいずれかを選択する．
詳しくは[NOTICE](./NOTICE)を参照．