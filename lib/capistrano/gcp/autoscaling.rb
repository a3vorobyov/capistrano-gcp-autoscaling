# frozen_string_literal: true

require 'googleauth'
require 'google/apis/compute_v1'
require 'capistrano/gcp/autoscaling/core/compute_service'
require 'capistrano/gcp/autoscaling/core/instance'
require 'capistrano/gcp/autoscaling/core/instance_group_manager'

load File.expand_path('tasks/autoscaling.rake', __dir__)

def compute_service
  @compute_service ||= Capistrano::Gcp::Autoscaling::Core::ComputeService.new(
    gcp_project_id: fetch(:gcp_project_id),
    gcp_private_key: fetch(:gcp_private_key),
    gcp_client_email: fetch(:gcp_client_email),
    gcp_scope: fetch(:gcp_scope)
  ).instance
end

def instance_group_manager(group_manager_name, properties = {})
  instance_group_manager = Capistrano::Gcp::Autoscaling::Core::InstanceGroupManager.new(
    compute_service,
    gcp_project_id: fetch(:gcp_project_id),
    gcp_region: fetch(:gcp_region),
    group_manager_name: group_manager_name
  )

  instance_group_manager.instances.each_with_index do |instance, index|
    server instance.network_ip, block_given? ? yield(instance, index) : properties
  end
end
