# frozen_string_literal: true

require "monitor"

module ActiveSupport
  module Concurrency
    # A monitor that will permit dependency loading while inside synchronize
    class LoadInterlockAwareMonitor < Monitor
      # Enters an exclusive section, but allows dependency loading while in the block
      def synchronize
        ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
          super do
            yield
          end
        end
      end
    end
  end
end
