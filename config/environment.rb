# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dvhk::Application.initialize!

Dvhk::Application.configure do
  config.sass.line_comments = false
  config.sass.style = :nested
  config.sass.cache = false
end