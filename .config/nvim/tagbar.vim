let g:tagbar_type_rust = {
			\ 'kinds' : [
			\ 'n:module:1:0',
			\ 's:struct',
			\ 'i:trait',
			\ 'c:implementation:0:0',
			\ 'f:function',
			\ 'g:enum',
			\ 't:type alias',
			\ 'v:global variable',
			\ 'M:macro',
			\ 'm:struct field',
			\ 'e:enum variant',
			\ 'P:method',
			\ '?:unknown',
			\ ],
			\ }

let g:tagbar_type_go = {
			\ 'kinds' : [
			\ 'p:packages:0:0',
			\ 'i:interfaces:0:0',
			\ 'c:constants:0:0',
			\ 's:structs',
			\ 'm:struct members:0:0',
			\ 't:types',
			\ 'f:functions',
			\ 'v:variables:0:0',
			\ '?:unknown',
			\ ],
			\ }

let g:tagbar_type_python = {
			\ 'kinds' : [
			\ 'i:modules:1:0',
			\ 'c:classes',
			\ 'f:functions',
			\ 'm:members',
			\ 'v:variables:0:0',
			\ '?:unknown',
			\ ],
			\ }
