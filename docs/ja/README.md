# minimal-mlops
個人レベルで機械学習の実験を行うときに使うと便利なテンプレート  
[一人寂しく行う小規模MLOps](https://k0tk267.github.io/posts/minimal-mlops)というブログにその他説明を書いた

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
```
.
├── data
│   ├── processed          <- 生データに手を加えた後のデータを入れるフォルダ
│   ├── raw                <- 生データを入れるフォルダ
│   └── results
│         ├── experiments  <- 実験ごとのログやモデルを入れるフォルダ
│         └── notebooks    <- papermillで実行した結果のNotebookが自動で入るフォルダ
├── docs
│   └── ja                 <- 日本語のドキュメントを入れるフォルダ
├── scripts
│   ├── run.py             <- papermillでNotebookを実行するときに使うファイル
│   ├── run.py             <- papermillでNotebookを実行するときに使うファイル
│   └── setup.sh           <- このテンプレート利用時の初期セットセットアップを行うファイル
├── src
│   ├── lib                <- クラスや関数に切り出したものを格納するフォルダ
│   └── notebooks          <- Notebookを格納するフォルダ
├── .env.example           <- 環境変数を格納するファイル
├── .gitignore             <- Git管理下から除外するファイル等を指定するファイル
├── .rsyncignore           <- rsyncで同期を行う際に除外するファイル等を指定するファイル
├── docker-compose.yml     <- コンテナ管理の設定をしているファイル
├── Dockerfile             <- Docker Imageを構築するファイル
├── poetry.lock            <- ライブラリを管理するファイル
├── pyproject.toml         <- ライブラリを管理するファイル
└── README.md              <- リポジトリの説明等を書くファイル
```

##### data ディレクトリについて
基本的にデータを入れる場所だが、例外的に**papermillで生成されたNotebook**に関してはログをみなしてこのディレクトリに入れる。加えて**rawディレクトリに入れたデータ**に関しては**手を加えなければ地球が滅亡してしまう**ような場合を除いて**絶対に手を加えてはならない**。前処理を行ったデータ等に関してはすべてprocessedに格納すること。

##### scripts ディレクトリについて
ここに実行するコマンドの**ロジック**を書いたファイルを格納する。コマンド自体はMakefileに定義する。

##### src ディレクトリについて
libにはスクリプトファイル(.py)、notebooksにはNotebook(.ipynb)を入れる。基本的にNotebookを実行して結果を見る想定なので、lib配下のファイルはNotebookからimportして使う想定。

##### Dckerfileとdocker-compose.ymlについて
完全に環境依存の問題を無くしたい場合のためにDockerfileとdocker-compose.ymlを作成して置いているが、元々作成している実行スクリプトはDocker上で動作するようにはしていない。Dockerだと割り当てメモリの制限があるので、メモリを大量に必要とする場合にマシンのフルスペックを使えないためこのようにしている。

##### pyproject.tomlとpoetry.lockについて
Poetryを用いてライブラリを管理するために用いる。デフォルトで、`papermill`, `python-dotenv`, `black`, `isort`, `jupyterlab`に関してはインストールしている。Pythonのバージョンは`3.8`で設定しているため、それ以外のバージョンを用いている場合恐らくライブラリをインストールする際にエラーか警告が出るはず。

### 使い方
基本的にNotebookを使って分析する事を想定している。  
個人的にNotebookは再現性の問題やバグの温床になると思っているのでなるべく実験等に使いたくないが、レポーティング等の用途では便利なため、なるべく再現性やバグに問題が無いように使えるようにするという目的のもの作成している。
##### Notebookの実行方法
Notebookを実行する際にはすべて[papermill](https://github.com/nteract/papermill)を用いて実行するようにする。逆に言うと、papermillを用いずに実行されたNotebokに関しては信用できないNotebookとして捉えることとする。  
以下に記載したコマンドを用いてNotebookを実行する。
input_fileには`src/notebooks`以下に配置したNotebookの名前を指定し、output_fileには新しく生成されるNotebookの名前を入れると、`data/results/notebooks`配下にoutput_fileに記載した名前にタイムスタンプがついたNotebookが生成される。この生成されたNotebookは保存用にしておき、決して改変してはならない（権限を変えない限りは上書きできないようにしている）。
```
make run \
    input_file=train.ipynb \
    output_file=result.ipynb \
    batch_size=1 \
    epoch=100
```

##### 予め作成しているコマンド
- Notebookの実行コマンド
```
make run \
    input_file=train.ipynb \
    output_file=result.ipynb \
    batch_size=8 \
    epoch=1000
```
- 初期設定用のコマンド
```
make setup \
    project_name="Treadstone" \
    your_name="Jason Bourne"
    your_email="Jason@Bourne.com"
    package_name="treadstone"
```
- フォーマット用のコマンド
  - `src/lib`と`scripts/`配下のPythonファイルに関してformatterを実行する
  - linterに関しては手作業で直すのがめんどくさいので入れていない
```
make format
```

- 計算機サーバーとファイルの同期を行うコマンド
  - `make sync-push`はファイルを送信したい時（ローカルのファイル変更を同期したい時）、`make sync-pull`はファイルを受信したい時（実験結果をローカルに持ってきたい時）に用いる
```
make sync-push TARGET_DIR="Jason@Bourne.com:/treadstone"
or
make sync-pull TARGET_DIR="Jason@Bourne.com:/treadstone"
```