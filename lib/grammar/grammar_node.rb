module Kaiseki
	class GrammarNode < Node
		def parse parseable
			raise StandardError, "rule `#{@name}' already defined" if @grammar.rules.key? @name
			@grammar.rules[@name] = parseable.to_parseable
		end
		
		def override options
			raise StandardError, "rule `#{@name}' not defined" unless @grammar.rules.key? @name
			raise StandardError, "override already deinfed for rule `#{@name}'" if @grammar.overrides.key? @name
			@grammar.overrides[@name] = options
		end
		
		def node options = {:params => [:results]}
			superclass = options.key?(:superclass) ? options[:superclass] : Node
			raise TypeError, "can't convert #{superclass.class} into Class" unless superclass.is_a? Class
			raise StandardError, "rule `#{@name}' not defined" unless @grammar.rules.key? @name
			raise StandardError, "node already defined for rule `#{@name}'" if @grammar.nodes.key? @name
			node = @grammar.nodes[@name] = superclass.subclass(*options[:params])
		end
		
		def action &block
			raise StandardError, "rule `#{@name}' not defined" unless @grammar.rules.key? @name
			raise StandardError, "action already defined for rule `#{@name}'" if @grammar.actions.key? @name
			@grammar.nodes[@name] = node unless @grammar.nodes.key? @name
			@grammar.actions[@name] = block
		end
	end

	GrammarNode.bind :name, :grammar
end