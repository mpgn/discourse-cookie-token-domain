class ExCurrentUserProvider < Auth::DefaultCurrentUserProvider
  TOKEN_COOKIX ||= "logged_in".freeze

  def log_on_user(user, session, cookies)
    super

    require 'openssl' if !defined?(OpenSSL)
    require 'base64' if !defined?(Base64)

    payload = { username: user.username, user_id: user.id, avatar: user.avatar_template, group: user.title }
    payload_sha = Digest::SHA256.hexdigest payload.to_json
    hash_function = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(hash_function, SiteSetting.cookie_ui_key, payload_sha)
    payload[:hmac] = hmac
    token = Base64.strict_encode64(payload.to_json)
    cookies.permanent[TOKEN_COOKIX] = { value: token, httponly: true, domain: :all }

  end
  
  def log_off_user(session, cookies)
    super

    cookies[TOKEN_COOKIX] = { value: '', httponly: true, domain: :all }
  end

end
