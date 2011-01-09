module Kaiseki
	attr_reader :name
	
	class CustomParser < BasicParser
		def initialize name = nil, is_predicate = false, &block
			super block
			@name = name
			@is_predicate = is_predicate
		end
		
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				@expected.call stream, options
			end
		end
		
		def predicate?
			@is_predicate
		end
		
		def to_s
			@name || @expected.inspect
		end
	end
end