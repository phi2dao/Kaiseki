require 'kaiseki'

module Kaiseki
	class SymbolParslet
		include ParsletCombining
		
		attr_reader :symbol
		
		def initialize symbol
			@symbol = symbol
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			raise ArgumentError, "parsing requires a grammar" unless options.key? :grammar
			options[:grammar].wrap stream, options.merge(:rule => @symbol)
		end
		
		def to_s
			"rule: #{@symbol}"
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(SymbolParslet) and other.symbol == symbol
		end
		
		alias :== :eql?
	end
end