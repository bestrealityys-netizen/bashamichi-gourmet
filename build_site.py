# -*- coding: utf-8 -*-
"""馬車道グルメサイト ビルダー: data/restaurants.json から 馬車道グルメ.html を生成"""
import json, os, html, datetime

BASE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(BASE, "data", "restaurants.json")
OUT = os.path.join(BASE, "index.html")

with open(DATA, encoding="utf-8") as f:
    d = json.load(f)
meta = d["meta"]
restaurants = sorted(d["restaurants"], key=lambda r: (r["distance_min"], -(r.get("rating") or 0)))
total = len(restaurants)
updates = meta.get("updates", [])
data_json = json.dumps(restaurants, ensure_ascii=False)
updates_json = json.dumps(updates, ensure_ascii=False)
station_json = json.dumps({"lat": meta.get("station_lat", 35.4516), "lng": meta.get("station_lng", 139.6388)}, ensure_ascii=False)
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

TPL = os.path.join(BASE, "template.html")
with open(TPL, encoding="utf-8") as f:
    HTML = f.read()

HTML = (HTML
        .replace("__SUBTITLE__", html.escape(meta.get("subtitle", "")))
        .replace("__TOTAL__", str(total))
        .replace("__NOW__", now)
        .replace("__DATA__", data_json)
        .replace("__UPDATES__", updates_json)
        .replace("__STATION__", station_json))

with open(OUT, "w", encoding="utf-8") as f:
    f.write(HTML)
print(f"OK: {OUT}  ({total} restaurants, {len(updates)} updates)")
