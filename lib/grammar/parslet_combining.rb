module Kaiseki
	module ParsletCombining
		def sequence other
			ParsletSequence.new self.to_parseable, other.to_parseable
		end
		
		alias :& :sequence
		
		def merge other
			ParsletMerger.new self.to_parseable, other.to_parseable
		end
		
		alias :>> :merge
		
		def choose other
			ParsletChoice.new self.to_parseable, other.to_parseable
		end
		
		alias :| :choose
		
		def repeat min, max = nil
			ParsletRepetition.new self.to_parseable, min, max
		end
		
		def optional
			repeat 0, 1
		end
		
		alias :zero_or_one :optional
		
		def zero_or_more
			repeat 0
		end
		
		def one_or_more
			repeat 1
		end
		
		def and_predicate
			AndPredicate.new self.to_parseable
		end
		
		alias :and? :and_predicate
		
		def not_predicate
			NotPredicate.new self.to_parseable
		end
		
		alias :not! :not_predicate
		
		def omission
			ParsletOmission.new self.to_parseable
		end
		
		alias :skip :omission
	end
end