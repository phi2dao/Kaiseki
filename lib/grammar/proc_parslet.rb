module Kaiseki
	class ProcParslet < Parslet
		def initialize procedure = nil, &block
			raise ArgumentError, "can't have both an argument and a block" if block_given? and procedure
			if block_given?
				super block
			else
				raise TypeError, "can't convert #{procedure.class} into Proc" unless procedure.is_a? Proc
				super procedure
			end
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			@expected.call stream, options
		end
	end
end