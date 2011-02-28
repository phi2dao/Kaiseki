module Kaiseki
	class MultiParser < BasicParser
		def initialize *parsers
			@expected = parsers.collect {|n| n.to_parseable }
		end
		
		def append parseable
			@expected << parseable.to_parseable
			self
		end
		
		def delimiter
			'--'
		end
		
		def to_s
			if @expected.empty?
				'(empty)'
			else
				@expected.join ' ' + delimiter + ' '
			end
		end
	end
end