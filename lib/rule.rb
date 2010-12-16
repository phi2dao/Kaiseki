module Kaiseki
	class Rule
		attr_reader :parseable
		
		def initialize name, grammar, &block
			@name = name
			@grammar = grammar
			@parseable = nil
			
			instance_eval &block if block_given?
		end
		
		def parses parseable
			if @parseable
				raise "parseable for rule #{@name.inspect} already given"
			else
				@parseable = parseable.to_parseable
			end
		end
		
		def override options
			if @parseable
				@parseable = @parseable.override options
			else
				raise "parseable for rule #{@name.inspect} not yet given"
			end
		end
		
		def skipping parseable
			if @parseable
				@parseable = @parseable.override :skipping => parseable.to_parseable
			else
				raise "parseable for rule #{@name.inspect} not yet given"
			end
		end
		
		def simplify bool = true
			if @parseable
				@parseable = @parseable.override :simplify => bool
			else
				raise "parseable for rule #{@name.inspect} not yet given"
			end
		end
		
		def merge
			if @parseable
				@parseable = @parseable.merge
			else
				raise "parseable for rule #{@name.inspect} not yet given"
			end
		end
		
		def cast to_class
			if @parseable
				@parseable = @parseable.cast to_class
			else
				raise "parseable for rule #{@name.inspect} not yet given"
			end
		end
		
		def filter node = @name, &block
			if @parseable
				@grammar.nodes[@name] = Class.new(Node).bind(:result) unless @grammar.nodes.key? @name
				@parseable = @parseable.filter node, &block
			else
				raise "parseable for rule #{@name.inspect} not yet given"
			end
		end
		
		def node args, options = {}
			if @grammar.nodes.key? @name
				raise "node #{@name.inspect} already defined"
			else
				parent = options[:class] || Node
				@grammar.nodes[@name] = Class.new(parent).bind(args, options)
			end
		end
	end
end