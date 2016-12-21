Devise.setup do |config|
  config.secret_key = 'c4d68db75813040932932947826b41c1aee822f30739b4222a6458276a4337fc6cdeb1e9638221a84553dea36f7c337e042f509a89502af4b74f4b045caab725'

  # ==> Mailer Configuration
  config.mailer_sender = 'no-reply@101.net'
  # config.mailer = 'Devise::Mailer'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # config.authentication_keys = [ :email ]
  # config.request_keys = []
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  # config.params_authenticatable = true
  # config.http_authenticatable = false
  # config.http_authenticatable_on_xhr = true
  # config.http_authentication_realm = 'Application'
  # config.paranoid = true
  config.skip_session_storage = [:http_auth]
  # config.clean_up_csrf_token_on_authentication = true

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 10
  # config.pepper = '422efe4fc5c25e1afb071b1270e4ba884a3ceb71fc87e3294865be608a5f100b3588a191c05baa4678310d97f610d41ace0bbfe804f5b21859673c8e20451fb7'

  # ==> Configuration for :confirmable
  # config.allow_unconfirmed_access_for = 0.days
  config.confirm_within = 2.days
  config.reconfirmable = true
  # config.confirmation_keys = [ :email ]

  # ==> Configuration for :rememberable
  # config.remember_for = 2.weeks
  # config.extend_remember_period = false
  # config.rememberable_options = {}

  # ==> Configuration for :validatable
  config.password_length = 8..128
  # config.email_regexp = /\A[^@]+@[^@]+\z/

  # ==> Configuration for :timeoutable
  config.timeout_in = 60.minutes
  config.expire_auth_token_on_timeout = true

  # ==> Configuration for :lockable
  config.lock_strategy = :failed_attempts
  config.unlock_keys = [ :email ]
  config.unlock_strategy = :both
  config.maximum_attempts = 3
  config.unlock_in = 24.hours
  config.last_attempt_warning = true

  # ==> Configuration for :recoverable
  config.reset_password_keys = [ :email ]
  config.reset_password_within = 6.hours

  # ==> Configuration for :encryptable
  # config.encryptor = :sha512

  # ==> Scopes configuration
  # config.scoped_views = false
  # config.default_scope = :user
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # config.navigational_formats = ['*/*', :html]
  config.sign_out_via = :delete

  # ==> OmniAuth
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden configuration
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> Mountable engine configurations
end
