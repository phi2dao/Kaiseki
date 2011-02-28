module Kaiseki
	class GetVar < BasicParser
		attr_reader :parser
		
		def initialize expected, parser
			super expected
			@parser = parser.to_parseable
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.parser == @parser
		end
		
		alias :== :eql?
		
		def to_s
			"#{@expected.is_a?(Symbol) ? "$#{@expected}" : @expected.inspect} (match)"
		end
		
		private
		def parse! stream, options = {}
			if @expected.is_a? Symbol
				if options[:global] and options[:global].key?(@expected)
					source = options[:global][@expected]
				else
					raise "$#{@expected} undefined"
				end
			else
				source = @expected
			end
			result = @parser.parse stream, options
			if source.is_a?(MatchData) and result.is_a?(MatchData) and source.to_s == result.to_s and source.regexp == result.regexp
				result
			elsif source == result
				result
			else
				raise ParseError.new "unexpected result #{result.inspect} (expected #{source.inspect}) when parsing #{@parser}", options
			end
		end
	end
end