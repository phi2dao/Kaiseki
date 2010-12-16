module Kaiseki
	class SymbolParser < BasicParser
		def parse! stream, options = {}
			if options[:grammar]
				if options[:grammar].rules[@expected]
					options[:grammar].rules[@expected].parse stream, options.merge(:rule => @expected)
				else
					STDERR.puts "skipping #{self}: not implemented"
					throw :SkipSuccess
				end
			else
				raise "can't use #{self} without a grammar"
			end
		end
	end
end