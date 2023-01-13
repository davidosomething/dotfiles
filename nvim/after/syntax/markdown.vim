" after/syntax/markdown.vim

" Hightlight YAML frontmatter
" https://habamax.github.io/2019/03/07/vim-markdown-frontmatter.html
unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml
let b:current_syntax = 'markdown'
