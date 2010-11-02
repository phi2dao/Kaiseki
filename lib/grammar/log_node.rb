module Kaiseki
	class LogNode
		attr_accessor :result
		attr_reader :parslet, :children
		
		def initialize parslet
			@parslet = parslet
			@children = []
			@result = nil
		end
		
		def add node
			@children << node
		end
		
		def print indent = 0
			puts " " * indent + "in #{@parslet} got #{@result}"
			@children.each {|n| n.print indent + 2 }
		end
	end
end