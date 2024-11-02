" Making sure we spell check all strings
"
" Basic strings
syn region tomlString oneline start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=tomlEscape,@Spell
"" " Multi-line basic strings
syn region tomlString start=/"""/ end=/"""/ contains=tomlEscape,tomlLineEscape,@Spell
" " Literal strings
syn region tomlString oneline start=/'/ end=/'/ contains=@Spell
" " Multi-line literal strings
syn region tomlString start=/'''/ end=/'''/ contains=@Spell
