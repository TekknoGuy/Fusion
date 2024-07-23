-- Note: when tables are re-created, existing triggers get dropped!
DROP TABLE IF EXISTS auth_protected.users;
CREATE TABLE auth_protected.users
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

-- Trigger for auth_protected.check_role_exists()
CREATE CONSTRAINT TRIGGER ensure_user_role_exists
    AFTER INSERT OR UPDATE
    ON auth_protected.users
    FOR EACH ROW
EXECUTE PROCEDURE auth_protected.check_role_exists();

-- Trigger to encrypt password
CREATE OR REPLACE TRIGGER encrypt_pass
    BEFORE INSERT OR UPDATE
    ON auth_protected.users
    FOR EACH ROW
EXECUTE PROCEDURE auth_protected.encrypt_pass();