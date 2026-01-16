require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MusicPracticeApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Enable validation of migration timestamps. When set, an ActiveRecord::InvalidMigrationTimestampError
    # will be raised if the timestamp prefix for a migration is more than a day ahead of the timestamp
    # associated with the current time. This is done to prevent forward-dating of migration files, which can
    # impact migration generation and other migration commands.
    #
    # Applications with existing timestamped migrations that do not adhere to the
    # expected format can disable validation by setting this config to `false`.
    #++
    Rails.application.config.active_record.validate_migration_timestamps = true

    ###
    # Enables YJIT as of Ruby 3.3, to bring sizeable performance improvements. If you are
    # deploying to a memory constrained environment you may want to set this to `false`.
    #++
    Rails.application.config.yjit = true
  end
end
