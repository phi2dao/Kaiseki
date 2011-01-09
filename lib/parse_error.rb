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
			"#{@line ? @line + 1 : 0}:#{@column ? @column + 1 : 0}:#{to_s}"
		end
	end
end