require 'kaiseki'

module Kaiseki
	class ParseResult
		attr_accessor :result, :error
		attr_reader :grammar, :stream, :options
		
		def initialize grammar, stream, options
			@grammar = grammar
			@stream = stream
			@options = options
			
			@result = nil
			@error = nil
			
			@first = nil
			@stack = []
		end
		
		def parsed?
			!@error
		end
		
		def log parslet, &block
			log_item = LogItem.new parslet
			if @first
				@stack.last.add log_item
			else
				@first = log_item
			end
			@stack.push log_item
			begin
				log_item.result = block.call
				@stack.pop
				log_item.result
			rescue ParseError => e
				log_item.result = e
				@stack.pop
				raise e
			end
		end
		
		def backtrace
			@first.print
			true
		end
	end
	
	class LogItem
		attr_accessor :result
		attr_reader :parslet, :children
		
		def initialize parslet
			@parslet = parslet
			@result = nil
			@children = []
		end
		
		def add item
			raise TypeError, "can't convert #{item.class} into LogItem" unless item.is_a? LogItem
			@children.push item
		end
		
		def print indent_level = 0
			puts " " * indent_level + "in #{@parslet} got `#{@result}'"
			@children.each {|n| n.print indent_level + 2 }
		end
	end
end