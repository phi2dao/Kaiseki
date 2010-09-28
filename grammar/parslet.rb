require 'kaiseki'

module Kaiseki
	class Parslet
		attr_reader :expected
		
		def initialize expected
			@expected = expected
		end
		
		def parse *args
			raise NotImplementedError
		end
		
		def to_s
			@expected.to_s.dup
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected
		end
		
		alias :== :eql?
	end
end