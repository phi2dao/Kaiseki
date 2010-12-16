class Object
	def must_be item
		raise TypeError, "can't convert #{self.class} into #{item}" unless self.is_a? item
		true
	end
	
	def must_have property, value
		raise StandardError, "##{property} must be #{value} (#{self.send(property)})" unless self.send(property) == value
		true
	end
end