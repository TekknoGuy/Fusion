-- 2024-06-10 - Added check for 'starts_with' so we can't accidentally add one of the 'pg_' roles.
-- 2024-06-10 - Remove the 'return null' as the code is unreachable
CREATE OR REPLACE FUNCTION
    auth_protected.check_role_exists() RETURNS TRIGGER AS
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
