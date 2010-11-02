require 'rspec'
require 'kaiseki'
include Kaiseki

describe Stream do
	before :each do
		@string = "Gouge the head and kill.\nGouge the chest and kill.\nGouge the belly and kill.\nGouge the knee and kill.\nGouge the leg and kill."
		@stream = Stream.new @string
	end
	
	describe 'on initialize' do
		it 'should match the original string' do
			@stream.to_s.should == @string
		end
		
		it 'should have the same length as the original string' do
			@stream.length.should == @string.length
		end
		
		it 'should be at position 0' do
			@stream.pos.should == 0
		end
		
		it 'should be at line 0' do
			@stream.line.should == 0
		end
		
		it 'should be at column 0' do
			@stream.column.should == 0
		end
	end
	
	describe 'getc' do
		it 'should return 1 char by default' do
			result = @stream.getc
			result.length.should == 1
			result.should match @string[0]
		end
		
		it 'should return as many chars as asked for' do
			1.upto 10 do |i|
				@stream = Stream.new @string
				result = @stream.getc i
				result.length.should == i
				result.should match @string[0..(i - 1)]
			end
		end
		
		it 'should understand -1' do
			result = @stream.getc -1
			result.length.should == @string.length
			result.should match @string
		end
		
		it 'should return nil at the end of the string' do
			@stream.getc -1
			@stream.getc.should == nil
		end
		
		it 'should update position' do
			@stream.getc
			@stream.pos.should == 1
		end
		
		it 'should update line#' do
			@stream.getc 25 # Number of chars in first line
			@stream.line.should == 1
		end
		
		it 'should update column#' do
			@stream.getc
			@stream.column.should == 1
		end
	end
	
	describe 'rewind' do
		it 'should rewind to position 0 by default' do
			@stream.rewind
			@stream.pos.should == 0
		end
		
		it 'should rewind to whatever position is asked for' do
			1.upto 10 do |i|
				@stream.rewind(i)
				@stream.pos.should == i
			end
		end
		
		it 'should understand -1' do
			@stream.rewind(-1)
			@stream.pos.should == @string.length
		end
		
		it 'should not rewind past the end of the string' do
			@stream.rewind(1000)
			@stream.pos.should == @string.length
		end
	end
end