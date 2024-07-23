-- We will allow one active refresh token per session/device

DROP TABLE IF EXISTS auth_protected.refresh_tokens;
CREATE TABLE auth_protected.refresh_tokens
(
    id         UUID      DEFAULT extensions.uuid_generate_v4()          NOT NULL
        PRIMARY KEY,
    user_id    UUID REFERENCES auth_protected.users (id)
        ON DELETE CASCADE,
    device_id  UUID                                         NOT NULL,
    token      UUID                                         NOT NULL,
    expires_at TIMESTAMP                                    NOT NULL,
    created_at TIMESTAMP DEFAULT (now() AT time zone 'utc') NOT NULL,

    CONSTRAINT unique_user_device UNIQUE (user_id, device_id)
);

DROP FUNCTION IF EXISTS auth_protected.issue_refresh_token(userId UUID, deviceId UUID);
CREATE FUNCTION auth_protected.issue_refresh_token(userId UUID, deviceId UUID) RETURNS UUID AS
$$
DECLARE
    refresh_token UUID;
    iat           TIMESTAMP;
    exp           TIMESTAMP;
BEGIN
    -- Remove any existing tokens belonging to the user/device (uID/dID)
    DELETE
    FROM auth_protected.refresh_tokens
    WHERE user_id = userId
      AND device_id = deviceId;

    iat := NOW() AT TIME ZONE 'utc';
    exp := iat + INTERVAL '30 days';

    refresh_token = extensions.uuid_generate_v4();

    -- Update Table with New Token
    INSERT INTO auth_protected.refresh_tokens(user_id, device_id, token, expires_at)
    VALUES (userId, deviceId, refresh_token, exp);

    RETURN refresh_token;
END;
$$ LANGUAGE plpgsql;
