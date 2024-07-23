-- With the table in place we can make a helper to check a password against the encrypted
-- column. It returns the database role for a user if the email and password are correct.
CREATE OR REPLACE FUNCTION
    auth_protected.user_role(email text, pass text) RETURNS name AS
$$
BEGIN
    RETURN (SELECT role
            FROM auth_protected.users
            WHERE users.email = user_role.email
              AND users.password = extensions.crypt(user_role.pass, users.password));
END;
$$ LANGUAGE plpgsql;
