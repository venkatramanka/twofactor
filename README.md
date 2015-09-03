#Twofactor

A gem to integrate your Rails app with Google 2Factor-authenticator mobile apps.

Unlike other 2-step auth gems out there, Twofactor does not really require `devise`. Instead, it creates an endpoint at your command and operates from there.
    
All you have to do is to make your user register for `Twofactor` using that endpoint. Get a 2-Factor code from him each time he logs in & call the gem's validator to check if the code is valid.

## Getting Started

* Add the following to your application's Gemfile.
```ruby
gem 'twofactor'
```
* Do this :
```ruby
bundle install
```
* Install twofactor gem.
```console
rails generate twofactor:install <Model> <ReferenceField> <TemplateType> <ControllerName> <TableName>
```
* Run migrate :
```ruby
rake db:migrate
```

##Install Generator arguments

Twofactor's install generator accepts five arguments of which the first 3 are mandatory:

* `Model`          - The name of the model to which 2-Step auth needs to be given.

* `ReferenceField` - Reference field that needs to be used(This field will appear in the client's Google Authenticator app. Defaults to 'email')

* `TemplateType`  - Templating language to use for twofactor_register endpoint's default page (takes one of `erb` / `haml` / `slim`)

* `ControllerName` - Controller that needs to be configured with TwoFactor actions( Defaults to Controller with `Model`'s name pluralized )

* `TableName`      - Table name corresponding to the model. ( Defaults to Rails's choice of `Model` )
