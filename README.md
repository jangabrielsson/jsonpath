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
