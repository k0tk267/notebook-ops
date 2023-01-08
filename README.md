# minimal-mlops
個人レベルで機械学習の実験を行うときに使うと便利なテンプレート

### 使い方
最初にpyproject.toml内のnameと環境変数のセットアップを行う必要があるため以下のコマンドを実行
```
make setup \
    project_name=<replace current project name> \
    your_name=<replace your name> \
    your_email=<replace your email> \
    package_name=<replace your package name>
```