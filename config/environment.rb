# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, _instance|
  html_tag.html_safe
end

Rails.application.configure do
  config.action_controller.action_on_unpermitted_parameters = :raise
end
