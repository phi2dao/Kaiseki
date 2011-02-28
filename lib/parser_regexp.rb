module Kaiseki
	class RegexpParser < BasicParser
		private
		def parse! stream, options = {}
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