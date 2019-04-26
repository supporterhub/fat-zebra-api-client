module FatZebra
  ##
  # == FatZebra \Information
  #
  # Manage information for the API
  #
  # * ping
  #
  class Information < APIResource
    class << self

      def base_path(_account)
        ''
      end

      ##
      # Ping the API
      #
      # @param [String] echo param
      #
      # @return [FatZebra::Information] response
      def ping(nonce = SecureRandom.hex)
        response = request(:get, 'ping', echo: nonce)
        initialize_from(response)
      end

    end
  end
end
