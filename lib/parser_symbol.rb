module Kaiseki
	class SymbolParser < BasicParser
		
		private
		def parse! stream, options = {}
			if options.key? :grammar
				if options[:grammar].rules.key? @expected
					options[:grammar].rules[@expected].parse stream, options.merge(:rule => @expected.to_s)
				else
					STDERR.puts "skipping #{self}: not implemented"
					raise NotImplementedError
				end
			else
				raise "can't use #{self} without a grammar"
			end
		end
	end
end