module Kaiseki
	class ListParser
		include Parseable
		attr_reader :expected, :delimiter
		
		def initialize expected, delimiter = ','
			raise ArgumentError, "expected must not be a predicate" if expected.predicate?
			@expected = expected
			@delimiter = delimiter
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.delimiter = @delimiter
		end
		
		alias :== :eql?
		
		def to_s
			"#{@expected}#{@delimiter} ..."
		end
		
		private
		def parse! stream, options = {}
			result = []
			loop do
				begin
					catch :SkipSuccess do
						result << @expected.parse(stream, options)
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
				end
				begin
					protect do
						@delimiter.parse stream, options
					end
				rescue ParseError => e
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
end