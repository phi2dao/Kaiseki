module Kaiseki
	class GrammarStub < PackageParser
		attr_reader :grammar
		
		def initialize expected, grammar
			super expected
			@grammar = grammar
		end
		
		def parse! stream, options = {}
			@expected.parse stream, options.merge(:grammar => @grammar)
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.grammar == @grammar
		end
		
		alias :== :eql?
	end
end