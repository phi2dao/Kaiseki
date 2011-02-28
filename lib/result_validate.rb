module Kaiseki
	class ValidateResult < PackageParser
		attr_reader :validators
		
		def initialize expected, validators
			super expected
			@validators = validators
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.validators == @validators
		end
		
		alias :== :eql?
		
		private
		def parse! stream, options = {}
			result = @expected.parse stream, options
			passed = true
			@validators.each do |key, value|
				case key
				when :includes
					passed = false unless value.find {|n| n === result }
				when :excludes
					passed = false if value.find {|n| n === result }
				when :is
					passed = false unless value.member? result
				when :not
					passed = false if value.member? result
				end
			end
			if passed
				result
			else
				raise ParseError.new "`#{result}' does not pass validation", options
			end
		end
	end
end