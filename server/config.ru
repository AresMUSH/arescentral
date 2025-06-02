require 'rubygems'

require 'bundler'

Bundler.require

require_relative 'arescentral'

AresCentral.start_logger
run AresCentral::ApiServer.new
