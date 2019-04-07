# Documentation

code-survey shows a high level picture of a project's structure.
It's inspired from [cloc](https://github.com/AlDanial/cloc) which counts lines of code.
It matches source code files with various regexes which give additional indication about the project.

The output can't be used to judge a code base, it's intended to hint on how it's structured.

## Language rules

Languages are determined by file type and various regexes are constructed to survey the structure of a project located in a directory.
Regexes work per line, so more regexes may match on a single line of code.

Language structure
  name: Programming language name.
  file_extension: File extension regex.
  comments: Comments regexes for the programming language.

  keywords_comments
    potentially_good: regexes that suggest good practices, such as "TODO".
    potentially_neutral: regexes that don't suggest anything on their own, but are good to know about.
    potentially_bad: regexes that suggest bad practices, such as "hack"

  keywords_code:
    types: Regexes that suggest architecture refinement, eg. "class ", "struct ". Good code has many types.
    functions: Regexes that suggest structuring code (normal methods and lambdas if they can be distinguished). Good code has many functions.
    complexity: Regexes that suggest code branching. Bad code has high complexity.

    potentially_good: Regexes that match refined language features, such as higher order functions or error handling.
    potentially_neutral: Regexes that are neutral but good to know about, such as using various apis.
    potentially_bad: Regexes that suggest plain bad practices such as force casting.

## Output

## JSON output

## Tab separated
It's a short version of the JSON output.
Makes pasting to spreadsheets easier.

## Limitations

### Lines of code limitation
All lines containing comments are counted as comments lines. // nandrei verify

### Totals
Not sure how much value there is in totaling stats for different languages.
- totals per language
- Totals for all languages in directory.


