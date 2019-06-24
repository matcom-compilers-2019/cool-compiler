class Main inherits IO {
  x:Int;
  y:Int;
  main():IO { 
    {
    	x <- y <- (5 * 6 + 7);
    	out_int(x);
    	out_string("\n");
    }
  };
};

