module Kaiseki
	class StringParser < BasicParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				@expected.each_char do |char|
					actual = stream.getc
					if actual.nil?
						raise ParseError.new "unexpected end-of-string (expected \"#{char}\") when parsing #{self}", options
					elsif actual != char
						raise ParseError.new "unexpected character \"#{actual}\" (expected \"#{char}\") when parsing #{self}", options
					end
				end
				@expected.dup
			end
		end
	end
end