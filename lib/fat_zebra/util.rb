module FatZebra
  module Util
    class << self

      DATE_FORMAT = '%Y/%m/%d'.freeze
      REGEXP_HTTP = %r{http[s]?\:\/\/}

      def cleanup_host(uri)
        uri.to_s.gsub(REGEXP_HTTP, '')
      end

      ##
      # Remove nil value from hash
      #
      # @return [Hash]
      def compact(hash)
        # Can use Hash#compact when Ruby 2.3 compatability is dropped
        hash.reject { |_, value| value.nil? }
      end

      ##
      # Convert string to camelize
      #
      # @param [String]
      #
      # @example
      #   camelize('my_model') => 'MyModel'
      def camelize(string)
        string.split('_').map(&:capitalize).join
      end

      ##
      # Convert string to underscore
      #
      # @param [String]
      #
      # @example
      #   underscore('MyModel') => 'my_model'
      def underscore(string)
        string
          .gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
      end

      def hash_except(hash, *keys)
        copy = hash.dup
        keys.each { |key| copy.delete(key) }
        copy
      end

      ##
      # Format Date attribute in the params
      #
      # @param [Hash] params
      #
      # @return [Hash] date formated params
      def format_dates_in_hash(hash)
        # Can use Hash#transform_values! when Ruby 2.3 compatablility is dropped
        hash.each do |(key, value)|
          hash[key] = value.strftime DATE_FORMAT if value.respond_to? :strftime
        end

        hash
      end

    end
  end
end
