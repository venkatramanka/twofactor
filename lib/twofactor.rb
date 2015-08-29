require 'base32'
require 'totp'
module Twofactor
  class TwoStep
    def self.enable_twofactor_auth(model_object)
      model_object.update_attribute('twofactor_secret', ::Base32.encode(rand(36**6).to_s(36)))
      model_object.update_attribute('twofactor_enabled', true)
      qrcode = ::RQRCode::QRCode.new("otpauth://totp/#{provider_name}:#{model_object[Rails.configuration.twofactor_reference_field]}?secret=#{model_object.twofactor_secret}&issuer=#{provider_name}", :size => 6, :level => :m)
      return qrcode
    end
    def self.disable_twofactor_auth(model_object)
      model_object.update_attribute('twofactor_secret', nil)
      model_object.update_attribute('twofactor_enabled', false)
      return true
    end
    def self.valid_code?(model_object, code)
      ::TOTP.valid?(model_object[Rails.configuration.twofactor_secret_attribute], code)
    end

    private

    def self.provider_name
      Rails.application.config.session_options[:key].sub(/^_/,'').sub(/_session/,'')
    end
  end
end