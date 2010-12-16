module Kaiseki
	class SequenceParser < MultiParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				result = []
				@expected.each do |n|
					catch :SkipSuccess do
						begin
							result << n.parse(stream, options)
						rescue ParseError => e
							if options[:skipping]
								begin
									options[:skipping].parse stream, options.merge(:skipping => nil, :logger => nil)
									#options[:logger].stack.last[2].pop if options.key? :logger
									redo
								rescue ParseError
									raise e
								end
							else
								raise e
							end
						end
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