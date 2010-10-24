require 'kaiseki'

module Kaiseki
	module ParsletLogging
		def log parse_logger = nil, &block
			if parse_logger
				node = LogNode.new self
				parse_logger.root ? parse_logger.add(node) : parse_logger.root = node
				parse_logger.push node
				begin
					node.result = block.call
					parse_logger.pop
					node.result
				rescue ParseError => e
					node.result = e
					parse_logger.pop
					raise e
				end
			else
				block.call
			end
		end
	end
end