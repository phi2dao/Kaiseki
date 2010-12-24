module Kaiseki
	class RepeatParser
		include Parseable
		attr_reader :expected, :min, :max
		
		def initialize expected, min, max = nil
			@expected = expected.to_parseable
			@min = min
			@max = max
		end
		
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				result = []
				count = 0
				while max.nil? or count < @max
					begin
						catch :SkipSuccess do
							result << @expected.parse(stream, options)
							count += 1
							next
						end
						count += 1
						break if max.nil?
					rescue ParseError
						if options[:skipping]
							begin
								catch :SkipSuccess do
									options[:skipping].parse stream, options.merge(:skipping => nil)
								end
								redo
							rescue ParseError
								break
							end
						else
							break
						end
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
	end
end