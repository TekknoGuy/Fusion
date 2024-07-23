-- Generate RS256 Key Pair, private key goes here, public key for postgrest 'jwt-secret' field
-- jose jwk gen -i '{"alg":"RS256"}' -o rsa.jwk
-- jose jwk pub -i rsa.jwk -o rsa.jwk.pub
-- You will need to re-connect in a new session to see any updates to this.
-- ALTER DATABASE fusion RESET "app.jwt_secret";
ALTER DATABASE fusion SET "app.jwt_secret" = '{"alg":"RS256","d":"JWK_PRIVATE_KEY"}';
-- SELECT current_setting('app.jwt_secret');

-- Anonymous login used for `auth` schema
CREATE ROLE fusion_web_anon NOLOGIN;
-- API Access
CREATE ROLE fusion_user NOLOGIN;
-- Postgrest Login - Will switch to one of the above users
CREATE ROLE fusion_authenticator NOINHERIT LOGIN PASSWORD 'password';

-- Allow authenticator role ability to switch to anonymous role
GRANT fusion_web_anon TO fusion_authenticator;
-- Allow authenticator role ability to switch to user role
GRANT fusion_user TO fusion_authenticator;

-- `api` Schema
CREATE SCHEMA IF NOT EXISTS api;
COMMENT ON SCHEMA api IS 'Require fusion_user role to access.  Use functions/views only';
GRANT USAGE ON SCHEMA api TO fusion_user;

-- `api_protected` Schema
CREATE SCHEMA IF NOT EXISTS api_protected;
COMMENT ON SCHEMA api_protected IS'Tables that back views/functions in `api`';

-- `auth` Schema
DROP SCHEMA IF EXISTS auth CASCADE;
CREATE SCHEMA auth;
COMMENT ON SCHEMA auth IS 'Public Authentication Functions';
GRANT USAGE ON SCHEMA auth TO fusion_web_anon;

-- `auth_protected` Schema
DROP SCHEMA IF EXISTS auth_protected CASCADE;
CREATE SCHEMA auth_protected;
COMMENT ON SCHEMA auth_protected IS 'Protected Information/Scripts';

-- `extensions` Schema
DROP SCHEMA IF EXISTS extensions CASCADE;

CREATE SCHEMA extensions;
COMMENT ON SCHEMA extensions IS 'Any 3rd party extensions live here';

-- Required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "plpython3u";
CREATE EXTENSION IF NOT EXISTS "plpgsql";
