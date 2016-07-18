module Transbank
  module Webpay
    class Response
      include Validations
      include Reader
      include Helper

      attr_reader :attributes, :exception, :params

      def initialize(content, action, params)
        @content = content
        @action = action
        @params = params
        @attributes = xml_to_hash(doc.at_xpath("//return").to_s)
        @errors = []

        validate_response!
      end

      def http_code
        content.code
      end

      def inspect
        result = ["valid: #{valid?}"]
        result << attributes_display if attributes_hash.any?
        result << "error: \"#{errors_display}\"" if errors.any?
        "#<#{self.class} #{result.join(', ')} >"
      end

      def exception?
        false
      end

      def exception
        nil
      end

      def method_missing(method_name, *args, &block)
        attributes.respond_to?(method_name) && attributes.send(method_name) || super
      end

      def respond_to_missing?(method_name, include_private = false)
        attributes.respond_to?(method_name, include_private) || super
      end

      private

      def attributes_display
        attributes_hash.map { |name, value| "#{name}: \"#{value}\"" }.join ', '
      end

      def attributes_hash
        @attributes_hash ||= attributes.to_h
      end
    end
  end
end
