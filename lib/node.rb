module Kaiseki
	class Node
		def initialize args = [], global = nil
			args.must_be Array
			if global
				global.each_pair do |key, value|
					instance_variable_set key.to_instance_variable, value
				end
			end
			list = args.reverse
			self.class.arg_names.each do |name|
				value = []
				while 0 >= self.class.arity[name] or value.length < self.class.arity[name]
					if !list.empty?
						value << list.pop
					elsif value.empty? and self.class.defaults.key?(name)
						value << self.class.defaults[name]
						break
					else
						if self.class.arity[name] <= 0
							break
						else
							raise ArgumentError, "wrong number of arguments (#{value.length} for #{self.class.arity[name]})"
						end
					end
				end
				if self.class.arity[name] == 1
					value = value[0]
				elsif self.class.arity[name] == 0
					if value.length < 1
						value = nil
					elsif value.length == 1
						value = value[0]
					end
				end
				instance_variable_set name.to_instance_variable, value
			end
		end
		
		def eval global = nil, &block
			value = instance_eval &block
			if global
				(instance_variables.collect {|n| n.from_instance_variable } - self.class.arg_names).each do |n|
					global[n] = instance_variable_get n.to_instance_variable
				end
			end
			value
		end
	end
	
	class << Node
		def subclass args, options = {}
			args.must_be Array
			Class.new(self).bind args, options
		end
		
		def bind args, options = {}
			args.must_be Array
			raise "can't bind parent NodeClass" if self == Node
			define_singleton_method(:arg_names) { args }
			define_singleton_method(:arity) { Hash.new {|hash, key| 1 }.merge(options[:arity] || {}) }
			define_singleton_method(:defaults) { options[:defaults] || {} }
			self
		end
		
		def arg_names
			[]
		end
		
		def arity
			{}
		end
		
		def defaults
			{}
		end
	end
end