module Kaiseki
	class ResultTag < BasicTag
		
		private
		def parse! stream, options = {}
			result = @expected.parse stream, options
			if options.key? :result
				options[:result].results[@name] = result
			end
			result
		end
	end
end