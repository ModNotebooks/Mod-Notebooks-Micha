CLIENT_OPTS = if Rails.env.development? || Rails.env.test?
                { ssl: { ca_file: Rails.root.join('lib', 'certificates', 'development.crt').to_s } }
              else
                { ssl: { ca_path: '/usr/lib/ssl' } }
              end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dropbox, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'], client_options: CLIENT_OPTS
end

# https://github.com/intridea/omniauth/issues/306#issuecomment-26008735
OmniAuth.config.on_failure do |env|
  App::ServicesController.action(:failure).call(env)
end

OmniAuth.config.logger = Rails.logger
