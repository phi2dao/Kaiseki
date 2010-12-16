module Kaiseki
	class BasicParser
		include Parseable
		attr_reader :expected
		
		def initialize expected
			@expected = expected
		end
		
		def parse! stream, options = {}
			raise NotImplementedError
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected
		end
		
		alias :== :eql?
		
		def to_s
			@expected.inspect
		end
	end
end