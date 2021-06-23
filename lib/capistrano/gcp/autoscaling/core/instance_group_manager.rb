# frozen_string_literal: true

module Capistrano
  module Gcp
    module Autoscaling
      module Core
        class InstanceGroupManager < Capistrano::Gcp::Autoscaling::Core::InstanceGroup
          def instances
            group.managed_instances.map(&method(:instance_for)).select(&:available?).sort_by(&:created_at)
          end

          private

          def group
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
