require 'rspec'
require 'kaiseki'
include Kaiseki

describe Grammar do
	describe 'before initialize' do
		it '#subclass should return a subclass' do
			Grammar.subclass.superclass.should == Grammar
		end
		
		it 'should not be able to be bound' do
			lambda { Grammar.bind }.should raise_error StandardError
		end
	end
	
	describe 'on initialize' do
		before :all do
			@grammar = Grammar.new
		end
		
		it 'should have the correct hashes' do
			@grammar.rules.should be_a Hash
			@grammar.overrides.should be_a Hash
			@grammar.nodes.should be_a Hash
			@grammar.actions.should be_a Hash
		end
		
		it 'should raise errors when reading non-existant hash keys' do
			lambda { @grammar.rules[:foobar] }.should raise_error NameError
			lambda { @grammar.overrides[:foobar] }.should raise_error NameError
			lambda { @grammar.nodes[:foobar] }.should raise_error NameError
			lambda { @grammar.actions[:foobar] }.should raise_error NameError
		end
		
		it 'should have nil defaults' do
			@grammar.starting_rule.should be_nil
			@grammar.skipping_rule.should be_nil
		end
	end
	
	describe 'when being built' do
		before :all do
			@grammar = Grammar.new do
				starting :document
				skipping /\s+/
				
				rule :document do
					parse /\d/.one_or_more & :EOF
					override :skipping => nil
					node :params => [:numbers]
					action { @numbers.collect {|n| n.to_i } }
				end
			end
		end
		
		it 'should have `:document\' in the right hashes' do
			@grammar.rules.should have_key :document
			@grammar.overrides.should have_key :document
			@grammar.nodes.should have_key :document
			@grammar.actions.should have_key :document
		end
		
		it 'should have the right starting rule' do
			@grammar.starting_rule.should == SymbolParslet.new(:document)
		end
		
		it 'should have the right skipping_rule' do
			@grammar.skipping_rule.should == RegexpParslet.new(/\s+/)
		end
	end
end