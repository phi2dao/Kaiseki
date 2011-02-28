module Kaiseki
	class CustomParser < BasicParser
		NODE = Node.subclass [:stream, :options]
		
		def initialize is_predicate = false, &block
			super block
			@is_predicate = is_predicate
		end
		
		def predicate?
			@is_predicate
		end
		
		private
		def parse! stream, options = {}
			NODE.new([stream, options], options[:global]).eval options[:global], &@expected
		end
	end
end