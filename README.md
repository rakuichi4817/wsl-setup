# WSL 開発環境セットアップ

Ubuntu on WSL を新規作成したあとに、普段使う開発ツールをまとめてセットアップするためのファイル一式です。

## セットアップされるもの

- Ubuntu パッケージ更新
- Git
- Zsh
- Oh My Zsh
- zsh-autosuggestions
- zsh-syntax-highlighting
- mise
- direnv
- GitHub CLI (`gh`)
- OpenCode
- 日本語ロケール (`ja_JP.UTF-8`)
- `.zshrc`
- Docker Desktop / WSL Integration の確認

> Docker Engine は WSL 内にはインストールしません。Windows 側の Docker Desktop を利用します。

---

## 推奨セットアップ手順

### 1. WSL に Ubuntu をインストール

PowerShell で、インストール可能なディストリビューションを確認します。

```powershell
wsl --list --online
```

例: Ubuntu 26.04 を入れる場合

```powershell
wsl --install -d Ubuntu-26.04
```

インストール後、ユーザー名とパスワードを設定します。

確認:

```powershell
wsl -l -v
```

---

### 2. Docker Desktop の WSL Integration を有効化

Windows の Docker Desktop で次を開きます。

```text
Settings
  > Resources
  > WSL Integration
```

使用する Ubuntu ディストリビューション（例: `Ubuntu-26.04`）を ON にして `Apply` します。

---

### 3. セットアップファイルを一時ディレクトリへ配置

GitHub リポジトリで管理する場合は、WSL 側で `/tmp` に clone する運用を推奨します。

```bash
git clone https://github.com/rakuichi4817/wsl-setup.git /tmp/wsl-setup
cd /tmp/wsl-setup
```

ZIP から使う場合は、展開した `wsl-setup` フォルダへ移動してください。

---

### 4. セットアップスクリプトを実行

```bash
chmod +x setup.sh
./setup.sh
```

途中で `sudo` や `chsh` のパスワードを求められた場合は、Ubuntu 作成時に設定した UNIX ユーザーのパスワードを入力します。

スクリプトは途中のコマンドでエラーが発生すると停止します。

原因を修正したあと、もう一度実行できます。

```bash
./setup.sh
```

---

### 5. Zsh を起動

セットアップ完了後:

```bash
exec zsh
```

確認:

```bash
echo $SHELL
```

通常は次のようになります。

```text
/usr/bin/zsh
```

---

### 6. GitHub CLI へログイン

```bash
gh auth login
```

画面の案内に従って GitHub 認証を行います。

---

### 7. Docker Desktop 連携を確認

```bash
docker version
docker run --rm hello-world
```

`hello-world` が正常に実行できれば Docker Desktop / WSL Integration は利用可能です。

---

### 8. インストール確認

```bash
git --version
zsh --version
mise --version
direnv version
gh --version
opencode --version
docker --version
```

---

## セットアップ後のファイル削除

セットアップ完了後は、`wsl-setup` フォルダ自体は不要です。

`setup.sh` は `.zshrc` をホームディレクトリへコピーし、各ツールもそれぞれのインストール先へ配置するため、セットアップ用ファイルを残しておく必要はありません。

GitHub リポジトリから `/tmp` へ clone した場合は、成功後に削除します。

```bash
cd ~
rm -rf /tmp/wsl-setup
```

### 一連の処理をまとめて実行する場合

```bash
git clone https://github.com/rakuichi4817/wsl-setup.git /tmp/wsl-setup \
  && /tmp/wsl-setup/setup.sh \
  && rm -rf /tmp/wsl-setup
```

`&&` でつないでいるため、`setup.sh` が途中で失敗した場合は `/tmp/wsl-setup` が削除されません。

そのため、失敗時にはファイルを確認して原因を修正し、そのまま再実行できます。

```bash
cd /tmp/wsl-setup
./setup.sh
```

セットアップ成功時だけ一時ファイルが消えるため、この運用を推奨します。

> `setup.sh` 自身の中から自分自身やセットアップディレクトリを削除する方式は、失敗時の調査や再実行がしづらくなるため採用していません。

