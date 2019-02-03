# each string is searched in a line; multiple occurences of the same keyword are not found.
SWIFT_LANGUAGE = {
  # nandrei this should be an array, for objC or c++, .h, .m, etc..
  file_extension: 'swift',

  comments: {
    line_single: '//',
    line_multi: {
      start: '/\*',
      end: '\*/'
    }
  },

  keywords: {
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
      ' ? ', # ternary operator
    ],

    # keywords that denote good practices
    good: [
      'init?\(',
      'init() throws',
      'extension',
      'forEach',
      'map',
      ' in ', # fast enumerations and closures
      'self\]', # weak and unowned
      ' ?? ',
      'assert\(',
      'fatalError\('
    ],

    # keywords that denote bad practices
    bad: [
      '! ', # force unwrap, downcasting
      ' shared', # singletons
      'DispatchQueue.main', # uses delays to layout views?
      'TODO',
      'FIXME',
      'TBD',
      'HACK'
    ]
  }
}.freeze
