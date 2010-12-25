module Kaiseki
	class SequenceParser < MultiParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				result = []
				@expected.each do |n|
					begin
						catch :SkipSuccess do
							result << n.parse(stream, options)
						end
					rescue ParseError => e
						if options[:skipping]
							begin
								catch :SkipSuccess do
									options[:skipping].parse stream, options.merge(:skipping => nil)
								end
								redo
							rescue ParseError
								raise e
							end
						else
							raise e
						end
					rescue NotImplementedError
						next
					end
				end
				if options[:simplify]
					result.length == 1 ? result[0] : result
				else
					result
				end
			end
		end
		
		alias :& :append
		
		def delimiter
			'&'
		end
	end
end