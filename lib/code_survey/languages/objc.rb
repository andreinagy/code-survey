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
      'implementation ', # the implementation is unique
      'struct ',
      'NS_ENUM ',
      'protocol ',
      'typedef '
    ],

    # keywords that denote structuring code
    functions: [
      '[+-]\s?\([a-zA-Z]+?\)[a-zA-Z]+', # - (void)anyNumberOfCharacters
      '\^\{' # closure with arguments.
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
      'strong',
      'weak',
      '@interface\s[a-zA-Z]+\s\([a-zA-Z]*\)', # categories
      ' in ', # fast enumerations and closures
      'assert\(',
      'NSAssert\(',
      'NSError'
    ],

    # keywords that are neither good or bad practice, but good to know about.
    potentially_neutral: [
      'NSNull',
      'objc_setAssociatedObject',
      'objc_getAssociatedObject',
      'dispatch_async',
      '@dynamic',
      'performSelector:',
      'NSClassFromString',
      'NSSelectorFromString',
      '#define',
      'NSNotificationCenter',
      'NSUserDefaults'
    ],

    # keywords that denote bad practices
    potentially_bad: [
      ' shared', # singletons
      'dispatch_', # uses delays to layout views?
      'unsafe_unretained',

      'true', # non Objective C bools.
      'false', # non Objective C bools.
      'TRUE', # non Objective C bools.
      'FALSE', # non Objective C bools.

      ' shared', # singletons
      '@\"\"', # empty strings
      '@\".+\"', # string literals
      '[0-9]*\.?[0-9]+', # magic numbers
    ]
  }
}.freeze
