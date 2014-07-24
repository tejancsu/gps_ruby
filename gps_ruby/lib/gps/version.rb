module Gps
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 1
    PRE = nil

    VERSION = [MAJOR, MINOR, PATCH, PRE].compact.join('.').freeze

    class << self
      def inspect
        VERSION.dup
      end

      alias to_s inspect
    end
  end
end
