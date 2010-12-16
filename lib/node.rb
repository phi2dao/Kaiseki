module Kaiseki
	class Node
		attr_reader :args, :source
		
		def initialize args = nil, source = nil
			@args = args
			@source = source
			# TODO load source
			if self.class.arg_names.respond_to? :each
				list = args.dup.reverse
				self.class.arg_names.each do |name|
					value = []
					(self.class.arity[name] || 1).times do
						if list.empty? and value.empty?
							if self.class.defaults[name]
								value << self.class.defaults[name]
								break
							else
								raise ArgumentError, "wrong number of arguments (#{value.length} for #{self.class.arity[name] || 1})"
							end
						elsif list.empty?
							raise ArgumentError, "wrong number of arguments (#{value.length} for #{self.class.arity[name] || 1})"
						else
							value << list.pop
						end
					end
					if value.length == 1
						instance_variable_set name.to_instance_variable, value[0]
					else
						instance_variable_set name.to_instance_variable, value
					end
				end
			else
				instance_variable_set self.class.arg_names.to_instance_variable, @args
			end
		end
		
		def eval &block
			value = instance_eval &block
			# TODO save souce
			value
		end
	end
	
	class << Node
		def bind args, options = {}
			raise "can't bind parent NodeClass" if self == Node
			define_singleton_method(:arg_names) { args }
			define_singleton_method(:arity) { options[:arity] || {} }
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