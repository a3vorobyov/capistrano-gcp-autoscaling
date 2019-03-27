# frozen_string_literal: true

namespace :load do
  task :defaults do
    set :gcp_project_id, nil
    set :gcp_region, nil
    set :gcp_scope, 'https://www.googleapis.com/auth/compute'
    set :gcp_private_key, ENV['GCP_PRIVATE_KEY']
    set :gcp_client_email, ENV['GCP_CLIENT_EMAIL']
  end
end
