module Kaiseki
	class CustomParser < BasicParser
		NODE = Node.subclass [:stream, :options]
		
		def initialize is_predicate = false, &block
			super block
			@is_predicate = is_predicate
		end
		
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				NODE.new([stream, options], options[:global]).eval options[:global], &@expected
			end
		end
		
		def predicate?
			@is_predicate
		end
	end
end