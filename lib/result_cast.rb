module Kaiseki
	class CastResult < PackageParser
		attr_reader :to_class
		
		def initialize expected, to_class
			super expected
			@to_class = to_class
		end
		
		def parse! stream, options = {}
			result = @expected.parse stream, options
			if @to_class == Integer
				result.to_i
			elsif @to_class == Float
				result.to_f
			elsif @to_class == String
				result.is_a?(Array) ? result.join : result.to_s
			elsif @to_class == Symbol
				result.is_a?(Array) ? result.join.to_sym : result.to_sym
			elsif @to_class == Array
				result.is_a?(String) ? result.split(options[:delimiter] || '') : result.to_a
			else
				raise "can't cast to #{@to_class}"
			end
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.to_class == @to_class
		end
		
		alias :== :eql?
	end
end