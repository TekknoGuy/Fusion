CREATE OR REPLACE FUNCTION
    auth_protected.encrypt_pass() RETURNS TRIGGER AS
$$
BEGIN
    IF tg_op = 'INSERT' OR new.password <> old.password THEN
        new.password = extensions.crypt(new.password, extensions.gen_salt('bf'));
    END IF;
    RETURN new;
END
$$ LANGUAGE plpgsql;
