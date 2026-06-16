# AUCA Dorm Management Backend

PostgreSQL schema + seed data + Node/Express API for running a university dorm: rooms, students, assignments, payments, maintenance, and reporting.

## Stack
- PostgreSQL schema with constraints and soft-delete columns
- Node.js (Express 5, pg, cors, dotenv) REST API
- SQL demos: basic/advanced queries and a transaction walkthrough
- Backups and exports via pg_dump

## Repository map
- `schema.sql` — tables, constraints, defaults, soft deletes on core entities
- `seed.sql` — realistic buildings/rooms/facilities/students/assignments/payments/maintenance records
- `indexes.sql` — tuned indexes for lookups (partial indexes on active assignments)
- `queries_basic.sql` — everyday reporting queries (availability, pending payments, maintenance)
- `queries_advanced.sql` — CTE/window/aggregation samples
- `tx_demo.sql` — transaction demo with savepoints/rollback
- `backup_restore.txt` — pg_dump/pg_restore commands
- `dorm_mgmt_full.sql` / `dorm_mgmt.dump` — full exports of the schema and data
- `server/index.js` — REST API over the `dorm_mgmt` schema

## Prerequisites
- PostgreSQL running locally (user with CREATE/CONNECT on target DB)
- Node.js 18+ and npm
- `psql` available in your PATH

## Database setup
```bash
psql -U <user> -d <db> -f schema.sql
psql -U <user> -d <db> -f seed.sql
psql -U <user> -d <db> -f indexes.sql

# optional demos
psql -U <user> -d <db> -f queries_basic.sql
psql -U <user> -d <db> -f queries_advanced.sql
psql -U <user> -d <db> -f tx_demo.sql
```
`schema.sql` sets `search_path` to `dorm_mgmt, public`.

## Supabase database setup
Use the project SQL files instead of `dorm_mgmt_full.sql` for Supabase. The full dump contains local ownership/export metadata, while these files are cleaner for a Supabase project.

1) Create a Supabase project.
2) Open SQL Editor and run these files in order:
```sql
-- 1. schema.sql
-- 2. seed.sql
-- 3. indexes.sql
```
3) In Supabase Dashboard, open Connect and copy a Postgres URI.
   - For importing with `psql`, use the Direct connection URI.
   - For this long-running Express API, use Direct connection if your network supports IPv6, or Shared Pooler Session mode if you need IPv4.
   - Avoid Transaction pooler mode for this API because the app uses normal PostgreSQL session behavior.
4) Create `Backend/.env` from `.env.example` and set `DATABASE_URL` to the Supabase URI. Keep `?sslmode=require` on the URL.

## API setup
1) Create `.env` with `DATABASE_URL=postgres://user:pass@localhost:5432/<db>` and optional `PORT` (default 4000). For Supabase, copy `.env.example` and replace the placeholder connection string.
2) Install and run:
```bash
npm install
npm start
```
On connect the API enforces `set search_path to dorm_mgmt, public`.

## Frontend connection
The React app reads `VITE_API_URL` and falls back to `http://localhost:4000`.

For local development, start both processes:
```bash
# terminal 1
cd Backend
npm start

# terminal 2
npm run dev
```

If the API is deployed somewhere else, create `dorm-web/.env` from `dorm-web/.env.example` and set `VITE_API_URL` to the backend URL.

## API quick reference
- `GET /api/health` — DB connectivity check.
- Students: `GET /api/students?q=&deleted=`, `POST /api/students`, `DELETE /api/students/:id`, `POST /api/students/:id/restore` (soft delete with 30-day restore window).
- Rooms: `GET /api/rooms?q=&available=&deleted=`, `POST /api/rooms`, `DELETE /api/rooms/:id`, `POST /api/rooms/:id/restore`.
- Payments: `GET /api/payments?q=&deleted=`, `POST /api/payments`, `DELETE /api/payments/:id`, `POST /api/payments/:id/restore`.
- Maintenance: `GET /api/maintenance?q=&deleted=`, `POST /api/maintenance`, `DELETE /api/maintenance/:id`, `POST /api/maintenance/:id/restore`.
- `GET /api/stats` — occupancy rate, totals, pending payments, open maintenance.

## Data highlights
- Soft deletes on `student`, `room`, `payment`, `maintenance_request` with 30-day restoration helper endpoints.
- `assignment` enforces one active record per bed; `payment` links to `assignment` when present.
- Facilities per room via `room_facility`; rooms tied to buildings and room types.
- Backup/restore scripts live in `backup_restore.txt`; full exports are in `dorm_mgmt_full.sql` and `dorm_mgmt.dump`.

## ER diagram
```mermaid
erDiagram
  building ||--o{ room : has
  room_type ||--o{ room : typed
  student ||--o{ assignment : has
  room ||--o{ assignment : has
  room ||--o{ room_facility : has
  facility ||--o{ room_facility : has
  room ||--o{ maintenance_request : has
  maintenance_request ||--o{ maintenance_log : has
  student ||--o{ payment : makes
  assignment ||--o{ payment : relates
```
