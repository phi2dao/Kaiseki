module Kaiseki
	class ParseError < StandardError
		attr_accessor :rule, :line, :column
		
		def initialize string, options
			super string
			@rule = options[:rule]
			@line = nil
			@column = nil
		end
		
		def verbose
			to_s
		end
	end
end