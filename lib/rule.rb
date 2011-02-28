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
				raise "parseable for rule #{@name.inspect} already defined"
			else
				@parseable = parseable.to_parseable
			end
		end
		
		def custom is_predicate = false, &block
			if @parseable
				raise "parseable for rule #{@name.inspect} already defined"
			else
				@parseable = CustomParser.new is_predicate, &block
			end
		end
		
		def override options
			if @parseable
				@parseable = @parseable.override options
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def skipping parseable
			if @parseable
				raise "skipping rule must not be a predicate" if parseable.predicate?
				@parseable = @parseable.override :skipping => parseable.to_parseable
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def simplify bool = true
			if @parseable
				@parseable = @parseable.override :simplify => bool
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def merge
			if @parseable
				@parseable = @parseable.merge
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def cast to_class
			if @parseable
				@parseable = @parseable.cast to_class
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def validates validators
			if @parseable
				@parseable = @parseable.validate validators
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def set *vars
			if @parseable
				@parseable = @parseable.set *vars
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def tag_result name = @name
			if @parseable
				@parseable = @parseable.tag_result name
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def tag_error name = @name
			if @parseable
				@parseable = @parseable.tag_error name
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def filter node = @name, &block
			if @parseable
				unless @grammar.nodes.key? @name
					@grammar.nodes[@name] = Node.default
				end
				@parseable = @parseable.filter node, &block
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def action node = @name, &block
			if @parseable
				unless @grammar.nodes.key? @name
					@grammar.nodes[@name] = Node.default
				end
				@parseable = @parseable.action node, &block
			else
				raise "parseable for rule #{@name.inspect} undefined"
			end
		end
		
		def node args, options = {}
			args.must_be Array
			if @grammar.nodes.key? @name
				raise "node #{@name.inspect} already defined"
			else
				parent = options[:class] || Node
				@grammar.nodes[@name] = parent.subclass args, options
			end
		end
	end
end