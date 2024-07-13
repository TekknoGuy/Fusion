DROP TABLE IF EXISTS auth_functions.jwt_public_keys;
CREATE TABLE auth_functions.jwt_keys (
  id SERIAL PRIMARY KEY,
  private_key TEXT NOT NULL,
  public_key TEXT NOT NULL
);

INSERT INTO auth_functions.jwt_keys (private_key, public_key) VALUES(
'-----BEGIN PRIVATE KEY-----
--  -- RSA PRIVATE KEY GOES HERE -- --' ||
'-----END PRIVATE KEY-----',
'-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuH2Q2UcZyghLzw6Qx/QL
O7P/BjDjKtjJo8Bf8PPW4ER9N57k5Lxv8TYg7U5CfVget+baAFG37QLGmeR3tauO
lyBprk3NJ6i0SrICzkw/mKygbrTYeSwkVcxJT9zWE+rn4OCaF9RUC7RZ0AdIjrtm
zXlhlCysY51dAEXOUQsgVnI0bR+9sYTQfBN02EDPdxCcu0XGNxug29wmRsD0M5w4
M6uy1O24jjRiuB/V640tfAqkmuc+QgF3F2xYqSXTbSU+Xg7RbVgjMf0WktUYll6d
x0hw/k1CYLaU23ldzfZ4fuJb/HyKgSPkzVYrP1bBb+njUZoNr6+AgYgEQ1+FnTwK
EQIDAQAB
-----END PUBLIC KEY-----'
);

CREATE OR REPLACE FUNCTION auth_functions.sign_jwt(payload JSON)
    RETURNS TEXT AS
$$
    import jwt
    import json

    private_key = plpy.execute("SELECT private_key FROM auth_functions.jwt_keys WHERE id = 1")[0]['private_key']

    # For some reason it needs to be converted to a dict even though it's brought in as JSON
    payload_dict = json.loads(payload)

    token = jwt.encode(payload_dict, private_key, algorithm='RS256')

    return token
$$ LANGUAGE plpython3u;
ALTER FUNCTION auth_functions.sign_jwt(payload JSON) OWNER TO fusion_db_admin;

CREATE OR REPLACE FUNCTION auth_functions.verify_jwt_rs256(token TEXT)
    RETURNS BOOLEAN AS
$$
    import jwt
    import psycopg2

    public_key = plpy.execute("SELECT public_key FROM auth_functions.jwt_keys WHERE id = 1")[0]['public_key']

    try:
        jwt.decode(token, public_key, algorithms=['RS256'])
        return True
    except jwt.InvalidTokenError:
        return False
$$ LANGUAGE plpython3u;
ALTER FUNCTION auth_functions.verify_jwt_rs256(token TEXT) OWNER TO fusion_db_admin;
