module Kaiseki
	class RepeatParser
		include Parseable
		attr_reader :expected, :min, :max
		
		def initialize expected, min, max = nil
			raise ArgumentError, "expected must not be a predicate" if expected.predicate?
			@expected = expected.to_parseable
			@min = min
			@max = max
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.min == @min and other.max == @max
		end
		
		alias :== :eql?
		
		def to_s
			if @max
				@expected.to_s + " [#{@min}..#{@max}]"
			else
				@expected.to_s + " [#{@min}+]"
			end
		end
		
		private
		def parse! stream, options = {}
			result = []
			while @max.nil? or result.length < @max
				begin
					protect do
						result << @expected.parse(stream, options)
					end
				rescue ParseError
					if options[:skipping]
						begin
							protect do
								options[:skipping].parse stream, options.merge(:skipping => nil)
							end
							redo
						rescue ParseError
							break
						end
					else
						break
					end
				rescue NotImplementedError
					break
				end
			end
			if result.length < @min
				raise ParseError.new "expected #{@min} match#{'es' unless @min == 1} but obtained #{result.length} when parsing #{self}", options
			else
				if options[:simplify]
					if @min == 0 and @max == 1
						result.length == 0 ? nil : result[0]
					else
						result
					end
				else
					result
				end
			end
		end
	end
end