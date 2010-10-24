require 'kaiseki'

module Kaiseki
	class ParseLogger
		attr_accessor :root
		attr_reader :stack
		
		def initialize
			@root = nil
			@stack = []
		end
		
		def push item
			@stack.push item
		end
		
		def pop
			@stack.pop
		end
		
		def add item
			@stack.last.add item
		end
		
		def backtrace
			@root.print
		end
	end
end