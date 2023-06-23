require 'jwt'

class AuthenticationTokenService
  HMAC_SECRET = 'secret'.freeze # TODO: salvar numa env
  ALGORITHM_TYPE = 'HS256'.freeze

  def self.encode(user_email)
    exp = 1.hour.from_now.to_i
    payload = { email: user_email, exp: exp }

    JWT.encode(payload, HMAC_SECRET, ALGORITHM_TYPE)
  end

  def self.decode(token)
    JWT.decode(token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE })
  rescue JWT::DecodeError
    nil
  end
end
