# KanaScroll
an utility to customize keyboard and wheel behavior for Japanese Mac users

# これは何？

* macOSで日本語モードから英数字モードに戻るときに英数キーを押さなくても、かなキーを押すだけで英数字モードに戻れる
* macOSで普通のマウスを使っているときにホイールスクロールの加速度を無効に出来る

# 動作確認バージョン

Mojave, Catalina, Big sur (M1での動作確認済)

# 使い方

1. zipファイルをダウンロードして解凍する
1. KanaScroll をアプリケーションフォルダに移動
1. 一旦実行する
1. セキュリティ環境設定の一般タブで KanaScrollを実行可能にする
1. セキュリティ環境設定のプライバシータブのアクセシビリティ設定でKanaScrollを制御可能にする
1. もう一度実行する
1. 適当なWebページを開いてホイールを回して動作確認する
1. うまく動いたらユーザー設定のログイン項目にKanaScrollを追加して再起動

# 設定方法

1. 端末を開く
1. pkill KanaScroll
1. KanaScroll をアプリケーションフォルダから削除
1. 改めて KanaScroll をアプリケーションフォルダに移動
1. パッケージの内容を表示し、Contents/Info.plist をテキストエディタで開く
1. 普通に英数キーで英数字モードに戻りたい場合は LSEnvironment の ks_disable_eisukey を false をする(デフォルトはtrue)
1. スクロール速度を変えたい場合は LSEnvironment の ks_scrollspeed の数字を変更する(デフォルトは3)
1. KanaScroll を再起動する

# アンインストール

1. 端末を開く
1. pkill KanaScroll
1. ユーザー設定のログイン項目からKanaScrollを削除する
1. セキュリティ環境設定のアクセシビリティ設定からKanaScrollを削除する
1. アプリケーションフォルダから　KanaScroll を削除する
