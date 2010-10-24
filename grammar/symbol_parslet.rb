require 'kaiseki'

module Kaiseki
	class SymbolParslet < Parslet
		def initialize symbol
			raise TypeError, "can't convert #{symbol.class} into Symbol" unless symbol.is_a? Symbol
			super symbol
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			raise ArgumentError, "parsing requires a grammar" unless options.key? :grammar
			options[:grammar].wrap stream, options.merge(:rule => @expected)
		end
		
		def to_s
			":#{@expected}"
		end
	end
end