# Question2Answer (Q2A) – Dockerized (PHP 8.1 + Apache)

This repository provides a **Dockerized setup for Question2Answer (Q2A)** using **PHP 8.1 and Apache**, with automatic configuration via environment variables.

It is designed to be:
- Easy to run
- Easy to configure
- Production-ready
- Database-agnostic (MySQL / MariaDB)

---

## 🚀 Features

- PHP 8.1 + Apache
- Apache `mod_rewrite` enabled
- MySQL / MariaDB support
- Automatic Q2A database configuration at container startup
- Clean permissions for Apache (`www-data`)
- No manual file editing required

---

## 📦 Docker Image

You can build the image yourself or pull it from Docker Hub.

### Build locally

```bash
docker build -t my-q2a:1.0 .
```

---

## ▶️ Running the Container

### Example `docker run`

```bash
docker run -d \
  --name q2a \
  -p 80:80 \
  -e DB_HOST=mysql \
  -e DB_USER=q2auser \
  -e DB_PASS=secret \
  -e DB_NAME=q2adb \
  my-q2a:1.0
```

Then open your browser:

```
http://localhost:80
```

---

## 🐳 Example `docker-compose.yml`

```yaml
version: "3.9"

services:
  q2a:
    image: my-q2a:1.0
    ports:
      - "80:80"
    environment:
      DB_HOST: mysql
      DB_USER: q2auser
      DB_PASS: secret
      DB_NAME: q2adb
    depends_on:
      - mysql

  mysql:
    image: mysql:9.6.0
    environment:
      MYSQL_DATABASE: q2adb
      MYSQL_USER: q2auser
      MYSQL_PASSWORD: secret
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

---

## ⚙️ Environment Variables

| Variable | Description |
|--------|------------|
| `DB_HOST` | MySQL hostname |
| `DB_USER` | MySQL username |
| `DB_PASS` | MySQL password |
| `DB_NAME` | MySQL database name |

---

## 🧠 How Configuration Works

At container startup, an `entrypoint.sh` script updates the database configuration inside `qa-config.php` automatically using the environment variables above.

---

## 📂 File Structure

```
/var/www/html
├── index.php
├── qa-config.php
├── qa-content/
├── qa-include/
├── qa-plugin/
├── qa-theme/
└── .htaccess
```

---

## 🔐 Permissions

All files are owned by `www-data` so Apache can write cache and uploads.

---

## 📄 License

Question2Answer is licensed under the **GPL v2**.
This Docker setup is provided as-is.

---

## 🙌 Credits

- https://www.question2answer.org/
- Docker PHP Official Image
