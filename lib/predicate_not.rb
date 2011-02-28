module Kaiseki
	class NotPredicate < PackageParser
		def predicate?
			true
		end
		
		def to_s
			"#{@expected}.not!"
		end
		
		private
		def parse! stream, options = {}
			begin
				result = @expected.parse stream, options
			rescue ParseError
				throw :PredicateSuccess
			end
			raise ParseError.new "predicate not satisfied when parsing #{self}: matched #{result}", options
		end
	end
end