# frozen_string_literal: true

module Capistrano
  module Gcp
    module Autoscaling
      module Core
        class Instance
          INSTANCE_PATTERN = %r{/instances/[\w-]+}.freeze
          ZONE_PATTERN = %r{/zones/[\w-]+}.freeze
          SEPARATOR = '/'.freeze
          RUNNING_STATUS = 'RUNNING'.freeze
          NONE_ACTION = 'NONE'.freeze
          VERIFYING_ACTION = 'VERIFYING'.freeze

          def initialize(compute_service, managed_instance, options = {})
            @compute_service = compute_service
            @managed_instance = managed_instance
            @options = options
          end

          def network_ip
            instance.network_interfaces.first.network_ip
          end

          def created_at
            Time.parse(instance.creation_timestamp)
          end

          def available?
            running? && (verifying? || do_nothing?)
          end

          private

          attr_reader :compute_service, :managed_instance, :options

          def running?
            managed_instance.instance_status == RUNNING_STATUS
          end

          def do_nothing?
            managed_instance.current_action == NONE_ACTION
          end

          def verifying?
            managed_instance.current_action == VERIFYING_ACTION
          end

          def instance
            @instance ||= compute_service.get_instance(options.fetch(:gcp_project_id), instance_zone, instance_name)
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
