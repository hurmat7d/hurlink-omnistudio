const http = require("http");
const PORT = process.env.PORT || 4500;
const JSON_HEADER = { "Content-Type": "application/json" };

const server = http.createServer((req, res) => {
  const url = new URL(req.url, "http://localhost");

  // @endpoint GET /availability
  if (req.method === "GET" && url.pathname === "/availability") {
    const postcode = url.searchParams.get("postcode") || "";

    // Test case: simulate the network system being down
    if (postcode === "000000") {
      res.writeHead(503, JSON_HEADER);
      return res.end(JSON.stringify({ error: "Network system unavailable" }));
    }

    // 122002 has the newest fibre (up to 2 Gig), everywhere else up to 1 Gig
    const maxSpeed = postcode === "122002" ? 2000 : 1000;
    const speeds = maxSpeed === 2000 ? [300, 1000, 2000] : [300, 1000];

    res.writeHead(200, JSON_HEADER);
    return res.end(JSON.stringify({
      postcode: postcode,
      network_type: "FTTH",
      max_speed_mbps: maxSpeed,
      available_speeds: speeds,
      install_lead_time_days: 5
    }));
  }

  res.writeHead(404, JSON_HEADER);
  res.end(JSON.stringify({ error: "Not found" }));
});

server.listen(PORT, () => console.log("HurLink Network API running on " + PORT));