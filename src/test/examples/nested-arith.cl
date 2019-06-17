-- Some complex expressions require quite a few temporaries.

-- This is an easier version of many-temps.cl.


class Main inherits IO
{
  a : Int;
  b : Int;
  c : Int;

  main() : Object
  {
    {
      a <- 2;
      b <- 1;
      c <- 3;
      out_int(a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * a + b * (a + b * (a + b * c))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
      out_string( "\n" );
    }
  };
};
