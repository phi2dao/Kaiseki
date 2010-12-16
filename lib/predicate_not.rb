module Kaiseki
	class NotPredicate < PackageParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				begin
					result = @expected.parse stream, options
				rescue ParseError
					throw :PredicateSuccess
				end
				raise ParseError.new "predicate not satisfied when parsing #{self}: matched #{result}", options
			end
		end
		
		def to_s
			"#{@expected}.not!"
		end
	end
end