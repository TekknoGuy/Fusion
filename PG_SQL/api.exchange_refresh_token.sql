-- We're going to cheat a bit for now.  We can just match the refresh token
-- with an existing refresh token, and extract the uid/did/exp from the fields
-- associated with it.  If it matches an existing, we can assume it was
-- signed by us.

-- toDo: all these exceptions should return JSON errors

CREATE OR REPLACE FUNCTION api.exchange_refresh_token(refreshToken TEXT) RETURNS JSON AS
$$
DECLARE
    tokenRecord     RECORD;
    userRecord      RECORD;
    newAccessToken  TEXT;
    newRefreshToken TEXT;
BEGIN
    SELECT * INTO tokenRecord FROM auth_functions.refresh_tokens WHERE refresh_tokens.token = refreshToken LIMIT 1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'invalid refresh token';
    END IF;

    IF NOW() AT TIME ZONE 'utc' >  tokenRecord.expires_at THEN
        RAISE EXCEPTION 'token expired';
    END IF;


    SELECT * INTO userRecord FROM authentication.users WHERE users.id = tokenRecord.user_id LIMIT 1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'invalid userID';
    END IF;
    -- issue_refresh_token will delete old token
    newRefreshToken := auth_functions.issue_refresh_token(tokenRecord.user_id, tokenRecord.device_id);

    -- This should really be in it's own function
    SELECT auth_functions.sign_jwt(row_to_json(r)) AS token
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
-- Security Definer will let run at elevated privilege to access auth_functions.
$$ LANGUAGE plpgsql SECURITY DEFINER;

ALTER FUNCTION api.exchange_refresh_token(refreshToken text) OWNER TO fusion_db_admin;
-- Fusion_Web_Anonymous needs to execute it to log in a user via a token
GRANT EXECUTE ON FUNCTION api.exchange_refresh_token(refreshToken text) to fusion_web_anon;