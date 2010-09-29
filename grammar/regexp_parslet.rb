require 'kaiseki'

module Kaiseki
	class RegexpParslet < Parslet
		def initialize regexp
			raise TypeError, "can't convert #{regexp.class} into Regexp" unless regexp.is_a? Regexp
			super regexp
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = StringResult.new
			pos = stream.pos
			match = stream.getc(-1).match /\A#{@expected}/
			if match
				stream.rewind pos + match.to_s.length
				parsed << match.to_s
				parsed.info[:captures] = match.captures
				parsed
			else
				stream.rewind pos
				raise ParseError.new "non-matching characters while parsing `#{@expected}'"
			end
		end
	end
end