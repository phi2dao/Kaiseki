module Kernel
	private
	
	def get var, parser
		Kaiseki::GetVar.new var, parser
	end
	
	def insert var
		Kaiseki::InsertVar.new var
	end
end