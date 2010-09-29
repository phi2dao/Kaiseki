require 'kaiseki'

module Kaiseki
	class AndPredicate < Predicate
		def initialize parseable
			super parseable
			@prefix = 'and: '
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			pos = stream.pos
			begin
				@parseable.parse stream, options
			rescue ParseError
				stream.rewind pos
				raise ParseError.new "Predicate not satisfied (expecting `#{@parseable}')"
			end
			stream.rewind pos
			throw :PredicateSuccess
		end
	end
end