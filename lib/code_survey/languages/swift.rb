SWIFT_LANGUAGE = {
  file_extension: 'swift',

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
    '{ (' # closure
  ],

  # keywords that denote code branching
  complexity: [
    'if ',
    'guard ',
    'switch ',
    ' ? ', # ternary operator
  ],

  # keywords that denote good practices
  keywords_positive: [
    'init?(',
    'init() throws',
    'extension',
    'forEach',
    'map',
    ' in ', # fast enumerations and closures
    'self]', # weak and unowned
    ' ?? ',
    'assert(',
    'fatalError('
  ],

  # keywords that denote bad practices
  keywords_negative: [
    '! ', # force unwrap, downcasting
    ' shared', # singletons
    'DispatchQueue.main', # uses delays to layout views?
    'TODO',
    'FIXME',
    'TBD',
    'HACK'
  ]
}.freeze
