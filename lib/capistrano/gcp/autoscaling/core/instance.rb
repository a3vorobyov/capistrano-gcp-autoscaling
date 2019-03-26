# frozen_string_literal: true

module Capistrano
  module Gcp
    module Autoscaling
      module Core
        class Instance
          INSTANCE_PATTERN = %r{/instances/[\w-]+}.freeze
          ZONE_PATTERN = %r{/zones/[\w-]+}.freeze
          SEPARATOR = '/'.freeze

          def initialize(compute_service, managed_instance, options = {})
            @compute_service = compute_service
            @managed_instance = managed_instance
            @options = options
          end

          def network_ip
            instance.network_interfaces.first.network_ip
          end

          private

          attr_reader :compute_service, :managed_instance, :options

          def instance
            compute_service.get_instance(options.fetch(:gcp_project_id), instance_zone, instance_name)
          end

          def instance_zone
            parse_managed_instance(ZONE_PATTERN)
          end

          def instance_name
            parse_managed_instance(INSTANCE_PATTERN)
          end

          def parse_managed_instance(pattern, separator = SEPARATOR)
            managed_instance.instance.scan(pattern).last.split(separator).last
          end
        end
      end
    end
  end
end
