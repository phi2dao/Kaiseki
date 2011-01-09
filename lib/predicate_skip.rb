module Kaiseki
	class SkipPredicate < PackageParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				begin
					@expected.parse stream, options
				rescue ParseError => e
					raise ParseError.new "predicate not satisfied when parsing #{self}: #{e.to_s}", options
				end
				throw :SkipSuccess
			end
		end
		
		def predicate?
			true
		end
		
		def to_s
			"#{@expected}.skip"
		end
	end
end