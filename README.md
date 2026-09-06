# このリポジトリについて

OKF（Open Knowledge Format）で書いたドキュメントを置くリポジトリ。関心事ごとにvaultを並べて、Obsidianで編集する。

`docs/`はvaultではなく、新しいvaultを作るときのコピー元。設定とテンプレートの元がここに1つある。

# ドキュメントの書き方について

関心事ごとのディレクトリをvaultとして開き、その中に概念ごとに1ファイル作る。テンプレートは各vaultの`_templates/OKF.md`にある。

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
  - 必須ではないが、あると便利。CLAUDE.mdは必要になったら`/init`で作る。
  - 書き方のルールは`.claude/rules/`に置く。リポジトリのルートなので全vault共通になる。

# 使い方

## vaultを作る

関心事の名前で作る。ITと仕事なら`it/`と`work/`が並び、それぞれが`.obsidian/`、`_templates/`、`TIMELINE.base`を持つ。

```bash
scripts/new-vault.sh it
git commit -m "it vaultを追加"
```

`docs/`をコピーして、ローカル固有のworkspace.jsonと.DS_Storeを取り除き、git addまでやる。コミットは自分でする。

vaultをまたぐリンクとバックリンクは繋がらない。検索もTIMELINE.baseもvaultの中で閉じる。関心事が交わるなら、分けずに1つのvaultの中でディレクトリを切る。

## Obsidianで開いてプラグインを有効にする

「Open folder as vault」でvaultのディレクトリを選ぶ。リポジトリのルートを選ぶとREADME.mdもノートとして扱われるので、選ぶのはvaultのディレクトリだけにする。

プラグイン2つは`.obsidian/plugins/`ごとリポジトリに入っているので、インストールは要らない。初回だけSettings > Community pluginsでRestricted modeをオフにする。オフにするまでプラグインは読み込まれず、frontmatterは何も埋まらない。

設定も`.obsidian/`に入っているが、次の2つだけ確認する。

- Settings > Templater > Folder Templates。フォルダが`/`、テンプレートが`_templates/OKF.md`になっていること。フォルダを`_templates`にすると、テンプレート自身を編集したときにしかテンプレートが当たらない。
- Settings > Update time on edit > Date format。`yyyy-MM-dd`と書く。この設定はdate-fnsの記法なので`YYYY-MM-DD`は別の意味になり、既定のままだと時刻まで入ってcreatedと形式がずれる。

Settings > Files and links > Excluded filesに`_templates`を足すと、検索や候補にテンプレート自体が出てこなくなる。

`.obsidian/`はコミットする。設定がリポジトリに残るので、他のマシンでcloneしたときに同じ状態で開ける。workspace.jsonのようなウィンドウの状態だけ.gitignoreで外してある。

## ドキュメントを作る

Obsidianで新規ノートを作り、概念の名前をファイル名にする。created、updatedは自動で埋まるので、type、description、tagsを書く。

## docsを更新したとき

`docs/`のテンプレートやプラグイン設定を変えても、既存のvaultには届かない。変えたら配る。

```bash
scripts/sync-vaults.sh
```

`docs/`と各vaultの`_templates/`と`.obsidian/`を比べて、違うファイルを並べる。中身を見て問題なければ`--apply`を付けて実行すると配られる。ノートとTIMELINE.baseには触らない。

vaultの数だけプラグイン本体672KBと`.obsidian/`が増える。数が増えるほど配り忘れが起きやすくなるので、vaultは必要な分だけにする。

# スクリプト

`scripts/`に置いてある。

- `new-vault.sh <名前>`。`docs/`をコピーして新しいvaultを作る。
- `sync-vaults.sh`。`docs/`と各vaultの差分を出す。`--apply`で配る。

名前を覚えていないときはリポジトリのルートで`./run.sh`を叩くと、fzfで一覧から選べる。選んだあとに引数を聞かれるので、そこで渡す。プレビューにスクリプトの先頭が出るので、使い方はそこで確認できる。
