module Kaiseki
	class InsertVar < BasicParser
		def to_s
			"#{@expected.is_a?(Symbol) ? "$#{@expected}" : @expected.inspect} (ins)"
		end
		
		private
		def parse! stream, options = {}
			if @expected.is_a? Symbol
				if options[:global] and options[:global].key?(@expected)
					options[:global][@expected]
				else
					raise "$#{@expected} undefined"
				end
			else
				@expected
			end
		end
	end
end