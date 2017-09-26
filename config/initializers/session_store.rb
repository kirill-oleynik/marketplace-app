Rails.application.configure do
  config.session_store :cookie_store, domain: ENV['DOMAIN'],
                                      key: '_appreviewer_session'

  config.middleware.use ActionDispatch::Cookies
  config.middleware.use ActionDispatch::Session::CookieStore,
                        Rails.application.config.session_options
end
