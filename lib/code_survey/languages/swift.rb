# each string is searched in a line; multiple occurences of the same keyword are not found.
SWIFT_LANGUAGE = {
  # nandrei this should be an array, for objC or c++, .h, .m, etc..
  file_extension: ['swift'],

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
      'class ',
      'struct ',
      'enum ',
      'protocol ',
      'typealias '
    ],

    # keywords that denote structuring code
    functions: [
      'func ',
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
      'init?\(',
      'init() throws',
      'extension',
      'forEach',
      'map',
      ' in ', # fast enumerations and closures
      'self\]', # weak and unowned
      ' \?\? ', # nil coalescing operator
      'assert\(',
      'fatalError\('
    ],

    # keywords that are neither good or bad practice, but good to know about.
    potentially_neutral: [
      '@objc'
    ],

    # keywords that denote bad practices
    potentially_bad: [
      '! ', # force unwrap, downcasting
      ' shared', # singletons
      'DispatchQueue.main', # uses delays to layout views?
    ]
  }
}.freeze
