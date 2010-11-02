module Kaiseki
	class ArrayResult < Array
		include LocationTracking
		
		attr_reader :info
		
		def initialize arg1 = 0, arg2 = nil, info = {}
			super arg1, arg2
			self.line_start = info[:line_start] if info.key? :line_start
			self.column_start = info[:column_start] if info.key? :column_start
			self.line_end = info[:line_end] if info.key? :line_end
			self.column_end = info[:column_end] if info.key? :column_end
			@info = info
		end
	end
end