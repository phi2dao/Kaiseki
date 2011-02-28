module Kaiseki
	class BasicTag < PackageParser
		attr_reader :name
		
		def initialize expected, name
			super expected
			@name = name
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.name == @name
		end
		
		alias :== :eql?
	end
end