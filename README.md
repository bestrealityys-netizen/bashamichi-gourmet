# 馬車道グルメ
みなとみらい線・馬車道駅から近い順の実食グルメガイド（自動生成サイト）。

- `data/restaurants.json` … 店舗データの正本
- `build_site.py` … `template.html` + データから `index.html` を生成
- `site/index.html` … Netlify 公開ファイル（generatorの出力をコピー）
- Netlify continuous deployment: `main` への push で `site/` を自動公開
