module Kaiseki
	class SkipPredicate < PackageParser
		def predicate?
			true
		end
		
		def to_s
			"#{@expected}.skip"
		end
		
		private
		def parse! stream, options = {}
			begin
				@expected.parse stream, options
			rescue ParseError => e
				raise ParseError.new "predicate not satisfied when parsing #{self}: #{e.to_s}", options
			end
			throw :SkipSuccess
		end
	end
end