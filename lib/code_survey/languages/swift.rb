SWIFT_LANGUAGE = {
  name: 'Swift',
  file_extension: 'swift',

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
      ' \? ' # ternary operator
    ],

    # heavily oppinionated

    # keywords that denote good practices
    potentially_good: [
      'weak',
      'init\?\(',
      'init() throws',
      'lazy',
      'extension',
      'forEach',
      'map',
      'reduce',
      ' in ', # fast enumerations and closures
      '\[weak self\]', # weak and unowned
      ' \?\? ', # nil coalescing operator
      'assert\(',
      'fatalError\(',
      'Error'
    ],

    # keywords that are neither good or bad practice, but good to know about.
    potentially_neutral: [
      'didSet',
      'willSet',
      'deinit',
      '@IBOutlet',
      '@IBAction',
      '@objc',
      '\[unowned self\]',
      'DispatchQueue.main',
      'NotificationCenter',
      'UserDefaults'
    ],

    # keywords that denote bad practices
    potentially_bad: [
      'self\.', # uses self even though it's not necessary.
      ';', # uses semicolons even though it's not necessary.
      'as!', # force unwrap, downcasting
      'try!', # force unwrap, downcasting
      ' shared', # singletons
      '\"\"', # empty strings
      '\".+\"', # string literals
      '[0-9]*\.?[0-9]+' # magic numbers
    ]
  }
}.freeze
