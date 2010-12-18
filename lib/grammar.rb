module Kaiseki
	class Grammar
		attr_reader :rules, :nodes
		attr_accessor :starting_rule, :skipping_rule, :simplify
		
		def initialize &block
			@rules = Hash.new {|hash, key| raise "rule #{key.inspect} undefined" }
			@nodes = Hash.new {|hash, key| raise "node #{key.inspect} undefined" }
			@starting_rule = nil
			@skipping_rule = nil
			@simplify = true
			
			instance_eval &block if block_given?
		end
		
		def parse stream, options = {}
			ParseResult.new do
				parse! stream.to_stream, options
			end
		end
		
		def parse! stream, options = {}
			stream.must_be Stream
			stream.lock do
				default_options = {
					:grammar => self,
					:rule => 'main',
					:skipping => @skipping_rule,
					:simplify => @simplify,
				}
				if @starting_rule
					@starting_rule.parse stream, default_options.merge(options)
				else
					raise "starting rule undefined"
				end
			end
		end
		
		def starting parseable
			raise "starting rule already defined" if @starting_rule
			@starting_rule = parseable
		end
		
		def skipping parseable
			raise "skipping rule already defined" if @skipping_rule
			@skipping_rule = parseable
		end
		
		def simplify bool = true
			@simplify = bool
		end
		
		def rule name, parseable = nil, &block
			if @rules.key? name
				raise "rule #{name.inspect} already defined"
			else
				if parseable and block_given?
					raise ArgumentError, "wrong number of arguments; the second argument is mutually exclusive with a block"
				elsif parseable
					@rules[name] = parseable.to_parseable
				elsif block_given?
					@rules[name] = Rule.new(name, self, &block).parseable
				else
					@rules[name] = nil
				end
			end
		end
		
		def action name, &block
			if @rules.key? name
				raise "rule #{name.inspect} already defined"
			else
				@rules[name] = block.to_parseable
			end
		end
		
		def node name, args, options = {}
			args.must_be Array
			if @nodes.key? name
				raise "node #{name.inspect} already defined"
			else
				parent = options[:class] || Node
				@nodes[name] = parent.subclass args, options
			end
		end
	end
end