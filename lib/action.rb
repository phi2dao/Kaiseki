module Kaiseki
	class Action < BasicParser
		private
		def parse! stream, options = {}
			Node.new([], options[:global]).eval options[:global], &@expected
			throw :SkipSuccess
		end
	end
end