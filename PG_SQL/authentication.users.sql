CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "plpython3u";

DROP EXTENSION IF EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA authentication;

-- DROP EXTENSION IF EXISTS "pgjwt";
-- CREATE EXTENSION IF NOT EXISTS "pgjwt";

-- Note: All times should be kept in UTC.  They can be converted locally if needed.

CREATE SCHEMA IF NOT EXISTS authentication;

-- User Table
-- Note: when tables are re-created, existing triggers get dropped!
DROP TABLE IF EXISTS authentication.users;
CREATE TABLE authentication.users
(
    id         uuid      DEFAULT gen_random_uuid()          NOT NULL
        PRIMARY KEY,
    email      VARCHAR(255)                                 NOT NULL
        UNIQUE
        CHECK (email ~* '^.+@.+\..+$'),
    password   VARCHAR(255)                                 NOT NULL,
    role       name                                         NOT NULL
        CHECK (length(role) < 512),
    created_at TIMESTAMP DEFAULT (now() AT time zone 'utc') NOT NULL
);





-- We would like the role to be a foreign key to actual database roles, however PostgreSQL does not
-- support these constraints against the pg_roles table. We’ll use a trigger to manually enforce it.
-- 2024-06-10 - Added check for 'starts_with' so we can't accidentally add one of the 'pg_' roles.
-- 2024-06-10 - Remove the 'return null' as the code is unreachable
CREATE OR REPLACE FUNCTION
    authentication.check_role_exists() RETURNS TRIGGER AS
$$
BEGIN
    IF NOT starts_with(new.role, 'fusion_') THEN
        RAISE foreign_key_violation USING MESSAGE = 'unknown database role: ' || new.role;
    END IF;

    IF NOT exists(SELECT 1 FROM pg_roles AS r WHERE r.rolname = new.role) THEN
        RAISE foreign_key_violation USING MESSAGE = 'unknown database role: ' || new.role;
    END IF;

    RETURN new;
END
$$ LANGUAGE plpgsql;

-- Trigger for authentication.check_role_exists()
CREATE CONSTRAINT TRIGGER ensure_user_role_exists
    AFTER INSERT OR UPDATE
    ON authentication.users
    FOR EACH ROW
EXECUTE PROCEDURE authentication.check_role_exists();

-- Next we’ll use the pgcrypto extension and a trigger to keep passwords safe in the users table.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE OR REPLACE FUNCTION
    authentication.encrypt_pass() RETURNS TRIGGER AS
$$
BEGIN
    IF tg_op = 'INSERT' OR new.password <> old.password THEN
        new.password = authentication.crypt(new.password, authentication.gen_salt('bf'));
    END IF;
    RETURN new;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER encrypt_pass
    BEFORE INSERT OR UPDATE
    ON authentication.users
    FOR EACH ROW
EXECUTE PROCEDURE authentication.encrypt_pass();

-- With the table in place we can make a helper to check a password against the encrypted
-- column. It returns the database role for a user if the email and password are correct.
CREATE OR REPLACE FUNCTION
    authentication.user_role(email text, pass text) RETURNS name AS
$$
BEGIN
    RETURN (SELECT role
            FROM authentication.users
            WHERE users.email = user_role.email
              AND users.password = crypt(user_role.pass, users.password));
END;
$$ LANGUAGE plpgsql;

-- Enable pgjwt extension
CREATE EXTENSION IF NOT EXISTS "pgjwt";
-- Set JWT Secret
ALTER DATABASE fusion SET "app.jwt_secret" TO 'Hbpvvl2ovZHb5jbAW4NMnXBL5UikPSSU';
