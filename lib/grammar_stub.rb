module Kaiseki
	class GrammarStub < PackageParser
		attr_reader :grammar, :rule
		
		def initialize expected, grammar, rule = '(main)'
			super expected
			@grammar = grammar
			@rule = rule
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.grammar == @grammar
		end
		
		alias :== :eql?
		
		private
		def parse! stream, options = {}
			default_options = {
				:grammar => @grammar,
				:rule => @rule.to_s,
				:skipping => @grammar.skipping_rule,
				:simplify => @grammar.simplify,
			}
			@expected.parse stream, default_options.merge(options)
		end
	end
end