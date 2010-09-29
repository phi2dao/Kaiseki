require 'kaiseki'

module Kaiseki
	class ParsletMerger < ParsletCombination
		def initialize *components
			super *components
			@delimiter = '&'
		end
		
		alias :>> :append
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = ArrayResult.new
			pos = stream.pos
			@components.each do |parseable|
				catch :PredicateSuccess do
					begin
						result = parseable.parse stream, options
						if result.respond_to? :each
							result.each {|n| parsed << n }
						else
							parsed << result
						end
					rescue ParseError => e
						if options.key? :skipping
							begin
								mod_options = options.dup
								mod_options.delete :skipping
								options[:skipping].parse stream, mod_options
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
			parsed
		end
	end
end