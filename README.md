# このリポジトリについて

OKF（Open Knowledge Format）を採用した、ドキュメントを残すためのフレームワークを提供する抽象リポジトリ。

このリポジトリをテンプレートにして、具体的なナレッジベースを構築する。リポジトリは1つで、その下に関心事ごとのvaultを並べる。`docs/`はvaultではなく、コピー元としてそのまま残す。

# ドキュメントの書き方について

編集は基本Obsidianで行う。関心事ごとのディレクトリをvaultとして開き、その中に概念ごとに1ファイル作る。テンプレートは各vaultの`_templates/OKF.md`にある。

新規ノートを作るとTemplaterがテンプレートを適用し、created、updatedが埋まる。type、description、tagsは自分で書く。updatedは保存のたびにUpdate time on editが書き換える。

# 使用ツール

- Obsidian
  - 関心事ごとのディレクトリをvaultとして開く。`docs/`はコピー元なので開かない。
  - プラグインは`.obsidian/plugins/`ごとリポジトリに入っているので、インストールは要らない。初回だけRestricted modeをオフにする。
  - Templater。新規ノートに`_templates/OKF.md`を当てて、created、updatedを埋める。
  - Update time on edit。保存のたびにupdatedを書き換える。
  - 人が書くのはtype、description、tagsの3つ。
  - テーマはPLNを同梱していて、appearance.jsonで指定している。変えるならSettings > Appearanceから。
- Claude Code
  - 必須ではないが、あると便利。
  - CLAUDE.mdはテンプレートに置いていない。作り方は「導入方法」の6にある。
  - 書き方のルールは`.claude/rules/`に置く。リポジトリのルートなので全vault共通になる。

# 導入方法

## 1. このリポジトリからリポジトリを作る

GitHubの画面で「Use this template」を押すか、CLIなら次を実行する。

```bash
gh repo create my-knowledge-base --template octkmr/okf --private --clone
```

## 2. docsをコピーして最初のvaultを作る

関心事の名前でコピーする。

```bash
scripts/new-vault.sh it
git commit -m "it vaultを追加"
```

`docs/`は消さずに残す。以降のvaultも全部ここからコピーするし、リネームしないのでokf側の更新が素直にマージできる。

※Obsidianのvault名はフォルダ名がそのまま表示される。`docs`のまま使うと一覧で区別がつかないので、コピー先に関心事の名前をつけている。

## 3. Obsidianで開いてプラグインを有効にする

「Open folder as vault」で、2でコピーしたディレクトリを選ぶ。リポジトリのルートを選ぶとREADME.mdもノートとして扱われるので、選ぶのはナレッジベースのディレクトリだけにする。

プラグイン2つは`.obsidian/plugins/`ごとリポジトリに入っているので、インストールは要らない。初回だけSettings > Community pluginsでRestricted modeをオフにする。オフにするまでプラグインは読み込まれず、frontmatterは何も埋まらない。

設定も`.obsidian/`に入っているが、次の2つだけ確認する。

- Settings > Templater > Folder Templates。フォルダが`/`、テンプレートが`_templates/OKF.md`になっていること。フォルダを`_templates`にすると、テンプレート自身を編集したときにしかテンプレートが当たらない。
- Settings > Update time on edit > Date format。`yyyy-MM-dd`と書く。この設定はdate-fnsの記法なので`YYYY-MM-DD`は別の意味になり、既定のままだと時刻まで入ってcreatedと形式がずれる。

Settings > Files and links > Excluded filesに`_templates`を足すと、検索や候補にテンプレート自体が出てこなくなる。

`.obsidian/`はコミットする。設定がリポジトリに残るので、他のマシンでcloneしたときに同じ状態で開ける。workspace.jsonのようなウィンドウの状態だけ.gitignoreで外してある。

## 4. 最初のドキュメントを作る

Obsidianで新規ノートを作り、概念の名前をファイル名にする。created、updatedは自動で埋まるので、type、description、tagsを書く。

## 5. リポジトリの説明を自分のナレッジベースのものに置き換える

README.mdの冒頭にある「このリポジトリについて」を、そのナレッジベースが何を扱うのかの説明に書き換える。テンプレートの説明のまま残すと、後から来た人がどちらのリポジトリを読んでいるのかわからなくなる。

## 6. （任意）必要ならCLAUDE.mdを作成する

claude codeから`/init`し、調整する。

## 関心事を増やす

vaultは関心事ごとに1つ作る。ITと仕事なら`it/`と`work/`が並び、それぞれが`.obsidian/`、`_templates/`、`TIMELINE.base`を持つ。

`docs/`からコピーする。スクリプトを用意してある。

```bash
scripts/new-vault.sh work
```

`docs/`をコピーして、ローカル固有のworkspace.jsonと.DS_Storeを取り除き、git addまでやる。コミットは自分でする。

既存のvaultからコピーすると、そのvaultのノートやworkspace.jsonまで付いてくる。コピー元は常に`docs/`にする。スクリプトも`docs/`しか見ない。

コピーなので、プラグイン本体672KBと`.obsidian/`と`_templates/`がvaultの数だけ増える。Templaterの設定やOKF.mdを変えたときは、全vaultに手で反映することになる。2つ3つなら問題ないが、増やすほど反映漏れが起きやすくなる。

vaultをまたぐリンクとバックリンクは繋がらない。検索もTIMELINE.baseもvaultの中で閉じる。関心事が交わるなら、分けずに1つのvaultの中でディレクトリを切ったほうがいい。

## テンプレート側の更新を取り込む

OKF.mdや書き方のルールを更新したときは、作ったリポジトリ側で次を実行する。

```bash
git remote add upstream https://github.com/octkmr/okf.git
git fetch upstream
git merge upstream/main --allow-unrelated-histories
```

履歴が繋がっていないので、初回だけ--allow-unrelated-historiesが要る。2回目以降は`git fetch upstream`と`git merge upstream/main`だけでいい。

`docs/`をリネームしていないので、テンプレート側の変更はそのままマージされる。ただし反映されるのは`docs/`だけで、コピー済みのvaultには届かない。マージのあとにこれを実行する。

```bash
scripts/sync-vaults.sh
```

`docs/`と各vaultの`_templates/`と`.obsidian/`を比べて、違うファイルを並べる。中身を見て問題なければ`--apply`を付けて実行すると配られる。ノートとTIMELINE.baseには触らない。

マージ自体はスクリプトにしていない。2回目以降はfetchとmergeの2コマンドで、コンフリクトが出たらどのみち人が読んで決めることになるため。

# スクリプト

`scripts/`に置いてある。

- `new-vault.sh <名前>`。`docs/`をコピーして新しいvaultを作る。
- `sync-vaults.sh`。`docs/`と各vaultの差分を出す。`--apply`で配る。

名前を覚えていないときはリポジトリのルートで`./run.sh`を叩くと、fzfで一覧から選べる。選んだあとに引数を聞かれるので、そこで渡す。プレビューにスクリプトの先頭が出るので、使い方はそこで確認できる。
