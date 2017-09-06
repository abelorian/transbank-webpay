module Transbank
  module Webpay
    class Request
      attr_accessor :client, :document, :action, :params

      def initialize(wsdl_url, action, params = {})
        @params = params
        @action = action
        @document = Document.new(action, params)
        @client = Client.new wsdl_url
        Transbank::Webpay.log "----- Transbank Webpay Request -----"
        Transbank::Webpay.log "----- action -----"
        Transbank::Webpay.log action
        Transbank::Webpay.log "----- params -----"
        Transbank::Webpay.log params
        Transbank::Webpay.log "----- document -----"
        Transbank::Webpay.log @document
      end

      def response
        rescue_exceptions = Transbank::Webpay.configuration.rescue_exceptions

        @response ||= begin
          Response.new client.post(document.to_xml), action, params
        rescue match_class(rescue_exceptions) => error
          ExceptionResponse.new error, action, params
        end
        Transbank::Webpay.log "----- response -----"
        Transbank::Webpay.log @response
        @response
      end

      private

      def match_class(exceptions)
        m = Module.new
        (class << m; self; end).instance_eval do
          define_method(:===) do |error|
            (exceptions || []).include? error.class
          end
        end
        m
      end
    end
  end
end
