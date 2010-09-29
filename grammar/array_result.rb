require 'kaiseki'

module Kaiseki
	class ArrayResult < Array
		attr_reader :info
		
		def initialize arg1 = 0, arg2 = nil, info = {}
			super arg1, arg2
			@info = info
		end
	end
end