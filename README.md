# jsonpath

Usage:
```Lua
local p = jpath("$..test")
p({h={test=8}})
```

Ex. test data
```Lua
testData =
{
  store = {
    book = {
      {
        category = "reference",
        author = "Nigel Rees",
        title = "Sayings of the Century",
        price = 8.95
      },
      {
        category = "fiction",
        author = "Evelyn Waugh",
        title = "Sword of Honour",
        price = 12.99
      },
      {
        category = "fiction",
        author = "Herman Melville",
        title = "Moby Dick",
        isbn = "0-553-21311-3",
        price = 8.99
      },
      {
        category = "fiction",
        author = "J. R. R. Tolkien",
        title = "The Lord of the Rings",
        isbn = "0-395-19395-8",
        price = 22.99
      }
    },
    bicycle = {
      color = "red",
      price = 19.95
    }
  }
}
```
Test cases
```Lua
local function jpath2(str, expr)
  local res = jpath(str)(expr)
  print(str, "=", json.encode(res))
end

jpath2("$.foo.bar",{foo={b=9,bar=8}})
jpath2("$.foo.bar",{foo={b=9,bar=8}})
jpath2("$[foo].bar",{foo={b=9,bar=8}})
jpath2("$.foo['bar','b']",{foo={b=9,bar=8}})
jpath2("$.*",{foo={b=9,bar=8}})
jpath2("$..b",{foo={b=9,bar={b=7}}})
jpath2("$..[b][1]",{foo={b={7},bar={9}}})
jpath2("$[::-1]",{"a","b","c","d"})
jpath2("$[?(@.book > 3 || @.book==0)]",{boo=9,{book=5},{book=0},{book=3}})
jpath2("$.store.book[*].author",testData)
jpath2("$..author",testData)
jpath2("$.store.*",testData)
jpath2("$.store..price",testData)
jpath2("$..book[2]",testData)
--jpath2("$..book[(@.length-1)]",testData)
jpath2("$..book[-1:]",testData)
jpath2("$..book[1,2]",testData)
jpath2("$..book[?(@.isbn)]",testData)
jpath2("$..book[?(@.price<10)]",testData)
jpath2("$..*",testData)
jpath2("$[(2+2)]",{1,2,3,4})
jpath2("$[?(@.bar || @.foo)]",{a={foo=false}})
jpath2("$[?('b' in @..foo)]",{a={foo={'a','b'}},foo={'c','b'}})
jpath2("$[?(@..foo)]",{a={foo={'a','b'}},c={foo={'c','b'}} })
jpath2("$[?(@.a)]",{a={foo={'a','b'}},c={foo={'c','b'}} })
jpath2("$..[?(@.a>8)]",{a=9,c={a={'c','b'}} })
jpath2("$..[?(!@.a)]",{a=9,c={a={'c'},b=7}})
```

Result:
```Lua
$.foo.bar	=	[8]
$.foo.bar	=	[8]
$[foo].bar	=	[8]
$.foo['bar','b']	=	[8,9]
$.*	=	[{"b":9,"bar":8}]
$..b	=	[9,7]
$..[b][1]	=	[7]
$[::-1]	=	["d","c","b","a"]
$[?(@.book > 3 || @.book==0)]	=	[{"book":5},{"book":0}]
$.store.book[*].author	=	["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]
$..author	=	["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]
$.store.*	=	[{"price":19.95,"color":"red"},[{"price":8.95,"author":"Nigel Rees","title":"Sayings of the Century","category":"reference"},{"price":12.99,"author":"Evelyn Waugh","title":"Sword of Honour","category":"fiction"},{"category":"fiction","price":8.99,"author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3"},{"category":"fiction","price":22.99,"author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8"}]]
$.store..price	=	[19.95,8.95,12.99,8.99,22.99]
$..book[2]	=	[{"price":12.99,"author":"Evelyn Waugh","title":"Sword of Honour","category":"fiction"}]
$..book[-1:]	=	[{"category":"fiction","price":22.99,"author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8"}]
$..book[1,2]	=	[{"price":8.95,"author":"Nigel Rees","title":"Sayings of the Century","category":"reference"},{"price":12.99,"author":"Evelyn Waugh","title":"Sword of Honour","category":"fiction"}]
$..book[?(@.isbn)]	=	[{"category":"fiction","price":8.99,"author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3"},{"category":"fiction","price":22.99,"author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8"}]
$..book[?(@.price<10)]	=	[{"price":8.95,"author":"Nigel Rees","title":"Sayings of the Century","category":"reference"},{"category":"fiction","price":8.99,"author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3"}]
$..*	=	[{"bicycle":{"price":19.95,"color":"red"},"book":[{"price":8.95,"author":"Nigel Rees","title":"Sayings of the Century","category":"reference"},{"price":12.99,"author":"Evelyn Waugh","title":"Sword of Honour","category":"fiction"},{"category":"fiction","price":8.99,"author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3"},{"category":"fiction","price":22.99,"author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8"}]},{"price":19.95,"color":"red"},[{"price":8.95,"author":"Nigel Rees","title":"Sayings of the Century","category":"reference"},{"price":12.99,"author":"Evelyn Waugh","title":"Sword of Honour","category":"fiction"},{"category":"fiction","price":8.99,"author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3"},{"category":"fiction","price":22.99,"author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8"}],19.95,"red",{"price":8.95,"author":"Nigel Rees","title":"Sayings of the Century","category":"reference"},{"price":12.99,"author":"Evelyn Waugh","title":"Sword of Honour","category":"fiction"},{"category":"fiction","price":8.99,"author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3"},{"category":"fiction","price":22.99,"author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8"},8.95,"Nigel Rees","Sayings of the Century","reference",12.99,"Evelyn Waugh","Sword of Honour","fiction","fiction",8.99,"Herman Melville","Moby Dick","0-553-21311-3","fiction",22.99,"J. R. R. Tolkien","The Lord of the Rings","0-395-19395-8"]
$[(2+2)]	=	[4]
$[?(@.bar || @.foo)]	=	[{"foo":false}]
$[?('b' in @..foo)]	=	[{"foo":["a","b"]}]
$[?(@..foo)]	=	[{"foo":["c","b"]},{"foo":["a","b"]}]
$[?(@.a)]	=	[]
$..[?(@.a>8)]	=	[{"a":["c","b"]}]
$..[?(!@.a)]	=	[9,7,["c"],"c"]
```
