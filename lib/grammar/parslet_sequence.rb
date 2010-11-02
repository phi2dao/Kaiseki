module Kaiseki
	class ParsletSequence < ParsletCombination
		def initialize *components
			super *components
			@delimiter = '&'
		end
		
		alias :& :append
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = ArrayResult.new
			pos = stream.pos
			@components.each do |parseable|
				catch :PredicateSuccess do
					begin
						parsed << parseable.parse(stream, options)
					rescue ParseError => e
						if options[:skipping]
							begin
								options[:skipping].parse stream, options.merge(:skipping => nil, :logger => nil)
								redo
							rescue ParseError
								stream.rewind pos
								raise e
							end
						else
							stream.rewind pos
							raise e
						end
					end
				end
			end
			if options[:simplify]
				if parsed.length == 1
					parsed.first
				else
					parsed
				end
			else
				parsed
			end
		end
	end
end