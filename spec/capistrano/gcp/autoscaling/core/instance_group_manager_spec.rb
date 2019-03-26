# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Capistrano::Gcp::Autoscaling::Core::InstanceGroupManager do
  subject { described_class.new(compute_service, options) }

  let(:compute_service) { Google::Apis::ComputeV1::ComputeService.new }

  let(:options) do
    {
      gcp_project_id: 'gcp_project_id',
      gcp_region: 'us-east-1',
      group_manager_name: 'group_manager_name',
      gcp_filter: '(status eq "RUNNING")'
    }
  end

  describe '#instances' do
    let(:managed_instances_list) do
      Google::Apis::ComputeV1::RegionInstanceGroupManagersListInstancesResponse
        .new(managed_instances: managed_instances)
    end

    let(:managed_instances) { [managed_instance1, managed_instance2] }

    let(:managed_instance1) do
      Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-b/instances/instance-1')
    end

    let(:managed_instance2) do
      Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-c/instances/instance-2')
    end

    let(:instance1) { instance_double(Capistrano::Gcp::Autoscaling::Core::Instance, network_ip: '10.2.0.15') }
    let(:instance2) { instance_double(Capistrano::Gcp::Autoscaling::Core::Instance, network_ip: '10.2.0.16') }

    before do
      allow(compute_service).to receive(:list_region_instance_group_manager_managed_instances).with(
        options.fetch(:gcp_project_id),
        options.fetch(:gcp_region),
        options.fetch(:group_manager_name),
        filter: options.fetch(:gcp_filter)
      ).and_return managed_instances_list
      allow(Capistrano::Gcp::Autoscaling::Core::Instance).to receive(:new)
        .with(compute_service, managed_instance1, gcp_project_id: options.fetch(:gcp_project_id)).and_return instance1
      allow(Capistrano::Gcp::Autoscaling::Core::Instance).to receive(:new)
        .with(compute_service, managed_instance2, gcp_project_id: options.fetch(:gcp_project_id)).and_return instance2
    end

    it 'is expected to return a list of instances' do
      expect(subject.instances).to match_array [instance1, instance2]
    end
  end
end
