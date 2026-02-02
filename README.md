# DevOps Web Task

Static website deployment with automation and self-signed SSL.

## Prerequisites

- Linux server with NGINX installed.
- Non-root deployment user: `webdeploy`.
- Website root: `/var/www/devops-site` (owned by `webdeploy:webdeploy`, mode `755`).
- NGINX listening on ports 80+443 after HTTPS is configured.