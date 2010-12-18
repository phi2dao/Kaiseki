module Kaiseki
	class SetVar < PackageParser
		attr_reader :vars
		
		def initialize expected, *vars
			super expected
			@vars = []
			vars.each {|n| @vars << n }
		end
		
		def parse! stream, options = {}
			result = @expected.parse stream, options
			options[:global] ||= {}
			@vars.each {|n| options[:global][n] = result }
			result
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.vars == @vars
		end
		
		alias :== :eql?
	end
end