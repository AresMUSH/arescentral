require 'rubygems'

require 'bundler'

Bundler.require

require_relative 'arescentral'

logger = AresCentral::Logger.new
logger.start

run AresCentral::ApiServer.new
