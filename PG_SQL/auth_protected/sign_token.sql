DROP FUNCTION IF EXISTS auth_protected.sign_token(payload JSON);
CREATE OR REPLACE FUNCTION auth_protected.sign_token(payload JSON)
    RETURNS TEXT AS
$$
    import json
    import jwt

    jwk = plpy.execute("SELECT current_setting('app.jwt_secret')")[0]['current_setting']

    private_key = jwt.algorithms.RSAAlgorithm.from_jwk(jwk)

    token = jwt.encode(json.loads(payload), private_key, algorithm='RS256')

    return token
$$ LANGUAGE plpython3u;
