require 'rspec'
require 'kaiseki'
include Kaiseki

describe ParsletCombining do
	before :each do
		@numbers = Stream.new '123456'
		@letters = Stream.new 'abcdef'
	end
	
	describe 'sequence' do
		parslet = '123'.sequence '456'
		
		it 'should match a matching string' do
			parslet.parse(@numbers).should == ['123', '456']
		end
		
		it 'should not match a non-matcihng string' do
			lambda { parslet.parse @letters }.should raise_error ParseError
		end
	end
	
	describe 'merge' do
		parslet = '12'.sequence('34').merge('56')
		
		it 'should match a matching string' do
			parslet.parse(@numbers).should == ['12', '34', '56']
		end
		
		it 'should not match a non-matching string' do
			lambda { parslet.parse @letters }.should raise_error ParseError
		end
	end
	
	describe 'choose' do
		parslet = /[a-z]+/.choose /\d+/
		
		it 'should match a matching string' do
			parslet.parse(@numbers).should == '123456'
			parslet.parse(@letters).should == 'abcdef'
		end
		
		it 'should not match a non-matching string' do
			stream = Stream.new '___'
			lambda { parslet.parse stream }.should raise_error ParseError
		end
	end
	
	describe 'repeat' do
		it 'should match a matching string' do
			parslet = /[a-z]/.repeat 1, 2
			parslet.parse(@letters).should == ['a', 'b']
		end
		
		it 'should not match a non-matcihng string' do
			parslet = /[a-z]/.repeat 1, 2
			lambda { parslet.parse @numbers }.should raise_error ParseError
		end
		
		it 'should match when +optional+' do
			parslet = /[a-z]/.optional
			parslet.parse(@numbers).should == []
			parslet.parse(@letters).should == ['a']
		end
		
		it 'should match when +zero_or_more+' do
			parslet = /[a-z]/.zero_or_more
			parslet.parse(@numbers).should == []
			parslet.parse(@letters).should == %w[a b c d e f]
		end
		
		it 'should match when +one_or_more+' do
			parslet = /[a-z]/.one_or_more
			parslet.parse(@letters).should == %w[a b c d e f]
		end
	end
	
	describe 'and_predicate' do
		parslet = 'a'.sequence 'b'.and_predicate
		
		it 'should match a matching string' do
			parslet.parse(@letters).should == ['a']
		end
		
		it 'should not match a non-matching string' do
			stream = Stream.new '1b'
			lambda { parslet.parse stream }.should raise_error ParseError
		end
	end
	
	describe 'not_predicate' do
		parslet = '1'.sequence '1'.not_predicate
		
		it 'should match a matching string' do
			parslet.parse(@numbers).should == ['1']
		end
		
		it 'should not match a non-matching string' do
			stream = Stream.new '11'
			lambda { parslet.parse stream }.should raise_error ParseError
		end
	end
	
	describe 'omission' do
		parslet = 'a'.sequence('b'.omission).sequence('c')
		
		it 'should match a matching string' do
			parslet.parse(@letters).should == [['a'], 'c']
		end
		
		it 'should not match a non-matching string' do
			stream = Stream.new 'a2c'
			lambda { parslet.parse stream }.should raise_error ParseError
		end
	end
end