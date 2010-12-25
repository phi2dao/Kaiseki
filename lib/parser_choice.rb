module Kaiseki
	class ChoiceParser < MultiParser
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
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
		
		alias :| :append
		
		def delimiter
			'|'
		end
	end
end