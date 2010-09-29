require 'kaiseki'

module Kaiseki
	class ProcParslet < Parslet
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			@expected.call stream, options
		end
	end
end