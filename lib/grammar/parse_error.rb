module Kaiseki
	class ParseError < Exception
		include LocationTracking
		
		attr_reader :file, :rule
		
		def initialize message, info = {}
			super message
			self.line_start = info[:line_start] if info.key? :line_start
			self.column_start = info[:column_start] if info.key? :column_start
			self.line_end = info[:line_end] if info.key? :line_end
			self.column_end = info[:column_end] if info.key? :column_end
			@file = info[:file]
			@rule = info[:rule]
		end
		
		def location
			"from #{@file || 'unknown'}:#{line_end + 1}:#{column_end + 1} in #{@rule || 'unknown'}"
		end
	end
end