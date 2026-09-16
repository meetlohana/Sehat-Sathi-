-- ============================================================
-- Sehat Sathi - PostgreSQL database setup
-- Run as superuser:
--   psql -U postgres -h localhost -f db/setup.sql
-- (set PGPASSWORD first:  $env:PGPASSWORD='<password>')
-- ============================================================

-- 1. Dedicated application login role (least privilege, not superuser)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'sehat_sathi_app') THEN
    CREATE ROLE sehat_sathi_app LOGIN PASSWORD 'sehat_sathi_2026';
  END IF;
END
$$;

-- 2. Create the SehatSathi database if it does not exist yet
SELECT 'CREATE DATABASE "SehatSathi" OWNER sehat_sathi_app'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'SehatSathi')\gexec

-- 3. Connect to SehatSathi and create the users table
\connect "SehatSathi"

CREATE TABLE IF NOT EXISTS users (
  id                 SERIAL PRIMARY KEY,
  mobile_number      VARCHAR(15) UNIQUE NOT NULL,
  otp_code           VARCHAR(6),
  login_method       VARCHAR(50) NOT NULL DEFAULT 'Phone OTP',
  role               VARCHAR(30) NOT NULL DEFAULT 'patient',
  language           VARCHAR(10) NOT NULL DEFAULT 'mr',
  remember_me        BOOLEAN NOT NULL DEFAULT TRUE,
  login_count        INTEGER NOT NULL DEFAULT 1,
  created_at         TIMESTAMP NOT NULL DEFAULT NOW(),
  last_login_at      TIMESTAMP NOT NULL DEFAULT NOW(),

  -- Health ID profile details (populated from ABHA/Health ID lookup)
  health_id_number   VARCHAR(50),
  full_name          VARCHAR(100),
  date_of_birth      DATE,
  gender             VARCHAR(20),
  email              VARCHAR(100),
  address            TEXT
);

-- 4. Permissions for the application role
GRANT CONNECT ON DATABASE "SehatSathi" TO sehat_sathi_app;
GRANT USAGE ON SCHEMA public TO sehat_sathi_app;
GRANT SELECT, INSERT, UPDATE ON TABLE users TO sehat_sathi_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO sehat_sathi_app;