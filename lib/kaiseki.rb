require 'pathname'

DIR_PATH = Pathname.new(__FILE__).realpath.dirname

module Kaiseki
	VERSION = '0.0.0'
	
	grammar = %w[
		parslet_combining
		parslet_logging
		location_tracking
		parse_error
		parse_result
		string_result
		array_result
		
		stream
		parslet
		proc_parslet
		regexp_parslet
		string_parslet
		symbol_parslet
		eof_parslet
		
		parslet_combination
		parslet_sequence
		parslet_merger
		parslet_choice
		parslet_repetition
		
		predicate
		and_predicate
		not_predicate
		parslet_omission
		
		grammar
		parse_logger
		node
		grammar_node
		log_node
	]
	
	grammar.each do |path|
		require DIR_PATH + 'grammar' + path
	end
end

additions = %w[
	proc
	regexp
	string
	symbol
]

additions.each do |path|
	require DIR_PATH + 'additions' + path
end