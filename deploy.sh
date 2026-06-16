#!/usr/bin/env bash
# 馬車道グルメ — Netlify CLI 直接デプロイ（方式A / 手動トリガー）
# 使い方: このフォルダで  bash deploy.sh   を実行
set -euo pipefail
cd "$(dirname "$0")"

SITE_ID="b12d2794-2e7b-4114-9ace-bf6b16b2719e"   # dulcet-florentine-92abf1
TOKEN_FILE=".netlify-token"

if [ ! -f "$TOKEN_FILE" ]; then
  echo "ERROR: $TOKEN_FILE が見つかりません。Netlify個人トークンを保存してください。" >&2
  exit 1
fi
TOKEN="$(tr -d ' \t\r\n' < "$TOKEN_FILE")"

# 1) 最新データから index.html を再生成（python3があれば。無ければ既存を使用）
if [ -f build_site.py ] && command -v python3 >/dev/null 2>&1; then
  python3 build_site.py
fi

# 2) 公開用ディレクトリを用意（サイト本体 index.html のみ。data/ や *.py は除外）
rm -rf _publish && mkdir _publish
cp index.html _publish/

# 3) Netlify CLI で本番デプロイ
npx --yes netlify-cli@latest deploy \
  --prod \
  --dir=_publish \
  --site="$SITE_ID" \
  --auth="$TOKEN" \
  --message "manual deploy $(date +%Y-%m-%d_%H:%M)"

echo "Deployed: h