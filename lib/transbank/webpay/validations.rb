module Transbank
  module Webpay
    module Validations
      attr_reader :errors

      def errors_display
        errors.join ', '
      end

      def valid?
        errors.empty?
      end

      def validate_response!
        validate_response_code!
        validate_http_response!

        return if errors.any? || validate_document
        Transbank::Webpay.log "----- errors -----"
        Transbank::Webpay.log errors

        raise Transbank::Webpay::Exceptions::InvalidSignature, 'Invalid signature'
      end

      private

      def calculated_digest
        Transbank::Webpay.log "----- calculated_digest -----"
        node = doc.at_xpath('//soap:Body')
        node_canonicalize = node.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, nil, nil)
        digest = OpenSSL::Digest::SHA1.new.reset.digest(node_canonicalize)
        c_digest = Base64.encode64(digest).strip
        Transbank::Webpay.log "----- calculated_digest -----"
        Transbank::Webpay.log c_digest
        c_digest
      end

      # def server_cert
      #   @server_cert ||= begin
      #     path = Transbank::Webpay.configuration.server_cert_path
      #     OpenSSL::X509::Certificate.new File.read(path)
      #   end
      # end

      # def pub_key
      #   server_cert.public_key
      # end

      # Validations
      def validate_response_code!
        Transbank::Webpay.log "----- validate_response_code -----"
        Transbank::Webpay.log "----- xml_response_code -----"
        Transbank::Webpay.log xml_response_code
        return if xml_response_code.empty?
        @errors << response_code_display if xml_response_code != '0'
      end

      def validate_http_response!
        Transbank::Webpay.log "----- validate_http_response -----"
        return if content.class == Net::HTTPOK

        @errors += xml_error_display
        @errors << content.message if content.respond_to?(:message) && @errors.empty?
        Transbank::Webpay.log "----- content.message -----"
        Transbank::Webpay.log content.message
      end

      def validate_document
        Transbank::Webpay.log "----- validate_document -----"
        return false if signature_node.nil?
        validate_digest && validate_signature
      end

      def validate_signature
        Transbank::Webpay.log "----- validate_signature -----"
        signed_node_canonicalize = signed_node.canonicalize(
          Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ["soap"], nil
        )

        Transbank::Webpay.log "----- signed_node_canonicalize -----"
        Transbank::Webpay.log signed_node_canonicalize

        response = Transbank::Webpay::Vault.pub_key.verify(
          OpenSSL::Digest::SHA1.new,
          signature_decode,
          signed_node_canonicalize
        )

        Transbank::Webpay.log "----- validate_signature ----- #{response}"
        response
      end

      def validate_digest
        Transbank::Webpay.log "----- validate_digest -----"
        Transbank::Webpay.log "----- digest -----"
        Transbank::Webpay.log digest
        calculated_digest == digest
      end
    end
  end
end
