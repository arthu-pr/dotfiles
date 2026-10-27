local ls = require('luasnip')

ls.add_snippets('typescript', {
  ls.parser.parse_snippet("!cl", "console.log('${1:variable}');"),
  ls.parser.parse_snippet("!clg", "console.group('${1:description}');\n$0\nconsole.groupEnd();"),
})
