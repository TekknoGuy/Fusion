-- login should be on your exposed schema

CREATE OR REPLACE FUNCTION
    api.login(email TEXT, pass TEXT, device_id TEXT) RETURNS JSON AS
$$
DECLARE
    user_record   RECORD; -- We need to capture the user_id
    device_uuid   UUID;
    access_token  TEXT;
    refresh_token TEXT;
BEGIN
    SELECT *
    INTO user_record
    FROM authentication.users
    WHERE users.email = login.email
      AND users.password = authentication.crypt(login.pass, users.password);

    IF NOT FOUND THEN
        RAISE invalid_password USING MESSAGE = 'Invalid username or password';
    END IF;

    -- Validate device_id is UUID
    BEGIN
        device_uuid = device_id::uuid;
    EXCEPTION
        WHEN invalid_text_representation THEN
            RAISE EXCEPTION 'Invalid device_id: %', device_id;
    END;

    -- Valid User Login, delete/invalidate existing refresh token for device and generate another
    refresh_token := auth_functions.issue_refresh_token(user_record.id, device_uuid);

    SELECT auth_functions.sign_jwt(row_to_json(r)) AS token
    FROM (SELECT user_record.role                             AS role,
                 login.email                                  AS email,
                 user_record.id                               AS sub,
                 device_uuid                                  AS jti,
                 'access'                                     AS type,
                 EXTRACT(EPOCH FROM NOW())::INTEGER           AS iat,
                 EXTRACT(EPOCH FROM NOW())::INTEGER + 60 * 60 AS exp) r
    INTO access_token;

    RETURN json_build_object(
            'access_token', access_token,
            'refresh_token', refresh_token
           );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

ALTER FUNCTION api.login(email TEXT, pass TEXT, device_id TEXT) OWNER TO fusion_db_admin;
GRANT EXECUTE ON FUNCTION api.login(email TEXT, pass TEXT, device_id TEXT) TO fusion_web_anon;