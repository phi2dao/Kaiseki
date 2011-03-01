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
			error = nil
			@expected.each do |n|
				begin
					catch :SkipSuccess do
						return n.parse stream, options
					end
				rescue ParseError => error
					next
				rescue NotImplementedError => error
					next
				end
			end
			raise ParseError.new "no valid alternatives when parsing #{self}", options[:rule], error
		end
	end
end