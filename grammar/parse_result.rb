require 'kaiseki'

module Kaiseki
	class ParseResult
		attr_accessor :grammar, :stream, :options, :result, :error, :logger
		
		def initialize grammar, stream, options
			@grammar = grammar
			@stream = stream
			@options = options
			@result = nil
			@error = nil
			@logger = nil
		end
		
		def parsed?
			!@error
		end
		
		def reparse options = {}
			@stream.rewind
			@grammar.parse @stream, @options.merge(options)
		end
		
		def backtrace
			@logger.backtrace
		end
	end
end