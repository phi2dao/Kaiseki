require 'kaiseki'

class Symbol
	include Kaiseki::ParsletCombining
	
	def to_parseable
		self == :EOF ? Kaiseki::EOFParslet.new : Kaiseki::SymbolParslet.new(self)
	end
	
	def to_instance_variable_name
		self[0] == '@' ? self : :"@#{self}"
	end
	
	def to_class_variable_name
		self[0..1] == '@@' ? self : :"@@#{self}"
	end
	
	def to_class_name
		self.to_s.split('_').collect {|n| n.capitalize }.join.to_sym
	end
end