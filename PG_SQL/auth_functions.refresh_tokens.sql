-- We will allow one active refresh token per session/device
DROP TABLE IF EXISTS auth_functions.refresh_tokens;
CREATE TABLE auth_functions.refresh_tokens
(
    id         UUID      DEFAULT gen_random_uuid()          NOT NULL
        PRIMARY KEY,
    user_id    UUID REFERENCES authentication.users (id)
        ON DELETE CASCADE,
    device_id  UUID                                         NOT NULL,
    token      TEXT                                         NOT NULL,
    expires_at TIMESTAMP                                    NOT NULL,
    created_at TIMESTAMP DEFAULT (now() AT time zone 'utc') NOT NULL,

    CONSTRAINT unique_user_device UNIQUE (user_id, device_id)
);

CREATE OR REPLACE FUNCTION auth_functions.issue_refresh_token(userId UUID, deviceId UUID) RETURNS TEXT AS
$$
DECLARE
    refresh_token TEXT;
    iat           TIMESTAMP;
    exp           TIMESTAMP;
BEGIN
    -- Remove any existing tokens belonging to the user/device (uID/dID)
    DELETE
    FROM auth_functions.refresh_tokens
    WHERE user_id = userId
      AND device_id = deviceId;

    -- Epoch (Unix Time) is based in seconds.  1min = 60; 1hr = 3600; 1day = 86,400;
    iat := NOW() AT TIME ZONE 'utc';
    exp := iat + INTERVAL '30 days';

    -- Generate new token / Expiration
    SELECT auth_functions.sign_jwt(row_to_json(r)) AS token
    FROM (SELECT userId                           as sub,
                 deviceId                         as jti,
                 EXTRACT(EPOCH FROM iat)::INTEGER AS iat,
                 EXTRACT(EPOCH FROM exp)::INTEGER AS exp,
                 'refresh'                        AS type) r
    INTO refresh_token;

    -- Update Table with New Token
    INSERT INTO auth_functions.refresh_tokens(user_id, device_id, token, expires_at)
    VALUES (userId, deviceId, refresh_token, exp);

    RETURN refresh_token;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION auth_functions.issue_refresh_token(userId uuid, deviceId uuid) OWNER TO fusion_db_admin;
