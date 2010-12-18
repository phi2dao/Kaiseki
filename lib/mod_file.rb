class File
	def to_stream
		Kaiseki::Stream.new self
	end
end