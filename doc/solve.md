# ソルバー

なぞぷよの解を求めることができる．

## 使い方

以下のいずれかを実行する：

```shell
pon2 solve <url> [options]
pon2 s <url> [options]
```

例：


```shell
pon2 s https://ishikawapuyo.net/simu/pn.html?Mp6j92mS_o1q1__u03 -b
```

## オプション

| オプション | 説明                                   | デフォルト値 |
| ---------- | -------------------------------------- | ------------ |
| -h         | ヘルプ画面を表示する．                 | しない       |
| -i         | 出力されるURLをIPS形式にする．         | しない       |
| -b         | 生成された問題の解をブラウザで開く．   | 開かない     |
| -B         | 生成された問題をブラウザで開く．       | 開かない     |