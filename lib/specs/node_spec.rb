require 'rspec'
require 'kaiseki'
include Kaiseki

describe Node do
	describe 'before subclass' do
		it 'should have arity 0' do
			Node.arity.should == 0
		end
		
		it 'should have no parameters' do
			Node.parameters.should be_empty
		end
		
		it 'should not be bound' do
			Node.should_not be_bound
		end
		
		it 'should respond to #subclass' do
			Node.should respond_to :subclass
		end
		
		it '#subclass should return a subclass' do
			Node.subclass.superclass.should == Node
		end
		
		it 'should respond to #bind' do
			Node.should respond_to :bind
		end
		
		it 'should not be able to be bound' do
			lambda { Node.bind }.should raise_error StandardError
		end
	end
	
	describe 'after subclass' do
		before :each do
			@class = Node.subclass
		end
		
		it 'should have arity 0' do
			@class.arity.should == 0
		end
		
		it 'should have no parameters' do
			@class.parameters.should be_empty
		end
		
		it 'should not be bound' do
			@class.should_not be_bound
		end
		
		it 'should respond to #subclass' do
			@class.should respond_to :subclass
		end
		
		it 'should return a subclass' do
			@class.subclass.superclass.should == @class
		end
		
		it 'should respond to #bind' do
			@class.should respond_to :bind
		end
		
		it 'should be able to be bound' do
			lambda { @class.bind }.should_not raise_error StandardError
		end
	end
	
	describe 'after binding' do
		before :each do
			@class = Node.subclass :val1, :val2
		end
		
		it 'should have the correct arity' do
			@class.arity.should == 2
		end
		
		it 'should have the correct parameters' do
			@class.parameters.should == [:val1, :val2]
		end
		
		it 'should be bound' do
			@class.should be_bound
		end
		
		it 'should not be able to be bound' do
			lambda { @class.bind }.should raise_error StandardError
		end
	end
	
	describe 'after initialization' do
		before :each do
			@class = Node.subclass :val1, :val2
		end
		
		it 'should have to correct variables' do
			node = @class.new 1, 2
			node.val1.should == 1
			node.val2.should == 2
		end
		
		it 'should raise an error if it gets the wrong number of variables' do
			lambda { @class.new 1 }.should raise_error ArgumentError
			lambda { @class.new 1, 2, 3 }.should raise_error ArgumentError
		end
	end
end