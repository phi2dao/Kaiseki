require 'kaiseki'

module Kaiseki
	class ParseError < Exception
		include LocationTracking
		
		attr_reader :info
		
		def initialize message, info = {}
			super message
			self.line_start = info[:line_start] if info.key? :line_start
			self.column_start = info[:column_start] if info.key? :column_start
			self.line_end = info[:line_end] if info.key? :line_end
			self.column_end = info[:column_end] if info.key? :column_end
			@info = info
		end
		
		alias :string :to_s
		
		def to_s
			"ParseError: #{string}#{"\n\tin `#{@info[:rule]}'" if @info[:rule]}\n\tfrom line #{self.line_end} column #{self.column_end}"
		end
	end
end