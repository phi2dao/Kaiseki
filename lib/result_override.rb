module Kaiseki
	class OverrideResult < PackageParser
		attr_reader :options
		
		def initialize expected, options
			super expected
			@options = options
		end
		
		def parse! stream, options = {}
			@expected.parse stream, options.merge(@options)
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.options == @options
		end
		
		alias :== :eql?
	end
end