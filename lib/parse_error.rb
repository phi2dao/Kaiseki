module Kaiseki
	class ParseError < StandardError
		attr_accessor :rule, :child, :line, :column
		
		def initialize string, rule, child = nil
			super string
			@rule = rule
			@child = child
		end
		
		def verbose
			"[#{@line ? @line + 1 : 0}:#{@column ? @column + 1 : 0}] #{to_s} [in #{@rule}]"
		end
		
		def parsetrace
			array = [self]
			while array.last.child
				array << array.last.child
			end
			array.reverse
		end
	end
end