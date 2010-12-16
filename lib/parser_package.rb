module Kaiseki
	class PackageParser < BasicParser
		def initialize expected
			super expected.to_parseable
		end
		
		def to_s
			@expected.to_s
		end
	end
end