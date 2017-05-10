if Rails.env.development? || Rails.env.test?
  require 'factory_girl'

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      include FactoryGirl::Syntax::Methods

      user = create(:user, email: 'user@example.com')

      dashboard_saml_config = Saml::Config::SETTINGS
      uuid = SecureRandom.uuid
      create(:service_provider,
             user: user,
             issuer: uuid,
             friendly_name: 'login.gov Dashboard',
             description: 'user friendly login.gov dashboard',
             metadata_url: "http://localhost:3001/api/service_providers/#{uuid}",
             acs_url: 'http://localhost:3001/users/auth/saml/callback',
             assertion_consumer_logout_service_url: 'http://localhost:3001/users/auth/saml/logout',
             # sp_initiated_login_url: 'add once db is updated http://localhost:3001/users/auth/saml',
             block_encryption: 'aes256-cbc',
             saml_client_cert: dashboard_saml_config.certificate,
             # attribute_bundle: add once db is updated [:email],
             # logo: 'add once db updated svg string',
             # return_to_sp_url: 'add once db is updated',
             active: true,
             approved: true)
    end
  end
end
