# Changelog - Proiect IDP (Board Game Management - "Tabletop")

Toate schimbarile notabile pentru acest proiect sunt documentate in acest fisier.

## [Etapa 3] - Forma finala

### Adaugat

**Catalog Service (microserviciu nou - Business Logic):**
- Implementare in Python 3.11 + Flask
- Endpoint `GET /catalog` cu filtrare (categorie, dificultate, jucatori, search, in_stock, paginare limit/offset)
- Endpoint `GET /catalog/<id>` pentru detalii joc
- Endpoint `GET /catalog/categories` pentru listare categorii distincte
- Endpoint `GET /catalog/<id>/stock` pentru verificare stoc
- Endpoint protejat cu JWT `POST /catalog` pentru adaugare joc nou
- Endpoint protejat cu JWT `PUT /catalog/<id>` pentru modificare joc
- Endpoint `/health` pentru health checks
- Endpoint `/metrics` Prometheus cu counter de requests si histograma de latente

**Order Service - extins:**
- Endpoint `GET /orders` - listeaza comenzile user-ului autenticat
- Endpoint `GET /orders/<id>` - detalii comanda + items (cu verificare proprietate)
- Endpoint `POST /orders/<id>/cancel` - anuleaza comanda pending si restaureaza stocul
- `SELECT ... FOR UPDATE` pe `games` la plasare comanda pentru a preveni race conditions
- Metrici Prometheus: `orders_placed_total`, `orders_failed_total{reason}`
- Logging structurat
- `/health` si `/metrics` endpoints

**Auth Service - imbunatatit:**
- Endpoint `GET /auth/verify` - validare JWT (util pentru alte servicii sau pentru Kong)
- Coloana `email` adaugata in tabela users (folosita pentru sync JIT in order-service)
- Tratare 409 pentru username duplicat (constraint unique)
- Metrici Prometheus (counter + histograma + default Node.js metrics)
- Logging mai detaliat

**Infrastructura Docker Swarm (`docker-stack.yml`):**
- Trei retele overlay separate logic: `public_net`, `data_net`, `monitor_net`
- Deploy tags pentru fiecare serviciu: `placement.constraints`, `replicas`, `restart_policy`, `update_config` (cu `order: start-first` si `failure_action: rollback`), `labels`
- Microserviciile (auth/catalog/order) ruleaza pe workers cu 2 replici fiecare
- DB-urile (auth-db, tabletop-db) plasate pe manager (state persistent)
- cAdvisor si node-exporter in `mode: global` (cate o instanta per nod)

**Kong API Gateway:**
- Configurare declarativa (`kong/kong.yml`), DB-less mode
- Rute expuse: `/auth/*`, `/catalog/*`, `/buy/*`, `/orders/*`
- Plugin-uri activate: `rate-limiting`, `cors`, `prometheus`
- Admin API expusa pe :8001 pentru observabilitate

**Portainer CE:**
- Adaugat pentru gestiune UI a clusterului Swarm
- Configurat sa se conecteze la `docker.sock` local
- Expus pe portul 9000

**Stack de monitoring (logging + observabilitate):**
- Prometheus (v2.52) cu scraping pe toate microserviciile + Kong + cAdvisor + node-exporter
- Grafana (v11) cu auto-provisioning de datasource + dashboard pre-configurat
- Dashboard "IDP Microservices Overview" cu: RPS per endpoint, total orders placed/failed, latente p95
- cAdvisor (per-container metrics) si node-exporter (host metrics) in mode global

**Initializare automata baze de date:**
- `order-service/init/01-schema.sql` cu schema completa + indecsi
- `order-service/init/02-data.sql` cu 12 jocuri seed (Catan, Wingspan, Azul, Codenames, Terraforming Mars, Pandemic, 7 Wonders Duel etc.)
- Montate prin `/docker-entrypoint-initdb.d/` ca sa se ruleze la primul start

**GitHub Actions CI/CD:**
- Per microserviciu (auth/catalog/order): `.github/workflows/ci.yml` cu lint + build imagine Docker + push pe ghcr.io
- In main-service: `.github/workflows/deploy.yml` cu validate pentru toate fisierele de configurare (docker-compose.yml, docker-stack.yml, kong.yml, prometheus.yml, dashboard JSON, SQL scripts)
- Secrets pentru aplicatie (DB credentials, JWT, pgAdmin) configurate la nivel de repo

### Modificat

- Migrare completa de la `bridge` networks la `overlay` networks pentru a putea rula pe Swarm
- Toate Dockerfile-urile au acum `HEALTHCHECK` (curl pe `/health`)
- Pinned versions pentru toate imaginile (postgres:15, kong:3.7, prometheus:v2.52.0, grafana:11.0.0 etc.) - reproducibilitate
- Variabilele de mediu centralizate in `.env` la radacina

### Reparate

- DB `tabletop_db` pornea gol - acum se incarca automat schema + seed data prin `docker-entrypoint-initdb.d`
- Race condition la cumparare simultana - adaugat `FOR UPDATE` row lock
- Inconsistenta `DB_PASSWORD` vs `DB_PASS` intre cele doua docker-compose-uri
- Coloana `email` lipsea din `auth_db.users`, dar codul order-service o astepta in JWT - acum auth o cere la register si o include in token

---

## [Etapa 2] - Progres 40%

### Adaugat

- **Infrastructura Docker:**
  - Configuratie multi-container folosind `docker-compose`
  - Izolarea serviciilor in retele separate (`public_net` pentru API-uri si `data_net` pentru baze de date)
  - Persistenta datelor folosind volume Docker pentru PostgreSQL

- **Serviciul de Autentificare (Auth Service):**
  - Implementare in Node.js si Express
  - Endpoint pentru inregistrare (`/auth/register`) cu hashing de parole (Bcrypt)
  - Endpoint pentru login (`/auth/login`) cu generare de token-uri JWT

- **Serviciul de Gestiune (Order/IO Service):**
  - Implementare in Python cu Flask
  - Conexiune functionala cu baza de date principala pentru extragerea catalogului de jocuri

- **Baze de date:**
  - `auth_db`: Instanta PostgreSQL dedicata securitatii
  - `tabletop_db`: Instanta PostgreSQL pentru datele de business
  - Scripturi de initializare SQL pentru schemele tabelelor (`init.sql`)

### Modificat

- Migrarea arhitecturii de la un singur monolit la microservicii decuplate
- Imbunatatirea securitatii prin eliminarea stocarii parolelor in format plain-text

### Reparate

- Rezolvarea erorilor de constrangere la ID-urile tabelelor prin implementarea tipului `SERIAL` in PostgreSQL
- Corectarea conectivitatii intre containere prin utilizarea variabilelor de mediu in `.env`

