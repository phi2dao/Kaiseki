module Kaiseki
	class ChoiceParser < MultiParser
		alias :| :append
		
		def predicate?
			@expected.find {|n| n.predicate? } ? true : false
		end
		
		def delimiter
			'|'
		end
		
		private
		def parse! stream, options = {}
			error = true
			@expected.each do |n|
				begin
					catch :SkipSuccess do
						return n.parse stream, options
					end
				rescue ParseError
					next
				rescue NotImplementedError
					next
				end
			end
			raise ParseError.new "no valid alternatives when parsing #{self}", options
		end
	end
end