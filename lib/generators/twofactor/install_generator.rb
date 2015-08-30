module Twofactor
  class InstallGenerator < Rails::Generators::Base
    source_root File.dirname(__FILE__)

    #First arg : Model Name which needs Two-factor auth
    #Second arg : Reference field that needs to be used(This field will appear in the client's Google Authenticator app. Defaults to 'email')
    #Third arg : Template type to use for twofactor_register default page (takes one of erb / haml / slim)
    #Fourth arg : Controller that could be configured with TwoFactor actions( Defaults to 'ApplicationController' )
    #Fifth arg : Table name corresponding to the model. ( Defaults to Rails' choice. )
    def initialize(*runtime_args)
      super(*runtime_args)
      @args = runtime_args
    end

    class InvalidParameterError < StandardError
      def initialize(msg = "Provide a valid model name & reference_field field.")
        super(msg)
      end
    end
    class InvalidTemplateTypeError < StandardError
      def initialize(msg = "Provide a valid template type. slim (or) haml (or) erb.")
        super(msg)
      end
    end
    def install_twofactor
      args = @args.first
      options = {}
      options[:model_name] = args.first
      options[:reference_field] = args.second
      options[:template_type] = args.third
      options[:controller] = args.fourth
      options[:table_name] = args.fifth
      model = options[:model_name]
      @reference_field = options[:reference_field]

      if(model.nil? || model.blank? || @reference_field.nil? || @reference_field.blank?)
        raise InvalidParameterError
      else
        @model_name = model.capitalize
      end

      raise InvalidTemplateTypeError unless ['haml','erb','slim'].include? options[:template_type]

      controller_name = options[:controller].present? ? options[:controller] : 'ApplicationController'
      table_name = options[:table_name].present? ? options[:table_name] : @model_name.tableize

      template 'templates/twofactor_config.rb', 'config/initializers/twofactor_config.rb'

      template 'templates/twofactor_migration.rb', File.join('db', 'migrate', "#{Time.now.strftime('%Y%m%d%H%M%S')}_add_twofactor_fields_to_#{table_name}.rb")
      template_location = controller_name == 'ApplicationController' ? 'twofactor' : controller_name.gsub('Controller','').tableize
      copy_file "templates/twofactor_register.html.#{options[:template_type]}", "app/views/#{template_location}/twofactor_register.html.#{options[:template_type]}"
      twofactor_actions = "\n  public\n"\
        "    def twofactor_register\n"\
        "      model_object = (Rails.application.class::TWOFACTOR_MODEL_NAME).constantize.find_by_id(params[:id])\n"\
        "      qrcode = Twofactor::TwoStep.enable_twofactor_auth(model_object)\n"\
        "      render :template => \"#{template_location}/twofactor_register\", :locals => {:qrcode => qrcode}\n"\
        "    end\n\n"
      inject_into_file "app/controllers/#{controller_name.underscore}.rb", twofactor_actions, :before => /^end/
      c_name = controller_name.gsub("Controller","").underscore
      route "get '#{c_name}/twofactor_register/:id' => '#{c_name}#twofactor_register', as: 'twofactor_register'"
    end
  end
end
