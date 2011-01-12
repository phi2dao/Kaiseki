module Kaiseki
	class ParseResult
		attr_reader :result, :error
		
		def initialize &block
			begin
				catch :SkipSuccess do
					@result = block.call
					return
				end
				@result = '(skipped)'
			rescue ParseError => e
				@error = e.verbose
			end
		end
		
		def parsed?
			@result ? true : false
		end
	end
end