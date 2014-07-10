module Gps
  module Model
    class Context < Resource
      attribute :accept_header
      attribute :client_ip
      attribute :client_id
      attribute :origin_client_id
      attribute :user_agent

      def to_hash(camelize=false)
        hash = super(camelize)
        if camelize
          hash.delete('clientIp')
          hash['clientIP'] = client_ip
        end
        hash
      end
    end
  end
end
