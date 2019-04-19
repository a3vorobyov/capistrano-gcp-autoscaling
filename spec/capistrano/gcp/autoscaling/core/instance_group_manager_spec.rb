# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Capistrano::Gcp::Autoscaling::Core::InstanceGroupManager do
  subject { described_class.new(compute_service, options) }

  let(:compute_service) { Google::Apis::ComputeV1::ComputeService.new }

  let(:options) do
    {
      gcp_project_id: 'gcp_project_id',
      gcp_region: 'us-east-1',
      group_manager_name: 'group_manager_name'
    }
  end

  describe '#instances' do
    let(:managed_instances_list) do
      Google::Apis::ComputeV1::RegionInstanceGroupManagersListInstancesResponse
        .new(managed_instances: managed_instances)
    end

    let(:managed_instances) { [managed_instance1, managed_instance2, managed_instance3, managed_instance4] }

    let(:managed_instance1) do
      Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-b/instances/instance-1')
    end

    let(:managed_instance2) do
      Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-c/instances/instance-2')
    end

    let(:managed_instance3) do
      Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-b/instances/instance-3')
    end

    let(:managed_instance4) do
      Google::Apis::ComputeV1::ManagedInstance.new(instance: 'gcp_project_id/zones/us-east-1-c/instances/instance-4')
    end

    let(:instance1) do
      instance_double(Capistrano::Gcp::Autoscaling::Core::Instance,
                      network_ip: '10.2.0.15',
                      created_at: Time.new(2019, 3, 26),
                      available?: true)
    end

    let(:instance2) do
      instance_double(Capistrano::Gcp::Autoscaling::Core::Instance,
                      network_ip: '10.2.0.16',
                      created_at: Time.new(2019, 2, 26),
                      available?: true)
    end

    let(:instance3) do
      instance_double(Capistrano::Gcp::Autoscaling::Core::Instance,
                      network_ip: '10.2.0.17',
                      created_at: Time.new(2019, 1, 26),
                      available?: false)
    end

    let(:instance4) do
      instance_double(Capistrano::Gcp::Autoscaling::Core::Instance,
                      network_ip: '10.2.0.18',
                      created_at: Time.new(2019, 4, 26),
                      available?: true)
    end

    before do
      allow(compute_service).to receive(:list_region_instance_group_manager_managed_instances).with(
        options.fetch(:gcp_project_id),
        options.fetch(:gcp_region),
        options.fetch(:group_manager_name)
      ).and_return managed_instances_list
      allow(Capistrano::Gcp::Autoscaling::Core::Instance).to receive(:new)
        .with(compute_service, managed_instance1, gcp_project_id: options.fetch(:gcp_project_id)).and_return instance1
      allow(Capistrano::Gcp::Autoscaling::Core::Instance).to receive(:new)
        .with(compute_service, managed_instance2, gcp_project_id: options.fetch(:gcp_project_id)).and_return instance2
      allow(Capistrano::Gcp::Autoscaling::Core::Instance).to receive(:new)
        .with(compute_service, managed_instance3, gcp_project_id: options.fetch(:gcp_project_id)).and_return instance3
      allow(Capistrano::Gcp::Autoscaling::Core::Instance).to receive(:new)
        .with(compute_service, managed_instance4, gcp_project_id: options.fetch(:gcp_project_id)).and_return instance4
    end

    it 'is expected to return a list of instances' do
      expect(subject.instances).to eq [instance2, instance1, instance4]
    end
  end
end
