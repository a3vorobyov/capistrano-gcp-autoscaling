# frozen_string_literal: true

module Capistrano
  module Gcp
    module Autoscaling
      module Core
        class InstanceGroupManager
          def initialize(compute_service, options = {})
            @compute_service = compute_service
            @options = options
          end

          def instances
            group_manager.managed_instances.map(&method(:instance_for)).select(&:available?).sort_by(&:created_at)
          end

          private

          attr_reader :compute_service, :options

          def instance_for(managed_instance)
            Capistrano::Gcp::Autoscaling::Core::Instance.new(
              compute_service,
              managed_instance,
              gcp_project_id: options.fetch(:gcp_project_id)
            )
          end

          def group_manager
            compute_service.list_region_instance_group_manager_managed_instances(
              options.fetch(:gcp_project_id),
              options.fetch(:gcp_region),
              options.fetch(:group_manager_name)
            )
          end
        end
      end
    end
  end
end
