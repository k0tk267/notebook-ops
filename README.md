# minimal-mlops
個人レベルで機械学習の実験を行うときに使うと便利なテンプレート

### セットアップ
最初にpyproject.toml内のnameと環境変数のセットアップを行う必要があるため以下のコマンドを実行
```
make setup \
    project_name=<replace current project name> \
    your_name=<replace your name> \
    your_email=<replace your email> \
    package_name=<replace your package name>
```

### ディレクトリ構成
TODO: あとで書く

### 使い方
##### プログラムの実行方法
```
make run \
    input_file=train.ipynb \
    output_file=result.ipynb \
    batch_size=1 \
    epoch=100
```