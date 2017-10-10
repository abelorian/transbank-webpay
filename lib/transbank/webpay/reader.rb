# encoding: utf-8
module Transbank
  module Webpay
    module Reader
      attr_reader :content, :action

      RESPONSE_CODE = {
        get_transaction_result: Transbank::Webpay::RESPONSE_CODE,
        default: {
          '0'   => 'aprobada',
          '-98' => 'Error'
        }
      }.freeze

      def doc
        @doc ||= Nokogiri::XML body
      end

      def response_code_display
        RESPONSE_CODE.fetch(action, RESPONSE_CODE[:default]).fetch(xml_response_code, xml_response_code)
      end

      def body
        content.body
      end

      def xml_error_display
        xml_error.map { |e| e.text.gsub(/<!--|-->/, '').strip }
      end

      def attributes?
        xml_return != ""
      end

      private

      def xml_return
        @xml_return ||= doc.at_xpath("//return").to_s
      end

      def signature_decode
        Base64.decode64(signature_node.content)
      end

      def xml_error
        doc.xpath("//faultstring")
      end

      def xml_response_code
        doc.xpath("//responseCode").text
      end

      def signature_node
        doc.at_xpath('//ds:SignatureValue', ds: 'http://www.w3.org/2000/09/xmldsig#')
      end

      def digest
        doc.at_xpath("//ds:DigestValue", ds: 'http://www.w3.org/2000/09/xmldsig#').text
      end

      def signed_node
        doc.at_xpath '//ds:SignedInfo', ds: 'http://www.w3.org/2000/09/xmldsig#'
      end
    end
  end
end
