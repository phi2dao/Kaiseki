module Kaiseki
	class Stream
		attr_reader :pos
		
		def initialize string
			@string = string
			@pos = 0
			#index_lines
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
		
		def look
			if @string.length - @pos > 10
				"\"#{@string[@pos, 7] + '...'}\""
			else
				"\"#{@string[@pos..-1]}\""
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
			
		end
		
		def column
			
		end
		
		private
		def index_lines
			
		end
		
		def bsearch
			
		end
	end
end