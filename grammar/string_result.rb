require 'kaiseki'

module Kaiseki
	class StringResult < String
		attr_reader :info
		
		def initialize string = '', info = {}
			super string
			@info = info
		end
	end
end