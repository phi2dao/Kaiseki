module Kaiseki
	class Action < BasicParser
		def parse! stream, options = {}
			Node.new([], options[:global]).eval &@expected
			throw :SkipSuccess
		end
	end
end