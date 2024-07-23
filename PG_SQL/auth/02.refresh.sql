-- Note:
-- the `auth` schema needs to grant permission to 'anonymous' user
-- the 'authenticator' changes roles to 'anonymous' if no valid token with a 'role'
-- is sent with the request.  Only keep things you don't care if 'anonymous'/everyone
-- has access to.  `SECURITY DEFINER` will run the function as the function's creator.

DROP FUNCTION IF EXISTS auth.refresh(refreshtoken TEXT);

-- Exchange a refresh token for an access token + new refresh token
CREATE OR REPLACE FUNCTION auth.refresh(refreshToken TEXT) RETURNS JSON AS
$$
DECLARE
    tokenRecord     RECORD;
    userRecord      RECORD;
    newAccessToken  TEXT;
    newRefreshToken UUID;
BEGIN
    SELECT * INTO tokenRecord FROM auth_protected.refresh_tokens WHERE refresh_tokens.token = refreshToken::UUID LIMIT 1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'invalid refresh token';
    END IF;

    IF NOW() AT TIME ZONE 'utc' > tokenRecord.expires_at THEN
        RAISE EXCEPTION 'token expired';
    END IF;


    SELECT * INTO userRecord FROM auth_protected.users WHERE users.id = tokenRecord.user_id LIMIT 1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'invalid userID';
    END IF;

    -- issue_refresh_token will delete old token
    newRefreshToken := auth_protected.issue_refresh_token(tokenRecord.user_id, tokenRecord.device_id);

    -- This should really be in it's own function
    SELECT auth_protected.sign_token(row_to_json(r)) AS token
    FROM (SELECT userRecord.role                              AS role,
                 userRecord.email                             AS email,
                 userRecord.id                                AS sub,
                 tokenRecord.device_id                        AS jti,
                 'access'                                     AS type,
                 EXTRACT(EPOCH FROM NOW())::INTEGER           AS iat,
                 EXTRACT(EPOCH FROM NOW())::INTEGER + 60 * 60 AS exp) r
    INTO newAccessToken;

    RETURN json_build_object(
            'access_token', newAccessToken,
            'refresh_token', newRefreshToken
           );
END

$$ LANGUAGE plpgsql SECURITY DEFINER;

-- We don't need to grant specific function access for anonymous because they have access to the schema.
