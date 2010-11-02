module Kaiseki
	class NotPredicate < Predicate
		def initialize parseable
			super parseable
			@prefix = 'not'
		end
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			pos = stream.pos
			begin
				@parseable.parse stream, options
			rescue ParseError
				stream.rewind pos
				throw :PredicateSuccess
			end
			stream.rewind pos
			raise ParseError.new "predicate not satisfied (`#{@parseable}' not allowed)",
					options.merge(:line_end => stream.line, :column_end => stream.column)
		end
	end
end