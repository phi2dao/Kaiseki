require './kaiseki'
include Kaiseki

describe Parslet do
	before :each do
		@parslet = Parslet.new :example
	end
	
	describe 'on initialize' do
		it 'should have the correct @expected' do
			@parslet.expected.should == :example
		end
		
		it 'should have the correct name' do
			@parslet.to_s.should == 'example'
		end
	end
	
	describe 'parse' do
		it 'should raise a NotImplementedError' do
			lambda { @parslet.parse }.should raise_error NotImplementedError
		end
	end
	
	describe 'to_parseable' do
		it 'should return its self' do
			@parslet.to_parseable.should == @parslet
		end
	end
	
	describe 'eql?' do
		it 'should match a matching object' do
			@parslet.should == Parslet.new(:example)
		end
		
		it 'should not match a non-matching object'  do
			@parslet.should_not == Parslet.new(:bad_example)
			@parslet.should_not == :example
		end
	end
end

describe StringParslet do
	before :each do
		@parslet = StringParslet.new 'example'
	end
	
	describe 'parse' do
		it 'should parse a complete match' do
			stream = Stream.new 'example'
			@parslet.parse(stream).should == 'example'
		end
		
		it 'should parse a partial match' do
			stream = Stream.new 'example string'
			@parslet.parse(stream).should == 'example'
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'bad_example'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
	end
end

describe RegexpParslet do
	before :each do
		@parslet = RegexpParslet.new /[a-z]+ (\d+)/i
	end
	
	describe 'parse' do
		it 'should parse a match' do
			stream = Stream.new 'example 123'
			@parslet.parse(stream).should == 'example 123'
		end
		
		it 'should return captures' do
			stream = Stream.new 'example 123'
			@parslet.parse(stream).info[:captures].should == ['123']
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'bad example'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
	end
end

describe ProcParslet do
	describe 'parse' do
		it 'should send the stream' do
			parslet = ProcParslet.new proc {|stream, options| stream.to_s == 'example' }
			stream = Stream.new 'example'
			parslet.parse(stream).should == true
		end
		
		it 'should send the options' do
			parslet = ProcParslet.new proc {|stream, options| options[:example] == true }
			stream = Stream.new 'example'
			parslet.parse(stream, :example => true).should == true
		end
	end
end