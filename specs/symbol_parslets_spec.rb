require './kaiseki'
include Kaiseki

describe SymbolParslet do
	before :each do
		@parslet = SymbolParslet.new :example
	end
	
	describe 'on initialize' do
		it 'should have the correct @symbol' do
			@parslet.symbol.should == :example
		end
		
		it 'should have the correct name' do
			@parslet.to_s.should == 'rule: example'
		end
	end
	
	describe 'parse' do
		it 'should raise an error if there is no rule passed' do
			lambda { @parslet.parse Stream.new('foobar') }.should raise_error ArgumentError
		end
	end
	
	describe 'to_parseable' do
		it 'should return self' do
			@parslet.to_parseable.should == @parslet
		end
	end
	
	describe 'eql?' do
		it 'should match a matching parslet' do
			@parslet.should == SymbolParslet.new(:example)
		end
		
		it 'should not match a non-matching parslet' do
			@parslet.should_not == SymbolParslet.new(:bad_example)
			@parslet.should_not == :example
		end
	end
end