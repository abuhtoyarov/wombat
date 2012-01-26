#coding: utf-8
require 'wombat/metadata'
require 'wombat/property'
require 'wombat/parser'
require 'active_support'
require 'date'

module Wombat
  module Crawler
    extend ActiveSupport::Concern

    module InstanceMethods
      def crawl
        parser.parse self.class.send(:metadata)
      end

      def supports_city?
      end

      def parser
        @parser ||= Parser.new
      end

      def parser= parser
        @parser = parser
      end
    end

    module ClassMethods
      [:event, :venue, :location].each do |m|
        define_method(m) do |&block|
          block.call(metadata["#{m.to_s}_props".to_sym]) if block
        end
      end

      def method_missing method, *args, &block
        metadata.send method, *args, &block
      end

      def with_details_page
        yield metadata if block_given?
      end

      def supported_cities
      end

      def to_ary
      end

      private
      def metadata
        @metadata ||= Metadata.new
      end
    end
  end
end