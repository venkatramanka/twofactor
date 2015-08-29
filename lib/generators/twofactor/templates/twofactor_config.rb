#Specify the attibute to be used for mapping on the Client authenticator app
Rails.configuration.twofactor_reference_field = "<%= @reference_field %>"
Rails.configuration.twofactor_secret_attribute = "twofactor_secret"
Rails.configuration.twofactor_flag_attribute = "twofactor_enabled"