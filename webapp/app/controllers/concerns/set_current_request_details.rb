# https://blog.cloud66.com/authenticating_users_with_google_iap_in_rails

module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action :auth, except: [:health_check]
  end

  def auth
    Current.request_id = request.uuid
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip

    if Rails.env.production?
      assertion = request.headers["HTTP_X_GOOG_IAP_JWT_ASSERTION"]
      email, _ = validate_assertion(assertion)
      Current.user = ::User.find_by(email: email)
    else
      dev_user_email = ENV['USER']
      Current.user = ::User.find_by(email: dev_user_email)
    end

    redirect_to '/401' if Current.user.blank?
  end

  def certificates
    pub_keys = HTTParty.get("https://www.gstatic.com/iap/verify/public_key")
    return pub_keys.parsed_response
  end

  def validate_assertion(assertion)
    a_header = Base64.decode64(assertion.split(".")[0])
    key_id = JSON.parse(a_header)["kid"]
    cert = OpenSSL::PKey::EC.new(certificates[key_id])
    info = JWT.decode(assertion, cert, true, algorithm: "ES256", audience: audience)
    return info[0]["email"], info[0]["sub"]
  end

  def audience
    Rails.application.credentials.iap_aud
  end

end
