require 'kaiseki'

module Kaiseki
	class ParseError < Exception
		def initialize message, info = {}
			super message
		end
	end
end