# frozen_string_literal: true

Rails.application.configure do
  Rails.application.config.assets.version = "1.0"

  config.assets.compile = true if Rails.env.development?
end
