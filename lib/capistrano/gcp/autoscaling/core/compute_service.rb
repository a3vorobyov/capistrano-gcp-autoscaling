# frozen_string_literal: true

module Capistrano
  module Gcp
    module Autoscaling
      module Core
        class ComputeService
          def initialize(options = {})
            @options = options
          end

          def instance
            @instance ||= Google::Apis::ComputeV1::ComputeService.new.tap do |instance|
              ensure_env_variables_set!
              ensure_authorization_set!(instance)
            end
          end

          private

          attr_reader :options

          def ensure_env_variables_set!
            ENV[Google::Auth::CredentialsLoader::PRIVATE_KEY_VAR] = options.fetch(:gcp_private_key)
            ENV[Google::Auth::CredentialsLoader::CLIENT_EMAIL_VAR] = options.fetch(:gcp_client_email)
          end

          def ensure_authorization_set!(instance)
            instance.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
              scope: options.fetch(:gcp_scope)
            )
          end
        end
      end
    end
  end
end
