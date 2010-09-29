$: << '.'

module Kaiseki
	autoload :ArrayResult,			'grammar/array_result'
	autoload :ParseError,			'grammar/parse_error'
	autoload :Parslet,				'grammar/parslet'
	autoload :ParsletChoice,		'grammar/parslet_choice'
	autoload :ParsletCombination,	'grammar/parslet_combination'
	autoload :ParsletMerger,		'grammar/parslet_merger'
	autoload :ParsletRepetition,	'grammar/parslet_repetition'
	autoload :ParsletSequence,		'grammar/parslet_sequence'
	autoload :ProcParslet,			'grammar/proc_parslet'
	autoload :RegexpParslet,		'grammar/regexp_parslet'
	autoload :Stream,				'grammar/stream'
	autoload :StringParslet,		'grammar/string_parslet'
	autoload :StringResult,			'grammar/string_result'
end