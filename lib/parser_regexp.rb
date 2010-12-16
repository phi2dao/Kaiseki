module Kaiseki
	class RegexpParser < BasicParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				match = stream.match @expected
				if match
					if options[:simplify]
						match.to_s
					else
						match
					end
				else
					raise ParseError.new "non-matching characters when parsing #{self}", options
				end
			end
		end
	end
end