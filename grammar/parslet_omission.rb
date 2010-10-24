require 'kaiseki'

module Kaiseki
	class ParsletOmission < Predicate
		def initialize parseable
			super parseable
			@prefix = 'skip:'
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			pos = stream.pos
			begin
				@parseable.parse stream, options
			rescue ParseError => e
				stream.rewind pos
				raise e
			end
			throw :PredicateSuccess
		end
	end
end