module Kaiseki
	class AndPredicate < PackageParser
		def predicate?
			true
		end
		
		def to_s
			"#{@expected}.and?"
		end
		
		private
		def parse! stream, options = {}
			begin
				@expected.parse stream, options
			rescue ParseError => e
				raise ParseError.new "predicate not satisfied when parsing #{self}: #{e.to_s}", options
			end
			throw :PredicateSuccess
		end
	end
end