import { getStore } from "@netlify/blobs";

// お気に入り同期API（合言葉ハッシュをキーにBlobsへ保存）
// GET  /.netlify/functions/favs?code=<hash>      → { favs:[...] }
// POST /.netlify/functions/favs  {code,favs}     → { ok:true, count }
export default async (req) => {
  const headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store",
  };
  if (req.method === "OPTIONS") return new Response("", { headers });

  const valid = (c) => typeof c === "string" && /^[a-f0-9]{16,128}$/.test(c);

  try {
    const store = getStore("favorites");

    if (req.method === "GET") {
      const code = new URL(req.url).searchParams.get("code") || "";
      if (!valid(code)) return new Response(JSON.stringify({ favs: [] }), { headers });
      const data = await store.get(code, { type: "json" });
      return new Response(JSON.stringify({ favs: (data && data.favs) || [] }), { headers });
    }

    if (req.method === "POST") {
      const body = await req.json().catch(() => ({}));
      const code = (body && body.code) || "";
      if (!valid(code)) return new Response(JSON.stringify({ error: "invalid code" }), { status: 400, headers });
      const favs = Array.isArray(body.favs)
        ? [...new Set(body.favs.filter((x) => typeof x === "string").slice(0, 2000))]
        : [];
      await store.setJSON(code, { favs, updated: Date.now() });
      return new Response(JSON.stringify({ ok: true, count: favs.length }), { headers });
    }

    return new Response(JSON.stringify({ error: "method not allowed" }), { status: 405, headers });
  } catch (e) {
    return new Response(JSON.stringify({ error: "server", detail: String(e && e.message || e) }), { status: 500, headers });
  }
};
