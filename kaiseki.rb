$: << '.'

module Kaiseki
	autoload :ParseError,		'grammar/parse_error'
	autoload :Parslet,			'grammar/parslet'
	autoload :ProcParslet,		'grammar/proc_parslet'
	autoload :RegexpParslet,	'grammar/regexp_parslet'
	autoload :Stream,			'grammar/stream'
	autoload :StringParslet,	'grammar/string_parslet'
	autoload :StringResult,		'grammar/string_result'
end