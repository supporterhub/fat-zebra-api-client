module FatZebra
  ##
  # == FatZebra \API \Resource
  #
  # Define the API requests methods
  class APIResource < FatZebraObject
    include APIHelper

    class << self

      def base_path(account)
        "#{account.api_version}/"
      end

      ##
      # Send a request to the API
      #
      # @param [Symbol] method for the request
      # @param [String] endpoint for the request
      # @param [Hash] options
      # @param [Hash] Payload
      #
      # @return [Hash] response
      # @raise [FatZebra::RequestError] if the request is invalid
      # rubocop:disable Metrics/AbcSize
      def request(method, path, payload = {}, options = {})
        account = get_account options
        full_path = "/#{base_path account}#{path}"

        payload[:test] = true if account.test_mode
        payload        = Util.format_dates_in_hash(payload)
        url_params     = URI.encode_www_form(payload) if method == :get
        uri            = build_endpoint_url(account.gateway, full_path, url_params, http_secure: account.http_secure)

        request_options = Util.compact(
          method:  method,
          url:     uri.to_s,
          payload: payload,
          proxy:   account.proxy,
          use_ssl: account.http_secure
        ).merge(authentication account).merge(default_headers).merge(account.global_options).merge(options)

        Request.execute(request_options).body
      rescue FatZebra::RequestError => error
        return error.http_body if error.http_status == 422
        raise
      end
      # rubocop:enable Metrics/AbcSize

      private

      def ssl_options
        return {} unless get_account.http_secure
        {
          ca_file:     File.expand_path(File.dirname(__FILE__) + '/../../vendor/cacert.pem'),
          verify_mode: OpenSSL::SSL::VERIFY_PEER
        }
      end

      def authentication(account)
        {
          basic_auth: {
            user:     account.username,
            password: account.token
          }
        }
      end

      def configurations
        FatZebra.configurations
      end

      def get_account(options)
        case [options[:account].nil?, configurations.nil?]
        when [true, false]
          configurations
        when [false, true]
          options[:account]
        when [true, true]
          raise ConfigurationError, "No account specified"
        else # [false, false]
          if options[:account] == configurations
            # WARN: specifying account in two places
            configurations
          else
            raise ConfigurationError, "Ambiguous accounts specified"
          end
        end
      end
    end
  end
end
