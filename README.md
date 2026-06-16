# AUCA Dorm Management System

A full-stack dormitory management system for AUCA admins. The app manages students, rooms, payments, maintenance requests, and soft-delete recovery through a React dashboard backed by an Express API and PostgreSQL/Supabase database.

## Features

- Admin login gate for local access.
- Dashboard with total students, rooms, occupancy, pending payments, and open maintenance.
- Students table with search, create, soft delete, and recovery.
- Rooms inventory with building, capacity, facilities, occupancy, and room status.
- Payments table with period, amount, method, status, create, soft delete, and recovery.
- Maintenance requests with priority, status, description, create, soft delete, and recovery.
- Light/dark mode.

Default local login:

```text
username: admin
password: admin123
```

## Tech Stack

- Frontend: React 19, Vite, Tailwind CSS 4, Lucide React
- Backend: Node.js, Express, pg, cors, dotenv
- Database: PostgreSQL, with Supabase Postgres support
- Tooling: npm, ESLint

## Project Structure

```text
dorm-web/
├── Backend/
│   ├── server/index.js       # Express REST API
│   ├── schema.sql            # PostgreSQL schema
│   ├── seed.sql              # Sample dorm data
│   ├── indexes.sql           # Database indexes
│   ├── queries_basic.sql
│   ├── queries_advanced.sql
│   ├── tx_demo.sql
│   ├── package.json
│   └── README.md
├── src/
│   ├── app.jsx               # Main React app
│   ├── index.css             # Tailwind entry and base styles
│   └── utils/supabase/       # Supabase browser client helper
├── public/
├── package.json
├── vite.config.js
├── tailwind.config.js
└── README.md
```

## Database Model

Core tables:

- `building` and `room_type`: reference data for floors/buildings, capacity, and rates.
- `room`: room inventory, status, and soft-delete support.
- `student`: student records.
- `assignment`: student-to-room assignment with bed number and active state.
- `payment`: payment period, amount, method, status, and optional assignment link.
- `maintenance_request` and `maintenance_log`: maintenance issue tracking and status history.

Soft deletes use `deleted_at` on major entities. Normal API reads hide deleted records, while the Recovery page can restore records within the configured 30-day window.

## Environment Variables

Create these files locally. Do not commit real `.env` files or database passwords.

Frontend `.env.local`:

```env
VITE_API_URL=http://localhost:4000
VITE_SUPABASE_URL=https://your-project-ref.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=your-supabase-publishable-key
```

Backend `Backend/.env` for Supabase:

```env
PORT=4000
DATABASE_URL=postgresql://postgres.<project-ref>:<password>@aws-1-eu-central-1.pooler.supabase.com:5432/postgres?sslmode=no-verify
DATABASE_SCHEMA=dorm_mgmt
DATABASE_SSL=true
DATABASE_SSL_REJECT_UNAUTHORIZED=false
```

Backend `Backend/.env` for local PostgreSQL:

```env
PORT=4000
DATABASE_URL=postgresql://postgres:password@localhost:5432/dorm_mgmt
DATABASE_SCHEMA=dorm_mgmt
DATABASE_SSL=false
DATABASE_SSL_REJECT_UNAUTHORIZED=false
```

This is a Vite React app, not a Next.js app. Use `VITE_*` variables and `src/utils/supabase/client.js`; Next.js files such as `page.tsx`, server helpers, and middleware are not used.

## Run Locally

Install frontend dependencies:

```bash
npm install
```

Install backend dependencies:

```bash
cd Backend
npm install
cd ..
```

Start the backend:

```bash
cd Backend
npm run start
```

In another terminal, start the frontend:

```bash
npm run dev
```

Open:

```text
http://localhost:5173
```

Check the backend:

```bash
curl http://localhost:4000/api/health
```

Expected response includes:

```json
{"status":"ok","schema":"dorm_mgmt"}
```

## Local PostgreSQL Setup

If you are not using Supabase, create and seed a local database:

```bash
createdb dorm_mgmt
psql -d dorm_mgmt -f Backend/schema.sql
psql -d dorm_mgmt -f Backend/seed.sql
psql -d dorm_mgmt -f Backend/indexes.sql
```

Then use the local PostgreSQL `Backend/.env` example above.

## API Endpoints

- `GET /api/health`
- `GET /api/stats`
- `GET /api/students?q=&deleted=`
- `POST /api/students`
- `DELETE /api/students/:id`
- `POST /api/students/:id/restore`
- `GET /api/rooms?q=&available=&deleted=`
- `POST /api/rooms`
- `DELETE /api/rooms/:id`
- `POST /api/rooms/:id/restore`
- `GET /api/payments?q=&deleted=`
- `POST /api/payments`
- `DELETE /api/payments/:id`
- `POST /api/payments/:id/restore`
- `GET /api/maintenance?q=&deleted=`
- `POST /api/maintenance`
- `DELETE /api/maintenance/:id`
- `POST /api/maintenance/:id/restore`

## Scripts

Frontend:

```bash
npm run dev
npm run build
npm run preview
npm run lint
```

Backend:

```bash
cd Backend
npm run start
```

## Troubleshooting

- Backend returns `password authentication failed`: check `Backend/.env` `DATABASE_URL` and Supabase database password.
- Frontend shows `Load failed`: confirm the backend is running on port `4000` and `VITE_API_URL` matches it.
- Supabase REST schema errors: this project uses the Express API for dorm data; the frontend does not directly query `dorm_mgmt` tables.
- Port already in use: stop the existing process or change `PORT`/Vite port.

## Security Note

The current admin login is a local frontend gate for coursework/demo use. For production, replace it with real authentication, such as Supabase Auth, and enforce authorization in the backend API.

## License

Educational use for AUCA coursework.
