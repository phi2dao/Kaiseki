module Kaiseki
	class EOFParser
		include Parseable
		
		def eql? other
			other.is_a? self.class
		end
		
		alias :== :eql?
		
		def to_s
			'EOF'
		end
		
		private
		def parse! stream, options = {}
			actual = stream.getc
			if actual
				raise ParseError.new "unexpected character \"#{actual}\" (expected end-of-string) when parsing #{self}", options[:rule]
			else
				true
			end
		end
	end
end