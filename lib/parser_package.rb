module Kaiseki
	class PackageParser < BasicParser
		def initialize expected
			super expected.to_parseable
		end
		
		def predicate?
			@expected.predicate?
		end
		
		def to_s
			@expected.to_s
		end
	end
end