OBJC_LANGUAGE = {
  name: 'Objective C',
  file_extension: '(h|m)',

  comments: {
    line_single: '//',
    line_multi: {
      start: '/\*',
      end: '\*/'
    }
  },

  keywords_comments: {
    # keywords that denote good practices
    potentially_good: [
      '#pragma mark:'
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
      'implementation ',
      'struct ',
      'NS_ENUM ',
      'protocol ',
      'typedef '
    ],

    # keywords that denote structuring code
    functions: [
      '- \(.*\).*', # - (void)anyNumberOfCharacters
      '\{ \(' # closure with arguments.
    ],

    # keywords that denote code branching
    complexity: [
      'if ',
      'guard ',
      'switch ',
      ' \? ', # ternary operator
    ],

    # heavily oppinionated

    # keywords that denote good practices
    potentially_good: [
      '_Nonnull',
      'nonnull',
      '_Nullable',
      'nullable',
      'extension',
      ' in ', # fast enumerations and closures
      'assert\(',
      'fatalError\('
    ],

    # keywords that are neither good or bad practice, but good to know about.
    potentially_neutral: [
      '@objc'
    ],

    # keywords that denote bad practices
    potentially_bad: [
      ' shared', # singletons
      'dispatch_', # uses delays to layout views?
    ]
  }
}.freeze
