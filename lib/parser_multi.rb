module Kaiseki
	class MultiParser < BasicParser
		def initialize *parsers
			@expected = []
			parsers.each do |n|
				append n
			end
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