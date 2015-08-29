require 'base32'
module Twofactor
  class TwoStep
    def enable_twofactor_auth(model_object)
      model_object.update_attribute('twofactor_secret', ::Base32.encode(rand(36**6).to_s(36)))
      model_object.update_attribute('twofactor_enabled', true)
      qrcode = ::RQRCode::QRCode.new("otpauth://totp/TwoFactorGem:#{model_object['#{Rails.configuration.twofactor_reference_field}']}?secret=#{model_object.twofactor_secret}&issuer=TwoFactorGem", :size => 8, :level => :h)
      return qrcode
    end
    def disable_twofactor_auth(model_object)
      model_object.update_attribute('twofactor_secret', nil)
      model_object.update_attribute('twofactor_enabled', false)
      return true
    end
    def valid_code?(model_object, code)
      ::TOTP.valid?(model_object[Rails.configuration.twofactor_secret_attribute], code)
    end
  end
end