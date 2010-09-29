require 'kaiseki'

module Kaiseki
	class ParsletCombination
		attr_reader :components
		
		def initialize *components
			@components = components
			@delimiter = '--'
		end
		
		def append object
			@components << object.to_parseable
		end
		
		def parse *args
			raise NotImplementedError
		end
		
		def to_s
			@components.join " #{@delimiter} "
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(self.class) and other.components == @components
		end
		
		alias :== :eql?
	end
end