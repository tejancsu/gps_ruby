class Gps::Logger
  def initialize(logger = nil)
    @generic_logger = logger.nil?
    @logger = logger || Logger.new(STDOUT)
    @process_header = " #{Process.pid} #{Process.ppid}"
  end

  [:info, :error, :warn].each do |level|
    self.class_eval <<-END
      def #{level}(identifier, event, log_values={})
        if @generic_logger
          @logger.#{level}(log_message(identifier, event, log_values))
        else
          @logger.#{level}(identifier, event, log_values)
        end
      end
    END
  end

  def log_message(identifier, event, log_values)
    message = Time.now.utc.iso8601(3)
    message << @process_header
    message << " #{identifier} "
    message << "#{event} "
    message << log_values.collect {|name,value|"#{name.to_s}=#{value.to_s}"}.join(';')
  end
end
