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
		it 'should return self' do
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

describe ParsletCombination do
	before :each do
		@parslet = ParsletCombination.new Parslet.new(:foo), Parslet.new(:bar)
	end
	
	describe 'on initialize' do
		it 'should have the correct parslets' do
			@parslet.components.should == [Parslet.new(:foo), Parslet.new(:bar)]
		end
		
		it 'should have the correct name' do
			@parslet.to_s.should == 'foo -- bar'
		end
	end
	
	describe 'append' do
		it 'should append a parslet to @parslets' do
			@parslet.append Parslet.new(:foobar)
			@parslet.to_s.should == 'foo -- bar -- foobar'
		end
	end
	
	describe 'parse' do
		it 'should raise a NotImplementedError' do
			lambda { @parslet.parse}.should raise_error NotImplementedError
		end
	end
	
	describe 'to_parseable' do
		it 'should return self' do
			@parslet.to_parseable.should == @parslet
		end
	end
	
	describe 'eql?' do
		it 'should match a matching object' do
			@parslet.should == ParsletCombination.new(Parslet.new(:foo), Parslet.new(:bar))
		end
		
		it 'should not match a non-matching object' do
			@parslet.should_not == ParsletCombination.new(Parslet.new(:foo))
		end
	end
end

describe ParsletSequence do
	before :each do
		@parslet = ParsletSequence.new RegexpParslet.new(/\d/), RegexpParslet.new(/\d/), RegexpParslet.new(/\d/)
		@skipping = RegexpParslet.new /\s+/
	end
	
	describe 'parse' do
		it 'should parse a match' do
			stream = Stream.new '123'
			@parslet.parse(stream).should == %w[1 2 3]
		end
		
		it 'should parse a match with skipping' do
			stream = Stream.new '1 2 3'
			@parslet.parse(stream, :skipping => @skipping).should == %w[1 2 3]
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'foobar'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
		
		it 'should not parse an incomplete match' do
			stream = Stream.new '12'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
	end
end

describe ParsletMerger do
	before :each do
		p1 = ParsletSequence.new RegexpParslet.new(/\d/), RegexpParslet.new(/\d/)
		@parslet = ParsletMerger.new p1, RegexpParslet.new(/[a-z]/)
		@skipping = RegexpParslet.new /\s+/
	end
	
	describe 'parse' do
		it 'should parse a match' do
			stream = Stream.new '12a'
			@parslet.parse(stream).should == %w[1 2 a]
		end
		
		it 'should parse a match with skipping' do
			stream = Stream.new '1 2 a'
			@parslet.parse(stream, :skipping => @skipping).should == %w[1 2 a]
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'foobar'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
		
		it 'should not parse an incomplete match' do
			stream = Stream.new '12'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
	end
end

describe ParsletChoice do
	before :each do
		@parslet = ParsletChoice.new RegexpParslet.new(/\d/), RegexpParslet.new(/[a-z]/)
	end
	
	describe 'parse' do
		it 'should parse the first matching' do
			stream = Stream.new '1'
			@parslet.parse(stream).should == '1'
		end
		
		it 'should parse the second matching' do
			stream = Stream.new 'a'
			@parslet.parse(stream).should == 'a'
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new '$'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
	end
end

describe ParsletRepetition do
	before :each do
		@parslet = ParsletRepetition.new Parslet.new(:foo), 0, 1
		@stream = Stream.new '123456789'
	end
	
	describe 'on initialize' do
		it 'should have the correct parslets' do
			@parslet.expected.should == Parslet.new(:foo)
		end
		
		it 'should have the correct name' do
			@parslet.to_s.should == 'repeat(0, 1): foo'
		end
	end
	
	describe 'parse' do
		it 'should match the maximum' do
			parslet = ParsletRepetition.new RegexpParslet.new(/\d/), 0, 5
			parslet.parse(@stream).should == %w[1 2 3 4 5]
		end
		
		it 'should match the minimum' do
			parslet = ParsletRepetition.new RegexpParslet.new(/[a-z]/), 0, 5
			parslet.parse(@stream).should == []
		end
		
		it 'should not match a bad minimum' do
			parslet = ParsletRepetition.new RegexpParslet.new(/\d/), 20, 20
			lambda { parslet.parse @stream }.should raise_error ParseError
		end
	end
	
	describe 'to_parseable' do
		it 'should return self' do
			@parslet.to_parseable.should == @parslet
		end
	end
	
	describe 'eql?' do
		it 'should match a matching object' do
			@parslet.should == ParsletRepetition.new(Parslet.new(:foo), 0, 1)
		end
		
		it 'should not match the wrong parslet' do
			@parslet.should_not == ParsletRepetition.new(Parslet.new(:bar), 0, 1)
		end
		
		it 'should not match the wrong minimum' do
			@parslet.should_not == ParsletRepetition.new(Parslet.new(:foo), 1, 1)
		end
		
		it 'should not match the wrong maximum' do
			@parslet.should_not == ParsletRepetition.new(Parslet.new(:foo), 0)
		end
	end
end