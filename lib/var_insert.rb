module Kaiseki
	class InsertVar < BasicParser
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
		
		def to_s
			"#{@expected.inspect} (ins)"
		end
	end
end