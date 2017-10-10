require 'net/https'
require 'uri'
require 'nokogiri'
require 'signer'
require 'ostruct'
require 'builder'
require 'logger'

require 'transbank/webpay/version'
require 'transbank/webpay/configuration'
require 'transbank/webpay/vault'
require 'transbank/webpay/validations'
require 'transbank/webpay/struct'
require 'transbank/webpay/reader'
require 'transbank/webpay/exceptions'
require 'transbank/webpay/messages'
require 'transbank/webpay/helper'
require 'transbank/webpay/exception_response'
require 'transbank/webpay/client'
require 'transbank/webpay/response'
require 'transbank/webpay/document'
require 'transbank/webpay/params'
require 'transbank/webpay/request'
require 'transbank/webpay/api'

module Transbank
  module Webpay
    class << self
      attr_reader :configuration
      attr_reader :log

      # Delegate api
      Api.instance_methods.each { |m| define_method(m) { |*args| api.send(m, *args) } }

      def configure
        @configuration ||= Configuration.new
        yield(@configuration)
      end

      def api
        @api ||= Api.new
      end

      def log message
        logger.info message if true
      end

      protected

      def logger
        @logger ||= Logger.new($stdout).tap do |log|
          log.progname = self.name
        end
      end

    end
  end
end
