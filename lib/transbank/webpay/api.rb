module Transbank
  module Webpay
    class Api
      include Params

      def init_transaction(underscore_params = {})
        params = build_init_transaction_params(underscore_params)
        url    = config.wsdl_transaction_url
        Transbank::Webpay.log "----- init transaction -----"
        Transbank::Webpay.log params
        Transbank::Webpay.log url
        Request.new(url, :init_transaction, params).response
      end

      def get_transaction_result(token)
        params = { tokenInput: token }
        url    = config.wsdl_transaction_url
        Transbank::Webpay.log "----- get transaction result -----"
        Transbank::Webpay.log params
        Transbank::Webpay.log url
        Request.new(url, :get_transaction_result, params).response
      end

      def acknowledge_transaction(token)
        params = { tokenInput: token }
        url    = config.wsdl_transaction_url
        Transbank::Webpay.log "----- acknowledge transaction -----"
        Transbank::Webpay.log params
        Transbank::Webpay.log url
        Request.new(url, :acknowledge_transaction, params).response
      end

      def nullify(underscore_params = {})
        params = build_nullify_params(underscore_params)
        url    = config.wsdl_nullify_url
        Request.new(url, :nullify, params).response
      end

      private

      def config
        Transbank::Webpay.configuration
      end
    end
  end
end
