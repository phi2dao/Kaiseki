module Kaiseki
	class MergeResult < PackageParser
		def parse! stream, options = {}
			results = @expected.parse stream, options
			new_result = []
			if results.respond_to? :each
				results.each do |result|
					if result.respond_to? :each
						result.each {|n| new_result << n }
					else
						new_result << result
					end
				end
			else
				new_result = results
			end
			new_result
		end
	end
end