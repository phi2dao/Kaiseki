module Kaiseki
	class Action < BasicParser
		def parse! stream, options = {}
			Node.new([], options[:global]).eval options[:global], &@expected
			throw :SkipSuccess
		end
	end
end