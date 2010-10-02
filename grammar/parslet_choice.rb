require 'kaiseki'

module Kaiseki
	class ParsletChoice < ParsletCombination
		def initialize *components
			super *components
			@delimiter = '|'
		end
		
		alias :| :append
		
		def parse stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			parsed = ArrayResult.new
			error = nil
			@components.each do |parseable|
				begin
					return parseable.parse stream, options
				rescue ParseError => e
					error = e
				end
			end
			raise ParseError.new "no valid alternatives (#{error.string})",
					:line_end => stream.line, :columm_end => stream.column, :rule => options[:rule]
		end
	end
end