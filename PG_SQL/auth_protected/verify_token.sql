-- This needs to be updated
-- toDo: this will probably get dropped.  There is no need for the database to
-- toDo: verify tokens.  Postgrest already does that

DROP FUNCTION IF EXISTS auth_protected.verify_token(token TEXT);
CREATE OR REPLACE FUNCTION auth_protected.verify_token(token TEXT)
    RETURNS BOOLEAN AS
$$
    import jwt

    public_key = plpy.execute("SELECT public_key FROM auth_protected.jwt_keys WHERE id = 1")[0]['public_key']

    try:
        jwt.decode(token, public_key, algorithms=['RS256'])
        return True
    except jwt.InvalidTokenError:
        return False
$$ LANGUAGE plpython3u;
