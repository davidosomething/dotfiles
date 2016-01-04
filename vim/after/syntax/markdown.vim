" after/syntax/markdown.vim

" Highlight YAML frontmatter, include spellcheck
unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start="\%^---$" end="^---\s*$" keepend contains=@Yaml,@Spell
let b:current_syntax='markdown'

