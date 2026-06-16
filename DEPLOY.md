# Netlify デプロイ手順（方式A / CLI直接デプロイ）

対象サイト: **dulcet-florentine-92abf1**
公開URL: https://dulcet-florentine-92abf1.netlify.app
site-id: `b12d2794-2e7b-4114-9ace-bf6b16b2719e`

## 仕組み
`index.html` 単体が完成済みのサイト本体です（データは中に埋め込み済み、外部参照は食べログURLのみ）。
デプロイ時は `_publish/` に `index.html` だけをコピーし、Netlify CLI で本番公開します。
`data/` や `*.py`、`.netlify-token` は公開対象に含めません。

## 事前準備（初回のみ）
1. PC に Node.js をインストール: https://nodejs.org （LTS版でOK）
2. トークンは `.netlify-token` に保存済み（このフォルダ内）。
   - 再発行する場合: https://app.netlify.com/user/applications → Personal access tokens

## デプロイ方法（手動トリガー）
### Windows
`deploy.bat` をダブルクリック（または コマンドプロンプトで `deploy.bat`）。

### Mac / Linux / WSL / Git Bash
```bash
bash deploy.sh
```

初回はNetlify CLIの取得に少し時間がかかります（2回目以降はキャッシュで高速）。
完了後、上記URLに最新の `index.html` が反映されます。

## 補足
- このフォルダの `index.html` は scheduled task（毎日のグルメ情報更新）で再生成されます。
  更新を公開したいタイミングで上記デプロイを手動実行してください。
- Cowork（クラウド側）からは Netlify への直接通信が遮断されているため、
  デプロイはこの **手元のPC** で実行する方式にしています。
- `.netlify-token` は秘密情報です。共有・Git公開しないでください（`.gitignore` 済み）。
