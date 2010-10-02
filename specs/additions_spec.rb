require './kaiseki'
include Kaiseki

describe String do
	describe 'to_parseable' do
		it 'should match an identical StringParslet' do
			'foobar'.to_parseable.should == StringParslet.new('foobar')
		end
	end
end

describe Regexp do
	describe 'to_parseable' do
		it 'should match an identical RegexpParslet' do
			/foobar/.to_parseable.should == RegexpParslet.new(/foobar/)
		end
	end
end

describe Proc do
	describe 'to_parseable' do
		it 'should match an identical ProcParslet' do
			proc_var = proc {|stream, options| puts options }
			proc_var.to_parseable.should == ProcParslet.new(proc_var)
		end
	end
end