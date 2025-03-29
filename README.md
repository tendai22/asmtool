# asmtool
ASXXXX-oriented converters for mame-sbc development environment

M80など、他のアセンブリ言語で記述されたソースファイルを ASXXXX 形式に変換します。

## 使い方

sed 使い倒しているので、Linux/Unix 環境でお願いします。

M80/CP/Mアセンブリ言語形式のZ80ソースファイルを ASXXXX 形式に変換する。

```
$ sh conv.sh emubasic.asm > emu.asm
```

ASZ80 でアセンブルする。

```
$ asz80 -lso s0.asm
```

> s0.lst, s0.sym が生成される。

リスト形式(s0.lst)からモニタロード形式に変換する。

```
$ sh lst2bin.sh s0.lst > s0.load
```

モニタロード形式は、

* アドレスを `=0038' 形式で、
* データを16進数(F3など)で表現する。

以下の例の通り。

```
=0000
F3
=0001
31
ED
80
=0004
C3
41
```

mame-sbc では、実行形式コマンドの引数でモニタロード形式ファイルを指定すると、その位置にロードする。

