require 'kaiseki'

module Kaiseki
	class ParseError < Exception
		def initialize message, info = {}
			super message
			@info = info
		end
	end
end