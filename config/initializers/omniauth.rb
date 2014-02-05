CLIENT_OPTS = if Rails.env.development? || Rails.env.test?
                { ssl: { ca_file: Rails.root.join('lib', 'certificates', 'development.crt').to_s } }
              else
                { ssl: { ca_path: '/usr/lib/ssl' } }
              end

EVERNOTE_OPTS = if Rails.env.development? || Rails.env.test?
                  CLIENT_OPTS.merge(site: 'https://sandbox.evernote.com')
                else
                  CLIENT_OPTS
                end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dropbox, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'], client_options: CLIENT_OPTS
  provider :evernote, ENV['EVERNOTE_KEY'], ENV['EVERNOTE_SECRET'], client_options: EVERNOTE_OPTS

  on_failure { |env| App::ServicesController.action(:failure).call(env) }
end

OmniAuth.config.logger = Rails.logger
