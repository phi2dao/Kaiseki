module Kaiseki
	class ActionResult < FilterResult
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
			result
		end
	end
end