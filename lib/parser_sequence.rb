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
								protect do
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
					case result.length
					when 0
						throw :SkipSuccess
					when 1
						result[0]
					else
						result
					end
				else
					result
				end
			end
		end
		
		alias :& :append
		
		def predicate?
			@expected.find {|n| !n.predicate? } ? false : true
		end
		
		def delimiter
			'&'
		end
	end
end