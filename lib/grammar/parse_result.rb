module Kaiseki
	class ParseResult
		attr_accessor :grammar, :stream, :options, :result, :error, :logger
		
		def initialize grammar, stream, options
			@grammar = grammar
			@stream = stream
			@options = options
			@result = nil
			@error = nil
			@logger = ParseLogger.new
		end
		
		def parsed?
			!@error
		end
		
		def error_message
			"#{@error}\n\t#{@error.location}"
		end
		
		alias :msg :error_message
		
		def reparse options = {}
			@stream.rewind
			@grammar.parse @stream, @options.merge(options)
		end
		
		def backtrace
			@logger.backtrace
		end
	end
end