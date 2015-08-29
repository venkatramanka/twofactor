class AddTwofactorFieldsTo<%= @model_name.pluralize %> < ActiveRecord::Migration
  def change
    add_column <%= ":#{@model_name.tableize}" %>, :twofactor_enabled, :boolean, :default => false
    add_column <%= ":#{@model_name.tableize}" %>, :twofactor_secret, :string
  end
end 