module Kaiseki
	module Parseable
		def to_parseable
			self
		end
		
		def parse stream, options = {}
			self.to_parseable.parse! stream.to_stream, options
		end
		
		def & other
			SequenceParser.new self, other
		end
		
		def | other
			ChoiceParser.new self, other
		end
		
		def repeat min, max = nil
			RepeatParser.new self, min, max
		end
		
		def optional
			repeat 0, 1
		end
		
		def zero_or_more
			repeat 0
		end
		
		def one_or_more
			repeat 1
		end
		
		def and?
			AndPredicate.new self
		end
		
		def not!
			NotPredicate.new self
		end
		
		def skip
			SkipPredicate.new self
		end
		
		def override options
			OverrideResult.new self, options
		end
		
		def merge
			MergeResult.new self
		end
		
		def cast to_class
			CastResult.new self, to_class
		end
		
		def filter node = Class.new(Node).bind(:result), &block
			FilterResult.new self, node, &block
		end
	end
end