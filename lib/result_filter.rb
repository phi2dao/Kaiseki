module Kaiseki
	class FilterResult < PackageParser
		attr_reader :node, :block
		
		def initialize expected, node = Node.default, &block
			super expected
			@node = node
			@block = block
		end
		
		def eql? other
			other.is_a?(self.class) and other.expected == @expected and other.block == @block
		end
		
		alias :== :eql?
		
		private
		def parse! stream, options = {}
			if @node.is_a? Class
				node_class = @node
			else
				if options[:grammar]
					node_class = options[:grammar].nodes[@node]
				else
					raise "can't use named nodes without a grammar"
				end
			end
			result = @expected.parse stream, options
			if result.is_a? Array
				node = node_class.new result, options[:global]
			else
				node = node_class.new [result]
			end
			node.eval options[:global], &@block
		end
	end
end