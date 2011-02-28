module Kaiseki
	class ParseResult
		attr_reader :results, :errors
		
		def initialize
			@results = {}
			@errors = {}
		end
		
		def parsed?
			@errors.empty?
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
	end
end