require './kaiseki'
include Kaiseki

SimpleGrammar = Grammar.subclass do
	starting :document
	skipping :ws
	simplify
	
	rule :ws do
		parse /\s+/
	end
	
	rule :document do
		parse :number >> :sec_number.zero_or_more >> :EOF
		action { @results.is_a?(Fixnum) ? [@results] : @results }
	end
	
	rule :sec_number do
		parse ','.skip & :number
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
	
	describe 'parse' do
		it 'should parse a matching string (I)' do
			result = @grammar.parse '1'
			result.result.should == [1]
		end
		
		it 'should parse a matching string (II)' do
			result = @grammar.parse '1, 2, 3, 4'
			result.result.should == [1, 2, 3, 4]
		end
		
		it 'should not parse a non-matching string' do
			result = @grammar.parse 'apple'
			result.should_not be_parsed
		end
		
		it 'should not parse a badly formed string' do
			result = @grammar.parse '1, 2,'
			result.should_not be_parsed
		end
	end
end