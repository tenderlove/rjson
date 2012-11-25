class RJSON::Parser

rule
  string
    : a_or_cs abb
    | abb
    ;
  a_or_cs
    : a_or_cs a_or_c
    | a_or_c
    ;
  a_or_c : 'a' | 'c' ;
  abb    : 'a' 'b' 'b';
end
