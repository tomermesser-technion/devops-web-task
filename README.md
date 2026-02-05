# DevOps Web Task

Static website deployment with automation and self-signed SSL.

## Prerequisites

- Linux server with NGINX installed
- Deployment user with write access to `/var/www/devops-site`
- Scripts executable: `chmod +x scripts/*.sh`

## One-time setup (verify before first deploy)

1. **NGINX includes site configs**  
   In `/etc/nginx/nginx.conf`, inside the `http { }` block, ensure:
   ```nginx
   include /etc/nginx/sites-enabled/*;
   ```

2. **Enable this project's sites** (if not already):
   ```bash
   sudo ln -sf /home/tomerm/devops-web-task/nginx/site.conf /etc/nginx/sites-available/devops-site.conf
   sudo ln -sf /home/tomerm/devops-web-task/nginx/site-ssl.conf /etc/nginx/sites-available/devops-site-ssl.conf
   sudo ln -sf /etc/nginx/sites-available/devops-site.conf /etc/nginx/sites-enabled/
   sudo ln -sf /etc/nginx/sites-available/devops-site-ssl.conf /etc/nginx/sites-enabled/
   ```

3. **SSL key/cert**  
   Generate once: `./scripts/ssl_selfsign.sh`  
   Ensure `nginx/devops-site.crt` and `nginx/devops-site.key` exist. Nginx (e.g. `www-data`) must be able to read them (e.g. key `chmod 640`, `chown root:www-data`; dirs from `/home/tomerm` down with `chmod 755` so nginx can traverse).

4. **Site directory**  
   `/var/www/devops-site` exists; deployment user can write, nginx can read (e.g. `chown tomerm:www-data`, `chmod 2775`).

5. **Test and reload NGINX:**  
   `sudo nginx -t && sudo systemctl reload nginx`

## Deploy

```bash
./scripts/deploy.sh
```

Copies `site/` to `/var/www/devops-site`, validates NGINX config, and reloads NGINX.

## Backup

```bash
./scripts/backup.sh
```

Creates a timestamped backup; keeps the last 5.

## Rollback

```bash
./scripts/roll-back.sh
```

Restores the previous deployment from the latest backup.

## Verify it's running

- **HTTPS:** `curl -k https://localhost` → expect 200 and your page
- **Health:** `curl -k https://localhost/health.html` → expect 200
- **Ports:** `sudo ss -tlnp | grep -E '80|443'` → nginx listening on 80 and 443


# simple commit for checking task.