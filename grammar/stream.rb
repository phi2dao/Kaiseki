require 'kaiseki'

module Kaiseki
	class Stream
		attr_reader :file
		
		def initialize source
			if source.is_a? String
				@file = nil
				@string = source.dup
			elsif source.is_a? File
				@file = source.path
				@string = ''
				source.each_char {|c| @string << c }
			else
				raise TypeError, "can't convert #{source.class} into Stream"
			end
			@pos = 0
			@newlines = []
			start = 0
			@string.length.times do |i|
				if @string[i] == "\n"
					@newlines << [start, i]
					start = i + 1
				end
			end
			@newlines << [start, @string.length]
		end
		
		def to_s
			@string.dup
		end
		
		def length
			@string.length
		end
		
		def pos
			@pos
		end
		
		def line
			bsearch @pos, 0, @newlines.length
		end
		
		def column
			@pos - @newlines[self.line].first
		end
		
		def getc num = 0
			if num == 0
				char = @string[@pos]
				if char
					@pos += 1
					char
				end
			elsif num > 0
				string = @string[@pos..(@pos + num - 1)]
				@pos += string.length
				string
			else
				string = @string[@pos..num]
				@pos += string.length
				string
			end
		end
		
		def rewind pos = 0
			if pos < 0
				pos = @string.length + pos + 1
				@pos = pos < 0 ? 0 : pos
			elsif pos > @string.length
				@pos = @string.length
			else
				@pos = pos
			end
		end
		
		private
		def bsearch value, low, high
			return nil if high < low
			mid = low + (high - low) / 2
			if value < @newlines[mid].first
				bsearch value, low, mid - 1
			elsif value > @newlines[mid].last
				bsearch value, mid + 1, high
			else
				mid
			end
		end
	end
end