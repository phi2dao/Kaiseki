module Kaiseki
	class EOFParslet
		include ParsletCombining
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			pos = stream.pos
			char = stream.getc
			if char
				stream.rewind pos
				raise ParseError.new "unexpected character `#{char}' (expected EOF)",
						options.merge(:line_end => stream.line, :column_end => stream.column)
			else
				throw :PredicateSuccess
			end
		end
		
		def to_s
			'EOF'
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a? EOFParslet
		end
		
		alias :== :eql?
	end
end