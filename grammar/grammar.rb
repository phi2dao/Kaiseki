require 'kaiseki'

module Kaiseki
	class Grammar
		attr_reader :starting_rule, :skipping_rule, :rules, :overrides, :nodes, :actions
		
		def initialize &block
			@starting_rule = nil
			@skipping_rule = nil
			
			@rules = Hash.new {|hash, key| raise NameError, "rule `#{key}' is not defined" }
			@overrides = Hash.new {|hash, key| raise NameError, "override `#{key}' is not defined" }
			@nodes = Hash.new {|hash, key| raise NameError, "node `#{key}' is not defined" }
			@actions = Hash.new {|hash, key| raise NameError, "action `#{key}' is not defined" }
			
			@simplify = false
			
			instance_eval &block if block_given?
		end
		
		def starting parseable
			raise StandardError, "starting rule already defined" if @starting_rule
			@starting_rule = parseable.to_parseable
		end
		
		def skipping parseable
			raise StandardError, "skipping rule already defined" if @skipping_rule
			@skipping_rule = parseable.to_parseable
		end
		
		def rule symbol, &block
			raise TypeError, "can't convert #{symbol.class} into Symbol" unless symbol.is_a? Symbol
			raise StandardError, "rule `#{symbol}' already defined" if @rules.key? symbol
			GrammarNode.new(symbol, self).instance_eval(&block) if block_given?
			@rules[symbol] = ProcParslet.new { raise NotImplementedError, "rule `#{symbol}' not yet implemented" } unless @rules.key? symbol
		end
		
		def simplify
			@simplify = true
		end
		
		def parse! source, options = {}
			raise StandardError, "starting rule not defined" unless @starting_rule
			stream = source.is_a?(Stream) ? source : Stream.new(source)
			options[:grammar] = self
			options[:file] = stream.file
			options[:rule] = @starting_rule.is_a?(SymbolParslet) ? @starting_rule.expected : :root
			options[:skipping] = @skipping_rule
			options[:simplify] = @simplify
			@starting_rule.parse stream, options
		end
		
		def parse source, options = {}
			stream = source.is_a?(Stream) ? source : Stream.new(source)
			result = ParseResult.new self, stream, options
			result.logger = ParseLogger.new
			begin
				result.result = parse! stream, options.merge(:logger => result.logger)
			rescue ParseError => e
				result.error = e
			end
			result
		end
		
		def wrap stream, options = {}
			raise TypeError, "can't convert #{stream.class} into Stream" unless stream.is_a? Stream
			raise ArgumentError, "wrapping requires a rule" unless options.key? :rule
			rule = options[:rule]
			options.merge! @overrides[rule] if @overrides.key? rule
			result = @rules[rule].parse stream, options
			if @nodes.key?(rule) and @actions.key?(rule)
				node_class = @nodes[rule]
				if node_class.arity == 1
					node = node_class.new result
				else
					node = node_class.new *result
				end
				node.instance_eval &@actions[rule]
			else
				result
			end
		end
	end
	
	class << Grammar
		def subclass &block
			if block_given?
				subclass = Class.new self
				subclass.bind &block
				subclass
			else
				Class.new self
			end
		end
		
		def bind &block
			if self == Grammar
				raise StandardError, "Grammar rootclass can't be bound"
			elsif bound?
				raise StandardError, "Grammar can't be bound multiple times"
			else
				self.send :define_method, :initialize do
					super &block
				end
				self.define_singleton_method :bound? do
					true
				end
			end
			true
		end
		
		def bound?
			false
		end
	end
end