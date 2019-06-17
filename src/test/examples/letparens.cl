class Foo inherits IO {
	bar(b:Int):Int {
		{
			let a:Int in (a + b);
			(let a:Int in a) + b;
			out_int(a);
			out_string("\n");
			let a:Int in (a) + (b);
		}
	};
};

class Main {
	main() : Int {
		1
	};
};