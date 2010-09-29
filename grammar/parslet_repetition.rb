require 'kaiseki'

module Kaiseki
	class ParsletRepetition
		attr_reader :expected, :min, :max
		
		def initialize expected, min, max = nil
			@expected = expected
			@min = min
			@max = max
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = ArrayResult.new
			pos = stream.pos
			while @max.nil? or parsed.length < @max
				begin
					parsed << @expected.parse(stream, options)
				rescue ParseError
					if options.key? :skipping
						begin
							mod_options = options.dup
							mod_options.delete :skipping
							options[:skipping].parse stream, mod_options
							redo
						rescue ParseError
							break
						end
					else
						break
					end
				end
			end
			
			if parsed.length < @min
				stream.rewind pos
				raise ParseError.new "required #{@min} match#{'es' unless @min == 1} but obtained #{parsed.length} (expected `#{@expected}')"
			else
				parsed
			end
		end
		
		def to_s
			"repeat(#{@min}, #{@max}): #{@expected}"
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(ParsletRepetition) and other.expected == @expected and other.min == @min and other.max == @max
		end
		
		alias :== :eql?
	end
end