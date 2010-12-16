require 'readline'
require './lib/kaiseki'

grammar = Kaiseki::Grammar.new do
	starting :document
	skipping /\s+/
	simplify
	
	rule :document do
		parses :expression & :EOF
	end
	
	rule :expression do
		parses :expression2 & :add_atom.zero_or_more
		node [:core, :adds]
		filter do
			@adds.each do |n|
				case n[0]
				when '+'
					@core += n[1]
				when '-'
					@core -= n[1]
				end
			end
			@core
		end
	end
	
	rule :add_atom do
		parses ('+' | '-') & :expression2
	end
	
	rule :expression2 do
		parses :atom & :mult_atom.zero_or_more
		node [:core, :mults]
		filter do
			@mults.each do |n|
				case n[0]
				when '*'
					@core *= n[1]
				when '/'
					@core /= n[1]
				end
			end
			@core
		end
	end
	
	rule :mult_atom do
		parses ('*' | '/') & :atom
	end
	
	rule :atom do
		parses :paranthetical | :die_roll | :FLOAT | :INT
	end
	
	rule :paranthetical do
		parses '('.skip & :expression & ')'.skip
	end
	
	rule :die_roll do
		parses :INT & 'd'.skip & :INT.optional
		node [:num, :sides]
		filter do
			total = 0
			@num.to_i.times { total += rand((@sides || 6).to_i) + 1 }
			total
		end
	end
	
	rule :INT do
		parses /\d+/
		cast Integer
	end
	
	rule :FLOAT do
		parses /\d*\.\d+/
		cast Float
	end
end

while line = Readline.readline('> ', true).chomp
	exit if line == 'quit'
	result = grammar.parse line
	if result.has_errors?
		puts result.error.verbose
	else
		puts result.result
	end
end