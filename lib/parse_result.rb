module Kaiseki
	class ParseResult
		attr_reader :results, :errors
		
		def initialize
			@results = {}
			@errors = {}
		end
		
		def parsed?
			@results.key?(:main)
		end
		
		def result
			@results[:main]
		end
		
		def error
			@errors[:main]
		end
		
		def error_msg error = :main
			@errors.key?(error) ? @errors[error].verbose : nil
		end
		
		def backtrace error = :main
			@errors.key?(error) ? @errors[error].parsetrace.collect {|n| n.verbose } : nil
		end
	end
end