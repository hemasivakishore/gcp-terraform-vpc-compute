#!/bin/bash
set -euo pipefail

# 1. Fetch Live GCP Metadata
META="http://metadata.google.internal/computeMetadata/v1"
H="Metadata-Flavor: Google"

meta_get() { curl -sf -H "${H}" "${META}/$1" 2>/dev/null || echo "unknown"; }

PROJECT_ID=$(meta_get "project/project-id")
INSTANCE_ID=$(meta_get "instance/id")
HOSTNAME=$(meta_get "instance/hostname")
MACHINE_TYPE_FULL=$(meta_get "instance/machine-type")
INSTANCE_TYPE="${MACHINE_TYPE_FULL##*/}"
ZONE_FULL=$(meta_get "instance/zone")
AZ="${ZONE_FULL##*/}"
REGION="${AZ%-*}"
INTERNAL_IP=$(meta_get "instance/network-interfaces/0/ip")
EXTERNAL_IP=$(meta_get "instance/network-interfaces/0/access-configs/0/external-ip")
NETWORK_PATH=$(meta_get "instance/network-interfaces/0/network")
SUBNET_PATH=$(meta_get "instance/network-interfaces/0/subnetwork")

# Config for App Server
APP_SERVER_IP="192.168.4.2"
APP_SERVER_PORT="8080"

apt update -y && apt install -y nginx curl

#############################################
# 2. CREATE EXPRESSIVE UI
#############################################
cat <<EOF >/var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>thehsk.shop | Infrastructure</title>
  <link href="https://fonts.googleapis.com/css2?family=Google+Sans:wght@500;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --m3-surface: #FDF7FF;
      --m3-primary: #6750A4;
      --m3-primary-container: #EADDFF;
      --m3-secondary-container: #E8DEF8;
      --m3-tertiary-container: #FFD8E4;
      --m3-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    body {
      font-family: 'Google Sans', sans-serif;
      background-color: var(--m3-surface);
      margin: 0; padding: 0;
      color: #1C1B1F;
    }

    #hub-view, #results-view { padding: 60px 24px; max-width: 1000px; margin: 0 auto; }
    #hub-view { display: flex; flex-direction: column; align-items: center; }

    .hero-title { font-size: 3.5rem; font-weight: 700; margin: 0; letter-spacing: -1.5px; }
    .hero-sub { font-size: 1.2rem; opacity: 0.7; margin-bottom: 48px; }

    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 24px; width: 100%;
    }

    .hub-card {
      background: white; border-radius: 32px; padding: 32px; cursor: pointer;
      border: 1px solid #CAC4D0; transition: all 0.4s var(--m3-spring);
    }

    .hub-card:hover {
      transform: translateY(-10px); background: var(--m3-primary-container); border-color: transparent;
    }

    /* Results Styling */
    .back-btn {
      background: var(--m3-primary); color: white; border: none; padding: 14px 28px;
      border-radius: 24px; font-weight: 700; cursor: pointer; margin-bottom: 40px;
    }

    .expressive-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;
    }

    .m3-item {
      background: var(--m3-secondary-container); border-radius: 28px; padding: 24px;
      animation: popIn 0.5s var(--m3-spring) both;
    }

    .d-key { display: block; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.7; margin-bottom: 4px; }
    .d-val { display: block; font-size: 1.1rem; font-weight: 700; word-break: break-all; }

    @keyframes popIn {
      from { opacity: 0; transform: scale(0.8) translateY(20px); }
      to { opacity: 1; transform: scale(1) translateY(0); }
    }
  </style>
</head>
<body>

  <div id="hub-view">
    <h1 class="hero-title">thehsk.shop Infrastructure Hub</h1>
	<h1 class="hero-title">V Hema Siva Kishore</h1>
    <p class="hero-sub">Live GCP Metadata Dashboard</p>
    <div class="card-grid">
      <div class="hub-card" onclick="showInfra()">
        <span style="font-size: 2.5rem;">🏗️</span>
        <h3>Infrastructure</h3>
        <p>Live Compute & Network Metadata</p>
      </div>
      <div class="hub-card" onclick="showMedia('movies')">
        <span style="font-size: 2.5rem;">🎬</span>
        <h3>Movie API</h3>
        <p>Database Driven Content</p>
      </div>
      <div class="hub-card" onclick="showMedia('songs')">
        <span style="font-size: 2.5rem;">🎵</span>
        <h3>Songs API</h3>
        <p>Musical Library Entries</p>
      </div>
    </div>
  </div>

  <div id="results-view" style="display:none;">
    <button class="back-btn" onclick="goHome()">← Back</button>
    <h2 id="view-title" style="font-size: 2.5rem; margin-bottom: 32px;"></h2>
    <div id="data-container" class="expressive-grid"></div>
  </div>

  <script>
    const infraData = [
      { k: "Project ID", v: "${PROJECT_ID}" },
      { k: "Instance ID", v: "${INSTANCE_ID}" },
      { k: "Machine Type", v: "${INSTANCE_TYPE}" },
      { k: "Zone", v: "${AZ}" },
      { k: "Region", v: "${REGION}" },
      { k: "Internal IP", v: "${INTERNAL_IP}" },
      { k: "External IP", v: "${EXTERNAL_IP}" },
      { k: "Hostname", v: "${HOSTNAME}" },
      { k: "Network Path", v: "${NETWORK_PATH}" },
      { k: "Subnet Path", v: "${SUBNET_PATH}" }
    ];

    function showInfra() {
      renderView("Infrastructure Metadata", infraData.map((d, i) => \`
        <div class="m3-item" style="background:#D1E4FF; animation-delay: \${i * 0.05}s">
          <span class="d-key">\${d.k}</span>
          <span class="d-val">\${d.v}</span>
        </div>
      \`).join(''));
    }

    async function showMedia(type) {
      renderView(\`\${type.toUpperCase()} API\`, "Loading...");
      try {
        const res = await fetch(\`/\${type}/\`);
        const data = await res.json();
        const color = type === 'movies' ? 'var(--m3-primary-container)' : 'var(--m3-tertiary-container)';
        
        document.getElementById('data-container').innerHTML = data.map((item, i) => \`
          <div class="m3-item" style="background:\${color}; animation-delay: \${i * 0.1}s">
            <span class="d-val">\${item}</span>
          </div>
        \`).join('');
      } catch (e) { document.getElementById('data-container').innerHTML = "Fetch Error"; }
    }

    function renderView(title, content) {
      document.getElementById('hub-view').style.display = 'none';
      document.getElementById('results-view').style.display = 'block';
      document.getElementById('view-title').innerText = title;
      document.getElementById('data-container').innerHTML = content;
    }

    function goHome() {
      document.getElementById('hub-view').style.display = 'flex';
      document.getElementById('results-view').style.display = 'none';
    }
  </script>
</body>
</html>
EOF

# Nginx Proxy Configuration
cat <<EOF >/etc/nginx/sites-available/default
server {
    listen 80;
    location / { root /var/www/html; index index.html; }
    location /movies/ { proxy_pass http://${APP_SERVER_IP}:${APP_SERVER_PORT}/movies; }
    location /songs/ { proxy_pass http://${APP_SERVER_IP}:${APP_SERVER_PORT}/songs; }
}
EOF

systemctl restart nginx
