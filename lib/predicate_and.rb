module Kaiseki
	class AndPredicate < PackageParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				begin
					@expected.parse stream, options
				rescue ParseError => e
					raise ParseError.new "predicate not satisfied when parsing #{self}: #{e.to_s}", options
				end
				throw :PredicateSuccess
			end
		end
		
		def predicate?
			true
		end
		
		def to_s
			"#{@expected}.and?"
		end
	end
end