require 'kaiseki'

module Kaiseki
	class ParsletOmission
		attr_reader :parseable
		
		def initialize parseable
			@parseable = parseable
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
		
		def to_s
			"skip: #{@parseable}"
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(ParsletOmission) and other.parseable == @parseable
		end
		
		alias :== :eql?
	end
end