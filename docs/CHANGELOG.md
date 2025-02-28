# Changelog

## v2.0.1 (2024-02-05)

軽微なバグ修正や改善
- スタイルベクトルに`NaN`が含まれていた場合（主に音声ファイルが極端に短い場合に発生）、それを学習リストから除外するように修正
- colabにマージの追加
- 学習時のプログレスバーの表示がおかしかったのを修正
- デフォルトのjvnvモデルをJP-Extra版にアップデート。新しいモデルを使いたい方は手動で[こちら](https://huggingface.co/litagin/style_bert_vits2_jvnv/tree/main)からダウンロードするか、`python initialize.py`をするか、[このbatファイル](https://github.com/litagin02/Style-Bert-VITS2/releases/download/2.0.1/Update-to-JP-Extra.bat)を`Style-Bert-VITS2`フォルダがある場所（インストールbatファイルとかがあったところ）においてダブルクリックしてください。

## v2.0 (2024-02-03)

### 大きい変更
モデル構造に [Bert-VITS2の日本語特化モデル JP-Extra](https://github.com/fishaudio/Bert-VITS2/releases/tag/JP-Exta) を取り込んだものを使えるように変更、[事前学習モデル](https://huggingface.co/litagin/Style-Bert-VITS2-2.0-base-JP-Extra)も[Bert-VITS2 JP-Extra](https://huggingface.co/Stardust-minus/Bert-VITS2-Japanese-Extra)のものを改造してStyle-Bert-VITS2で使えるようにしました (モデル構造を見直して日本語での学習をしていただいた [@Stardust-minus](https://github.com/Stardust-minus) 様に感謝します)
- これにより、日本語の発音やアクセントや抑揚や自然性が向上する傾向があります
- スタイルベクトルを使ったスタイルの操作は変わらず使えます
- ただしJP-Extraでは英語と中国語の音声合成は（現状は）できません
- 旧モデルも引き続き使うことができ、また旧モデルで学習することもできます
- デフォルトのJVNVモデルは現在は旧verのままです

### 改善
- `Merge.bat`で、声音マージを、より細かく「声質」と「声の高さ」の点でマージできるように。

### バグ修正
- PyTorchのバージョンに由来するバグを修正（torchのバージョンを2.1.2に固定）
- `―`（ダッシュ、長音記号ではない）が2連続すると学習・音声合成でエラーになるバグを修正
- 「三円」等「ん＋母音」のアクセントの仮名表記が「サネン」等になり、また偶にエラーが発生する問題を修正（「ん」の音素表記を内部的には「N」で統一）

## v1.3 (2024-01-09)

### 大きい変更
- 元々のBert-VITS2に存在した、日本語の発音・アクセント処理部分のバグを修正・リファクタリング
    - `車両`が`シャリヨオ`、`思う`が`オモオ`、`見つける`が`ミッケル`等に発音・学習されており、その単語以降のアクセント情報が全て死んでいた
    - `私はそれを見る`のアクセントが`ワ➚タシ➘ワ　ソ➚レ➘オ　ミ➘ル`だったのを`ワ➚タシワ　ソ➚レオ　ミ➘ル`に修正
    - 学習・音声合成で無視されていたアルファベット・ギリシャ文字を無視しないように変更（基本はアルファベット読みだけど簡単な単語は読めるらしい、学習の際は念のためカタカナ等にしたほうがよいです）
    - 修正の影響で、前処理時に（今まで無視されていた）読めない漢字等で引っかかるようになりました。その場合は書き起こしを確認して修正するようにしてください。
- アクセントを調整して音声合成できるように（完全に制御できるわけではないが改善される場合がある）。

これまでのモデルもこれまで通り使え、アクセントや発音等が改善される可能性があります。新しいバージョンで学習し直すとより良くなる可能性もあります。が劇的に良くなるかは分かりません。

### 改善
- `Dataset.bat`の音声スライスと書き起こしをよりカスタマイズできるように（スライスの秒数設定や書き起こしのWhisperモデル指定や言語指定等）
- `Style.bat`のスタイル分けで、スタイルごとのサンプル音声を指定した数だけ複数再生できるように。また新しい次元削減方法（UMAP）と新しいスタイル分けの方法（DBSCAN）を追加（UMAPのほうがよくスタイルが分かれるかもしれません）
- `App.bat`での音声合成時に複数話者モデルの場合に話者を指定できるように
- colabの[ノートブック](http://colab.research.google.com/github/litagin02/Style-Bert-VITS2/blob/master/colab.ipynb)で、音声ファイルのみからデータセットを作成するオプション部分を追加
- クラウド実行等の際にパスの指定をこちらでできるように、パスの設定を`configs/paths.yml`にまとめた（colabの[ノートブック](http://colab.research.google.com/github/litagin02/Style-Bert-VITS2/blob/master/colab.ipynb)もそれに伴って更新）。デフォルトは`dataset_root: Data`と`assets_root: model_assets`なので、クラウド等でやる方はここを変更してください。
- どのステップ数の出力がよいかの「一つの」指標として [SpeechMOS](https://github.com/tarepan/SpeechMOS) を使うスクリプトを追加：
```bash
python speech_mos.py -m <model_name>
```
ステップごとの自然性評価が表示され、`mos_results`フォルダの`mos_{model_name}.csv`と`mos_{model_name}.png`に結果が保存される。読み上げさせたい文章を変えたかったら中のファイルを弄って各自調整してください。あくまでアクセントや感情表現や抑揚を全く考えない基準での評価で、目安のひとつなので、実際に読み上げさせて選別するのが一番だと思います。
- 学習時のウォームアップオプションを機能するように（ [@kale4eat](https://github.com/kale4eat) 様によるPRです、ありがとうございます！）。前処理時に生成される`config.json`の`train`の`warmup_epochs`を変更することで、ウォームアップのエポック数を変更できます。デフォルトは`0`で今までと同じ学習率の挙動です。

### その他
- `Dataset.bat`の音声スライスでノーマライズ機能を削除（学習前処理で行えるため）
- `Train.bat`の音量ノーマライズと無音切り詰めをデフォルトでオフに変更
- 学習時の進捗を全体エポック数で表示し、学習全体の進捗を見やすいように( [@RedRayz](https://github.com/RedRayz) 様によるPRです、ありがとうございます！)
- その他バグ修正等（ [@tinjyuu](https://github.com/@tinjyuu) 様、 [@darai0512](https://github.com/darai0512) 様ありがとうございます！）
- `config.json`にスタイル埋め込み部分を学習しない`freeze_style`オプションを追加（デフォルトは`false`）

### TIPS
- 日本語学習の場合、`config.json`の`freeze_bert`と`freeze_en_bert`を`true`にしておくと、英語と中国語の発話能力が学習の過程で落ちないかもしれませんが、あまり比較していなので分かりません。

## v1.2 (2023-12-31)

- グラボがないユーザーでの音声合成をサポート、`Install-Style-Bert-VITS2-CPU.bat`でインストール。
- Google Colabでの学習をサポート、[ノートブック](http://colab.research.google.com/github/litagin02/Style-Bert-VITS2/blob/master/colab.ipynb)を追加
- 音声合成のAPIサーバーを追加、`python server_fastapi.py`で起動します。API仕様は起動後に`/docs`にて確認ください。（ [@darai0512](https://github.com/darai0512) 様によるPRです、ありがとうございます！）
- 学習時に自動的にデフォルトスタイル Neutral を生成するように。特にスタイル指定が必要のない方は、学習したらそのまま音声合成を試せます。これまで通りスタイルを自分で作ることもできます。
- マージ機能の新規追加: `Merge.bat`, `webui_merge.py`
- 前処理のリサンプリング時に音声ファイルの開始・終了部分の無音を削除するオプションを追加（デフォルトでオン）
- `スタイルテキスト (style text)`がスタイル指定と紛らわしかったので、`アシストテキスト (assist text)`に変更
- その他コードのリファクタリング

## v1.1 (2023-12-29)
- TrainとDatasetのWebUIの改良・調整（一括事前処理ボタン等）
- 前処理のリサンプリング時に音量を正規化するオプションを追加（デフォルトでオン）

## v1.0 (2023-12-27)
- 初版
