module Kaiseki
	class Stream
		attr_reader :pos
		
		def initialize string
			if string.is_a? File
				@string = string.to_a.join
			else
				@string = string.to_s
			end
			@pos = 0
			@newlines = []
			index_lines
		end
		
		def getc
			if @pos < @string.length
				@pos += 1
				@string[@pos - 1]
			else
				nil
			end
		end
		
		def match regexp
			match = @string[@pos..-1].match /\A#{regexp}/
			if match
				@pos += match.to_s.length
				match
			else
				nil
			end
		end
		
		def goto pos
			if pos < 0
				@pos = 0
			elsif pos > @string.length
				@pos = @string.length
			end
		end
		
		def lock &block
			safe_pos = @pos
			begin
				catch :PredicateSuccess do
					return block.call
				end
				@pos = safe_pos
				throw :SkipSuccess
			rescue ParseError => e
				@pos = safe_pos
				#e.line ||= self.line
				#e.column ||= self.column
				raise e
			end
		end
		
		def to_s
			@string.dup
		end
		
		def to_stream
			self
		end
		
		def length
			@string.length
		end
		
		alias :size :length
		
		def line
			bsearch @pos, 0, @newlines.length
		end
		
		def column
			@pos - @newlines[self.line][0]
		end
		
		private
		def index_lines
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
		
		def bsearch value, low, high
			return nil if high < low
			mid = low + (high - low) / 2
			if value < @newlines[mid][0]
				bsearch value, low, mid - 1
			elsif value > @newlines[mid][1]
				bsearch value, mid + 1, high
			else
				mid
			end
		end
	end
end