-- Static dispatch chooses a method based on the static type of the
-- dispatching object.


class Base inherits IO
{
  identify() : Object
  {
    out_string( "base\n" )
  };
};


class Derived inherits Base
{
  identify() : Object
  {
    out_string( "derived\n" )
  };
};


class Main
{
  me : Base;
  main() : Object
  {
    {
      me <- new Base;
	    me@Base.identify();


    }
  };
};
