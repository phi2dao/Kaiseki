require 'kaiseki'

module Kaiseki
	class StringParslet < Parslet
		def initialize string
			raise TypeError, "can't convert #{string.class} into String" unless string.is_a? String
			super string
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = StringResult.new
			pos = stream.pos
			@expected.each_char do |char|
				actual = stream.getc
				if actual.nil?
					stream.rewind pos
					raise ParseError.new "unexpected end-of-string (expected `#{char}') while parsing `#{@expected}'",
							options.merge(:line_end => stream.line, :column_end => stream.column)
				elsif actual != char
					stream.rewind pos
					raise ParseError.new "unexpected character `#{actual}' (expected `#{char}') while parsing `#{@expected}'",
							options.merge(:line_end => stream.line, :column_end => stream.column)
				else
					parsed << actual
				end
			end
			parsed
		end
	end
end