# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Capistrano::Gcp::Autoscaling::Core::ComputeService do
  subject { described_class.new(options) }

  let(:options) do
    {
      gcp_private_key: 'gcp_private_key',
      gcp_client_email: 'gcp_client_email',
      gcp_scope: 'gcp_scope'
    }
  end

  describe '#instance' do
    let(:authorization) { instance_double(Signet::OAuth2::Client) }

    before do
      allow(Google::Auth::ServiceAccountCredentials).to receive(:make_creds)
        .with(scope: options.fetch(:gcp_scope))
        .and_return authorization
    end

    it 'is expected to return a compute instance' do
      expect(subject.instance).to be_a Google::Apis::ComputeV1::ComputeService
    end

    it 'is expected to memoize a compute instance' do
      compute_service = subject.instance
      expect(subject.instance).to be compute_service
    end

    it 'is expected to set an authorization to instance' do
      expect(subject.instance.authorization).to eq authorization
    end

    it 'is expected to set a private key var environment variable' do
      subject.instance
      expect(ENV[Google::Auth::CredentialsLoader::PRIVATE_KEY_VAR]).to eq options.fetch(:gcp_private_key)
    end

    it 'is expected to set a client email var environment variable' do
      subject.instance
      expect(ENV[Google::Auth::CredentialsLoader::CLIENT_EMAIL_VAR]).to eq options.fetch(:gcp_client_email)
    end
  end
end
