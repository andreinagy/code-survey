RUBY_LANGUAGE = {
  name: 'Ruby',
  file_extension: 'rb',

  comments: {
    line_single: '#',
    line_multi: {
      start: '=begin',
      end: '=end'
    }
  },

  keywords_comments: {
    # keywords that denote good practices
    potentially_good: [
      'MARK:'
    ],

    potentially_neutral: [
      'improve'
    ],

    # keywords that denote bad practices
    potentially_bad: [
      'TODO',
      'FIXME',
      'TBD',
      'HACK',
      '!!!'
    ]
  },

  keywords_code: {
    # keywords that denote architecture refinement
    types: [
      'class '
    ],

    # keywords that denote structuring code
    functions: [
      'def ',
    #   '\{' # lambdas can't be distinguished
    ],

    # keywords that denote code branching
    complexity: [
      'if ',
      'unless ',
      'case ', # switch
      ' \? ', # ternary operator
    ],

    # heavily oppinionated

    # keywords that denote good practices
    potentially_good: [
      'freeze',
      'map',
      'reduce',
      'inject',
    ],

    # keywords that are neither good or bad practice, but good to know about.
    potentially_neutral: [
      'puts',
    ],

    # keywords that denote bad practices
    potentially_bad: [
      'return', # uses return instead of knowing the last value in a method is returned.
    ]
  }
}.freeze
