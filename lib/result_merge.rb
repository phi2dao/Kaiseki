module Kaiseki
	class MergeResult < PackageParser
		
		private
		def parse! stream, options = {}
			results = @expected.parse stream, options
			new_results = []
			if results.respond_to? :each
				results.each do |result|
					if result.respond_to? :each
						result.each {|n| new_results << n }
					else
						new_results << result
					end
				end
			else
				new_results = results
			end
			new_results
		end
	end
end