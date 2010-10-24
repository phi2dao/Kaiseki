require './kaiseki'
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

SimpleGrammar = Grammar.subclass do
	starting :document
	skipping /\s+/
	simplify
	
	rule :document do
		parse :number >> :sec_num.zero_or_more >> :EOF
		action { @results.is_a?(Fixnum) ? [@results] : @results }
	end
	
	rule :sec_num do
		parse ','.skip & :number
		action { @results }
	end
	
	rule :number do
		parse /\d+/
		action { @results.to_i }
	end
end

describe SimpleGrammar do
	before :all do
		@grammar = SimpleGrammar.new
	end
	
	describe '#parse!' do
		it 'should parse a simple matching string' do
			stream = Stream.new '1'
			@grammar.parse!(stream).should == [1]
		end
		
		it 'should parse a complex matching string' do
			stream = Stream.new '1,2,3,4'
			@grammar.parse!(stream).should == [1, 2, 3, 4]
		end
		
		it 'should parse a matching string with whitespace' do
			stream = Stream.new '1, 2, 3, 4'
			@grammar.parse!(stream).should == [1, 2, 3, 4]
		end
		
		it 'should raise an error when parsing an non-matching string' do
			stream = Stream.new 'a-z'
			lambda { @grammar.parse! stream }.should raise_error ParseError
		end
		
		it 'should raise an error when parsing a badly formed string' do
			stream = Stream.new '1, 2,'
			lambda { @grammar.parse! stream }.should raise_error ParseError
		end
	end
	
	describe '#parse' do
		it 'should parse a matching string' do
			result = @grammar.parse Stream.new '1, 2, 3, 4'
			result.result.should == [1, 2, 3, 4]
		end
		
		it 'should not parse a non-matching string' do
			result = @grammar.parse Stream.new 'a-z'
			result.should_not be_success
		end
		
		it 'should know the grammar' do
			result = @grammar.parse Stream.new '1'
			result.grammar.should == @grammar
		end
		
		it 'should know the stream' do
			stream = Stream.new '1, 2, 3'
			result = @grammar.parse stream
			result.stream.should == stream
		end
	end
end

PackageGrammar = Grammar.subclass do
	starting :package & :EOF
	skipping /\s+/
	
	rule :package do
		parse :curved_box | :straight_box | :curly_box
	end
	
	rule :curved_box do
		parse '(' & :contents & ')'
	end
	
	rule :straight_box do
		parse '[' & :contents & ']'
	end
	
	rule :curly_box do
		parse '{' & :contents & '}'
	end
	
	rule :contents do
		parse /[a-z]/i | :package.one_or_more
	end
end

describe PackageGrammar do
	before :all do
		@grammar = PackageGrammar.new
	end
	
	describe 'when parsed' do
		it 'should parse a single package' do
			@grammar.parse('(a)').should be_success
		end
		
		it 'should parse a package in a package' do
			@grammar.parse('([a])').should be_success
		end
		
		it 'should parse multiple packages in a package' do
			@grammar.parse('([a]{b})').should be_success
		end
		
		it 'should not parse a bare item' do
			@grammar.parse('a').should_not be_success
		end
		
		it 'should not parse a bare item and a package' do
			@grammar.parse('a[b]').should_not be_success
		end
		
		it 'should not parse a bare item and a package in a package' do
			@grammar.parse('(a[b])').should_not be_success
		end
	end
end