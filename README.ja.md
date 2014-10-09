FileCharLicker
====

Ruby 用のライブラリです。

主な機能は以下。

- 文字ベースでのファイルポインタ位置移動
- ポインタ前後の文字列を得る
- マルチバイト文字対応

## Installation

```ruby
gem install file_char_picker
```

## Usage

### attach (初期化)

FileCharLicker の機能を利用するには、まず File インスタンスを初期化する必要があります。

```ruby
file = open(path)
FileLineSeeker.attach(file, encoding)
```

引数 _file_ は 初期化する File オブジェクトのインスタンスです。

引数 _encoding_ は文字エンコーディングの設定です。 utf8, eucjp, jis, sjis か、それぞれの接頭辞を渡してください。省略するとアスキー文字のみの対応となります。

初期化すると、以下のインスタンスメソッドが使用できるようになります。

### around_lines

```ruby
file.around_lines(needle)
```

実行時のファイルポインタ位置を中心に、引数 needle が含まれる行を前後に検索し、文字列を返します。引数 _needle_ は String オブジェクトか Regexp オブジェクトが利用可能です。

連続する前後にマッチする行がなかった場合は、空文字列が返ります。

実行時のファイルポインタは、行頭を想定しています。

### backward_char

```ruby
file.backward_char
```

実行時のファイルポインタ位置から、一文字前の文字を得ます。主にマルチバイト文字の処理に使用します。

一文字前の文字がない場合、 nil が返ります。

### backward_lines

```ruby
file.backward_lines(size)
```

実行時のファイルポインタ位置から、引数 _size_ で指定した行数分前の文字列を得ます。指定行数に到達する前にファイルの先頭に達した場合、それまでの文字列を返します。

実行時のファイルポインタは、行頭を想定しています。

### current_line

```ruby
file.current_line
```

実行時のファイルポインタ位置が含まれる行の文字列を得ます。

### forward_lines

```ruby
file.forward_lines(size)
```

実行時のファイルポインタ位置から、引数 _size_ で指定した行数分後ろの文字列を得ます。指定行数に到達する前にファイルの末尾に達した場合、それまでの行数を返します。

実行時のファイルポインタは、行頭を想定しています。

### seek_contiguous_min

```ruby
file.scan_contiguous_min(needle)
```

実行時のファイルポインタ位置を中心に、引数 needle が含まれる行を前方に検索し、最初の行の先頭のポインタ位置に移動します。引数 _needle_ は String オブジェクトか Regexp オブジェクトが利用可能です。

移動成功時、そのポインタ位置を格納した Integer オブジェクトを返します。正しく移動できなかった場合 (前方に一致する行がなかった場合) 、 nil が返ります。

### seek_contiguous_max

```ruby
file.scan_contiguous_min(needle)
```

実行時のファイルポインタ位置を中心に、引数 needle が含まれる行を後方に検索し、最終行の末尾のポインタ位置に移動します。引数 _needle_ は String オブジェクトか Regexp オブジェクトが利用可能です。

移動成功時、そのポインタ位置を格納した Integer オブジェクトを返します。正しく移動できなかった場合 (後方に一致する行がなかった場合) 、 nil が返ります。

### seek_line_head

```ruby
file.seek_line_head
```

実行時のファイルポインタ位置を基準に、ポインタを行の先頭に移動させます。

## Author

[indeep-xyz](http://indeep.xyz/)