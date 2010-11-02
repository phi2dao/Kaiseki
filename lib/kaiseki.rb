require 'pathname'

module Kaiseki
	VERSION = '0.0.1'
end

DIR_PATH = Pathname.new(__FILE__).realpath.dirname

[
	'grammar/parslet_combining',
	'grammar/parslet_logging',
	'grammar/location_tracking',
	'grammar/parse_error',
	'grammar/parse_result',
	'grammar/string_result',
	'grammar/array_result',
	
	'grammar/stream',
	'grammar/parslet',
	'grammar/proc_parslet',
	'grammar/regexp_parslet',
	'grammar/string_parslet',
	'grammar/symbol_parslet',
	'grammar/eof_parslet',
	
	'grammar/parslet_combination',
	'grammar/parslet_sequence',
	'grammar/parslet_merger',
	'grammar/parslet_choice',
	'grammar/parslet_repetition',
	
	'grammar/predicate',
	'grammar/and_predicate',
	'grammar/not_predicate',
	'grammar/parslet_omission',
	
	'grammar/grammar',
	'grammar/parse_logger',
	'grammar/node',
	'grammar/grammar_node',
	'grammar/log_node',
	
	'additions/proc',
	'additions/regexp',
	'additions/string',
	'additions/symbol',
].each do |path|
	require DIR_PATH + path
end