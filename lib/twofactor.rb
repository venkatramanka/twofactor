require 'base32'
require 'totp'
require 'rqrcode'
module Twofactor
  class TwoStep
    def self.enable_twofactor_auth(model_object)
      model_object.update_attribute(Rails.application.class::TWOFACTOR_SECRET_ATTRIBUTE, ::Base32.encode(rand(36**6).to_s(36)))
      model_object.update_attribute(Rails.application.class::TWOFACTOR_FLAG_ATTRIBUTE, true)
      qrcode = ::RQRCode::QRCode.new("otpauth://totp/#{provider_name}:#{model_object[Rails.application.class::TWOFACTOR_REFERENCE_FIELD]}?secret=#{model_object[Rails.application.class::TWOFACTOR_SECRET_ATTRIBUTE]}&issuer=#{provider_name}", :size => Rails.application.class::TWOFACTOR_QRCODE_SIZE, :level => Rails.application.class::TWOFACTOR_QRCODE_QUALITY.to_sym)
      return qrcode
    end
    def self.disable_twofactor_auth(model_object)
      model_object.update_attribute(Rails.application.class::TWOFACTOR_SECRET_ATTRIBUTE, nil)
      model_object.update_attribute(Rails.application.class::TWOFACTOR_FLAG_ATTRIBUTE, false)
      return true
    end
    def self.valid_code?(model_object, code)
      ::TOTP.valid?(model_object[Rails.application.class::TWOFACTOR_SECRET_ATTRIBUTE], code)
    end

    private

    def self.provider_name
      if Rails.application.class::TWOFACTOR_PROVIDER_NAME.blank?
        return Rails.application.config.session_options[:key].sub(/^_/,'').sub(/_session/,'')
      else
        return Rails.application.class::TWOFACTOR_PROVIDER_NAME
      end
    end
  end
end