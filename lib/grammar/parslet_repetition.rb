module Kaiseki
	class ParsletRepetition
		include ParsletCombining
		
		attr_reader :parseable, :min, :max
		
		def initialize parseable, min, max = nil
			@parseable = parseable
			@min = min
			@max = max
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = ArrayResult.new
			pos = stream.pos
			while @max.nil? or parsed.length < @max
				begin
					parsed << @parseable.parse(stream, options)
				rescue ParseError
					if options[:skipping]
						begin
							options[:skipping].parse stream, options.merge(:skipping => nil, :logger => nil)
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
				raise ParseError.new "required #{@min} match#{'es' unless @min == 1} but obtained #{parsed.length} (expected `#{@parseable}')",
						options.merge(:line_end => stream.line, :column_end => stream.column)
			else
				if options[:simplify]
					if @min == 0 and @max == 1
						parsed.length == 0 ? nil : parsed.first
					else
						parsed
					end
				else
					parsed
				end
			end
		end
		
		def to_s
			"repeat(#{@min}, #{@max}): #{@parseable}"
		end
		
		def to_parseable
			self
		end
		
		def eql? other
			other.is_a?(ParsletRepetition) and other.parseable == @parseable and other.min == @min and other.max == @max
		end
		
		alias :== :eql?
	end
end