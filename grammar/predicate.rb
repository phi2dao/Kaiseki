require 'kaiseki'

module Kaiseki
	class Predicate
		include ParsletCombining
		
		attr_reader :parseable
		
		def initialize parseable
			@parseable = parseable
			@prefix = 'predicate: '
		end
		
		def parse *args
			raise NotImplementedError
		end
		
		def to_s
			@prefix + @parseable.to_s
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(self.class) and other.parseable == @parseable
		end
		
		alias :== :eql?
	end
end