module Kaiseki
	class EOFParser
		include Parseable
		
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				actual = stream.getc
				if actual
					raise ParseError.new "unexpected character \"#{actual}\" (expected end-of-string) when parsing #{self}", options
				else
					true
				end
			end
		end
		
		def eql? other
			other.is_a? self.class
		end
		
		alias :== :eql?
		
		def to_s
			'EOF'
		end
	end
end