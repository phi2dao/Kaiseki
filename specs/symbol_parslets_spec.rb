require './kaiseki'
include Kaiseki

describe SymbolParslet do
	before :each do
		@parslet = SymbolParslet.new :example
	end
	
	describe 'parse' do
		it 'should raise an error if there is no rule passed' do
			lambda { @parslet.parse Stream.new('foobar') }.should raise_error ArgumentError
		end
	end
end