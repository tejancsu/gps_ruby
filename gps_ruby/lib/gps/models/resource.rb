module Gps
  module Model
    class Resource
      class << self
        def attribute(key)
          attr_accessor key
        end
      end

      def collect
        to_hash.collect
      end

      def to_hash(camelize=false)
        hash = {}
        instance_variables.each do |var|
          key = var.to_s.delete('@')
          key = key.camelize(:lower) if camelize

          value = instance_variable_get(var)
          if value.is_a?(Resource)
            value = value.to_hash(camelize)
          elsif value.is_a?(Enumerable) and value.first.is_a?(Resource)
            value = value.map { |v| v.to_hash(camelize) }
          end

          hash[key] = value
        end
        hash
      end

      def to_json
        to_hash(true).to_json
      end
    end
  end
end
