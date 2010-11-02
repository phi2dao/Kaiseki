module Kaiseki
	class Node
		
	end
	
	class << Node
		def subclass *parameters
			if parameters.empty?
				Class.new self
			else
				subclass = Class.new self
				subclass.bind *parameters
				subclass
			end
		end
		
		def bind *parameters
			if self == Node
				raise StandardError, "Node rootclass can't be bound"
			elsif bound?
				raise StandardError, "Node can't be bound multiple times"
			else
				self.send :define_method, :initialize do |*arguments|
					raise ArgumentError, "wrong number of arguments (#{arguments.length} for #{parameters.length})" unless arguments.length == parameters.length
					arguments.length.times do |i|
						instance_variable_set parameters[i].to_instance_variable_name, arguments[i]
					end
				end
				parameters.each do |parameter|
					self.send :define_method, parameter do
						instance_variable_get parameter.to_instance_variable_name
					end
				end
				self.define_singleton_method :arity do
					parameters.length
				end
				self.define_singleton_method :parameters do
					parameters.dup
				end
				self.define_singleton_method :bound? do
					true
				end
			end
			true
		end
		
		def arity
			0
		end
		
		def parameters
			[]
		end
		
		def bound?
			false
		end
	end
end