module Kaiseki
	module Parseable
		def to_parseable
			self
		end
		
		def parse stream, options = {}
			options[:global] ||= {}
			stream = stream.to_stream
			stream.lock do
				parse! stream, options
			end
		end
		
		def predicate?
			false
		end
		
		def protect &block
			catch :ParseSuccess do
				catch :SkipSuccess do
					block.call
					throw :ParseSuccess
				end
				raise RuntimeError, "#{self} must not catch a SkipSuccess"
			end
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
		
		def list delimiter = ','
			ListParser.new self, delimiter
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
		
		def filter node = Node.default, &block
			FilterResult.new self, node, &block
		end
		
		def action node = Node.default, &block
			ActionResult.new self, node, &block
		end
		
		def validate validators
			ValidateResult.new self, validators
		end
		
		def set *vars
			SetVar.new self, *vars
		end
		
		def tag_result name
			ResultTag.new self, name
		end
		
		def tag_error name
			ErrorTag.new self, name
		end
		
		private
		def parse! stream, options = {}
			raise NotImplementedError, "#{self.class} does not have an implemented #parse!" if self.to_parseable == self
			self.to_parseable.parse stream, options
		end
	end
end