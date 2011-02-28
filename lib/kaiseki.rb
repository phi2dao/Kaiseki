module Kaiseki
	VERSION = '1.2.1'
	file_path = File.dirname __FILE__
	
	#load basic kaiseki classes
	require file_path + '/stream'
	require file_path + '/parseable'
	require file_path + '/parse_error'
	require file_path + '/parse_result'
	
	#load standard class modifiers
	require file_path + '/mod_object'
	require file_path + '/mod_string'
	require file_path + '/mod_regexp'
	require file_path + '/mod_symbol'
	require file_path + '/mod_proc'
	require file_path + '/mod_file'
	require file_path + '/mod_kernel'
	
	#load parsers
	require file_path + '/parser_basic'
	require file_path + '/parser_string'
	require file_path + '/parser_regexp'
	require file_path + '/parser_symbol'
	require file_path + '/parser_eof'
	
	require file_path + '/parser_multi'
	require file_path + '/parser_sequence'
	require file_path + '/parser_choice'
	require file_path + '/parser_repeat'
	
	require file_path + '/parser_package'
	
	#load predicates
	require file_path + '/predicate_and'
	require file_path + '/predicate_not'
	require file_path + '/predicate_skip'
	
	#load result modifiers
	require file_path + '/result_override'
	require file_path + '/result_merge'
	require file_path + '/result_cast'
	require file_path + '/result_filter'
	require file_path + '/result_action'
	require file_path + '/result_validate'
	require file_path + '/node'
	
	#load grammar classes
	require file_path + '/grammar'
	require file_path + '/grammar_stub'
	require file_path + '/rule'
	require file_path + '/action'
	
	#load varible manipulators
	require file_path + '/var_set'
	require file_path + '/var_get'
	require file_path + '/var_insert'
	
	#load result tags
	require file_path + '/tag_basic'
	require file_path + '/tag_result'
	require file_path + '/tag_error'
	
	#load others
	require file_path + '/parser_custom'
end
