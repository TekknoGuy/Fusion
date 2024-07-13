-- Verify a JWT.  Any critical/secure logic stays in the auth_functions schema.
CREATE OR REPLACE FUNCTION verify_jwt(token TEXT)
    RETURNS BOOLEAN AS
$$
DECLARE
    result BOOLEAN;
BEGIN
    result := auth_functions.verify_jwt_rs256(token);
    return result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Fusion_DB_Admin own's the function
ALTER FUNCTION api.verify_jwt(token TEXT) OWNER TO fusion_db_admin;
-- Fusion_Web_Anonymous needs to execute it to log in a user via a token
GRANT EXECUTE ON FUNCTION api.verify_jwt(token TEXT) to fusion_web_anon;