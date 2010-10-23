require 'kaiseki'

module Kaiseki
	class ParseResult
		attr_reader :result, :error, :grammar, :stream, :options
		
		def initialize options = {}
			@result = options[:result]
			@error = options[:error]
			@grammar = options[:grammar]
			@stream = options[:stream]
			@options = options[:options]
		end
		
		def success?
			@error.nil?
		end
	end
end