-- calls.cl

class Main inherits IO {
  

  main():Object {{
    -- correct: 15
    -- buggy: 11 (pushing h's 2 overwrites f's 6)
    out_int( f(g(1), h(2)) );
    out_string("\n");
  }};

  f(x:Int, y:Int):Int { x+y };
  g(x:Int):Int { x+5 };
  h(x:Int):Int { x+7 };

};
