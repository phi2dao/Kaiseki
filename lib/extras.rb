module Kaiseki
	LITERAL = CustomParser.new do
		@stream.lock do
			term = @stream.getc
			failed = true
			string = ''
			raise ParseError.new "unexpected character \"#{term}\" (expected \"\"\" or \"\'\") when parsing #{self}", @options[:rule] unless term == '"' or term == "'"
			while char = @stream.getc
				if char == term
					failed = false
					break
				elsif char == '\\'
					if match = @stream.match(/\d+/)
						string << Kernel.eval("\"\\#{match}\"")
					else
						string << Kernel.eval("\"\\#{@stream.getc}\"")
					end
				else
					string << char
				end
			end
			if failed
				raise ParseError.new "unexpected end-of-string (expected \"#{term}\") when parsing #{self}", @options[:rule]
			else
				string
			end
		end
	end
end