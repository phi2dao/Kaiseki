class Object
	def must_be item
		raise TypeError, "can't convert #{self.class} into #{item}" unless self.is_a? item
		true
	end
end