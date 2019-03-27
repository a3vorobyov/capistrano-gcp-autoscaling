# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Capistrano::Gcp::Autoscaling::Core::Instance do
  subject { described_class.new(compute_service, managed_instance, options) }

  let(:compute_service) { Google::Apis::ComputeV1::ComputeService.new }

  let(:managed_instance) do
    Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-b/instances/instance-1')
  end

  let(:options) do
    {
      gcp_project_id: 'gcp_project_id'
    }
  end

  describe 'constants' do
    describe '#INSTANCE_PATTERN' do
      it { expect(described_class::INSTANCE_PATTERN).to eq %r{/instances/[\w-]+} }
    end

    describe '#ZONE_PATTERN' do
      it { expect(described_class::ZONE_PATTERN).to eq %r{/zones/[\w-]+} }
    end

    describe '#SEPARATOR' do
      it { expect(described_class::SEPARATOR).to eq '/' }
    end
  end

  describe '#network_ip' do
    let(:instance_zone) { 'us-east-1-b' }
    let(:instance_name) { 'instance-1' }
    let(:instance) { Google::Apis::ComputeV1::Instance.new(network_interfaces: network_interfaces) }

    let(:network_interfaces) do
      [
        Google::Apis::ComputeV1::NetworkInterface.new(network_ip: '10.2.0.15')
      ]
    end

    before do
      allow(compute_service).to receive(:get_instance)
        .with(options.fetch(:gcp_project_id), instance_zone, instance_name)
        .once
        .and_return instance
    end

    it 'is expected to return network ip' do
      subject.network_ip
      expect(subject.network_ip).to eq '10.2.0.15'
    end
  end

  describe '#created_at' do
    let(:instance_zone) { 'us-east-1-b' }
    let(:instance_name) { 'instance-1' }
    let(:instance) { Google::Apis::ComputeV1::Instance.new(creation_timestamp: '2019-03-26T06:29:06.000-07:00') }

    before do
      allow(compute_service).to receive(:get_instance)
        .with(options.fetch(:gcp_project_id), instance_zone, instance_name)
        .once
        .and_return instance
    end

    it 'is expected to return created at' do
      subject.created_at
      expect(subject.created_at).to eq Time.parse(instance.creation_timestamp)
    end
  end

  describe '#running?' do
    let(:instance_zone) { 'us-east-1-b' }
    let(:instance_name) { 'instance-1' }
    let(:instance) { Google::Apis::ComputeV1::Instance.new(status: status) }

    before do
      allow(compute_service).to receive(:get_instance)
        .with(options.fetch(:gcp_project_id), instance_zone, instance_name)
        .once
        .and_return instance
    end

    context 'when a status is RUNNING' do
      let(:status) { described_class::RUNNING_STATUS }

      it 'is expected to be true' do
        subject.running?
        expect(subject.running?).to be true
      end
    end

    context 'when a status is not RUNNING' do
      let(:status) { 'STOPPING' }

      it 'is expected to be false' do
        subject.running?
        expect(subject.running?).to be false
      end
    end
  end
end
