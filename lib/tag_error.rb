module Kaiseki
	class ErrorTag < BasicTag
		
		private
		def parse! stream, options = {}
			begin
				@expected.parse stream, options
			rescue ParseError => e
				if options.key? :result
					options[:result].errors[@name] = e
				end
				raise e
			end
		end
	end
end