# このリポジトリについて

OKF（Open Knowledge Format）を採用した、ドキュメントを残すためのフレームワークを提供する抽象リポジトリ。

このリポジトリをテンプレートにして、具体的なナレッジベースを構築する。

# ドキュメントの書き方について

編集は基本Obsidianで行う。`docs/`をvaultとして開き、概念ごとに1ファイル作る。テンプレートは`docs/_templates/OKF.md`にある。

新規ノートを作るとTemplaterがテンプレートを適用し、created、updatedが埋まる。type、description、tagsは自分で書く。updatedは保存のたびにUpdate time on editが書き換える。

# 使用ツール

- Obsidian
  - docs以下をvaultとして開く。（docsは導入方法のセクションにある通り、リネームする前提）
  - プラグインは`.obsidian/plugins/`ごとリポジトリに入っているので、インストールは要らない。初回だけRestricted modeをオフにする。
  - Templater。新規ノートに`_templates/OKF.md`を当てて、created、updatedを埋める。
  - Update time on edit。保存のたびにupdatedを書き換える。
  - 人が書くのはtype、description、tagsの3つ。
  - テーマはPLNを同梱していて、appearance.jsonで指定している。変えるならSettings > Appearanceから。
- Claude Code
  - 必須ではないが、あると便利。
  - CLAUDE.mdはテンプレートに置いていない。作り方は「導入方法」の6にある。

# 導入方法

## 1. このリポジトリからリポジトリを作る

GitHubの画面で「Use this template」を押すか、CLIなら次を実行する。

```bash
gh repo create my-knowledge-base --template octkmr/okf --private --clone
```

フォークは使わない。理由は「フォークではなくテンプレートを使う理由」に書いた。

## 2. docsをナレッジベースの名前にリネームする

```bash
git mv docs okf-personal
```

※Obsidianのvault名はフォルダ名がそのまま表示される。`docs`のままだと、複数のナレッジベースを開いたときにvault一覧で区別がつかないのでリネームしている。

## 3. Obsidianで開いてプラグインを有効にする

「Open folder as vault」で、2でリネームしたディレクトリを選ぶ。リポジトリのルートを選ぶとREADME.mdもノートとして扱われるので、選ぶのはナレッジベースのディレクトリだけにする。

プラグイン2つは`.obsidian/plugins/`ごとリポジトリに入っているので、インストールは要らない。初回だけSettings > Community pluginsでRestricted modeをオフにする。オフにするまでプラグインは読み込まれず、frontmatterは何も埋まらない。

設定も`.obsidian/`に入っているが、次の2つだけ確認する。

- Settings > Templater > Folder Templates。フォルダが`/`、テンプレートが`_templates/OKF.md`になっていること。フォルダを`_templates`にすると、テンプレート自身を編集したときにしかテンプレートが当たらない。
- Settings > Update time on edit > Date format。`yyyy-MM-dd`と書く。この設定はdate-fnsの記法なので`YYYY-MM-DD`は別の意味になり、既定のままだと時刻まで入ってcreatedと形式がずれる。

Settings > Files and links > Excluded filesに`_templates`を足すと、検索や候補にテンプレート自体が出てこなくなる。

`.obsidian/`はコミットする。設定がリポジトリに残るので、他のマシンでcloneしたときに同じ状態で開ける。workspace.jsonのようなウィンドウの状態だけ.gitignoreで外してある。

## 4. 最初のドキュメントを作る

Obsidianで新規ノートを作り、概念の名前をファイル名にする。created、updatedは自動で埋まるので、type、description、tagsを書く。

## 5. リポジトリの説明を自分のナレッジベースのものに置き換える

README.mdの冒頭にある「このリポジトリについて」を、そのナレッジベースが何を扱うのかの説明に書き換える。あわせて、残っている`docs/`を2でつけた名前に直す。テンプレートの説明のまま残すと、後から来た人がどちらのリポジトリを読んでいるのかわからなくなる。

## 6. （任意）必要ならCLAUDE.mdを作成する

claude codeから`/init`し、調整する。

## テンプレート側の更新を取り込む

OKF.mdや書き方のルールを更新したときは、作ったリポジトリ側で次を実行する。

```bash
git remote add upstream https://github.com/octkmr/okf.git
git fetch upstream
git merge upstream/main --allow-unrelated-histories
```

履歴が繋がっていないので、初回だけ--allow-unrelated-historiesが要る。docsをリネームしているので、テンプレート側でdocs/以下を変更しているとコンフリクトする。
