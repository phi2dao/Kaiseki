module Kaiseki
	module LocationTracking
		def line_start
			@line_start || 0
		end
		
		def line_start= number
			@line_start = number.to_i
		end
		
		def column_start
			@column_start || 0
		end
		
		def column_start= number
			@column_start = number.to_i
		end
		
		def start
			[line_start, column_start]
		end
		
		def start= array
			raise TypeError, "can't convert #{array.class} into Array" unless array.is_a? Array
			raise ArgumentError, "array must have length 2" unless array.length == 2
			@line_start = array[0]
			@column_start = array[1]
		end
		
		def line_end
			@line_end || 0
		end
		
		def line_end= number
			@line_end = number.to_i
		end
		
		def column_end
			@column_end || 0
		end
		
		def column_end= number
			@column_end = number.to_i
		end
		
		def end
			[line_end, column_end]
		end
		
		def end= array
			raise TypeError, "can't convert #{array.class} into Array" unless array.is_a? Array
			raise ArgumentError, "array must have length 2" unless array.length == 2
			@line_end = array[0]
			@column_end = array[1]
		end
	end
end