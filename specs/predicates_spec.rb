require './kaiseki'
include Kaiseki

describe Predicate do
	before :each do
		@predicate = Predicate.new Parslet.new :foo
	end
	
	describe 'on initialize' do
		it 'should have the correct @parseable' do
			@predicate.parseable.should == Parslet.new(:foo)
		end
		
		it 'should have the correct name' do
			@predicate.to_s.should == 'predicate:foo'
		end
	end
	
	describe 'parse' do
		it 'should raise a NotImplementedError' do
			lambda { @predicate.parse }.should raise_error NotImplementedError
		end
	end
	
	describe 'to_parseable' do
		it 'should return self' do
			@predicate.to_parseable.should == @predicate
		end
	end
	
	describe 'eql?' do
		it 'should match a matching object' do
			@predicate.should == Predicate.new(Parslet.new(:foo))
		end
		
		it 'should not match a non-matching object' do
			@predicate.should_not == Predicate.new(Parslet.new(:bar))
		end
	end
end

describe AndPredicate do
	before :each do
		@predicate = AndPredicate.new StringParslet.new '?'
		@parslet = ParsletSequence.new RegexpParslet.new(/[a-z]/), @predicate
	end
	
	describe 'parse' do
		it 'should parse a complete match' do
			stream = Stream.new 'a?'
			@parslet.parse(stream).should == ['a']
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'aa'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
		
		it 'should not function on its own' do
			stream = Stream.new '?'
			lambda { @predicate.parse stream }.should raise_error ArgumentError
		end
	end
end

describe NotPredicate do
	before :each do
		@predicate = NotPredicate.new StringParslet.new '?'
		@parslet = ParsletSequence.new RegexpParslet.new(/[a-z]/), @predicate
	end
	
	describe 'parse' do
		it 'should parse a complete match' do
			stream = Stream.new 'aa'
			@parslet.parse(stream).should == ['a']
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'a?'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
		
		it 'should not function on its own' do
			stream = Stream.new 'a'
			lambda { @predicate.parse stream }.should raise_error ArgumentError
		end
	end
end

describe ParsletOmission do
	before :each do
		@predicate = ParsletOmission.new StringParslet.new '?'
		@parslet = ParsletSequence.new RegexpParslet.new(/[a-z]/), @predicate, EOFParslet.new
	end
	
	describe 'parse' do
		it 'should parse a complete match' do
			stream = Stream.new 'a?'
			@parslet.parse(stream).should == ['a']
		end
		
		it 'should not parse an incorrect match' do
			stream = Stream.new 'aa'
			lambda { @parslet.parse stream }.should raise_error ParseError
		end
		
		it 'should not function on its own' do
			stream = Stream.new '?'
			lambda { @predicate.parse stream }.should raise_error ArgumentError
		end
	end
end