class Math {
	factorial(n: Int) : Int {
		if n = 1
		then 
			1
		else
			n * factorial(n - 1)
		fi
	};
	
	fibonacci(n: Int) : Int {
		if n = 0
		then	0
		else
			if n = 1
			then	1
			else
				fibonacci(n - 1) + fibonacci(n - 2)
			fi
		fi
	};
};

class Main {
	io: IO <- new IO;
	i: Int;
	math: Math <- new Math;
	s: String;
	main(): Object {
		{
			io.out_string("Hello world\n");
			io.out_string("2 + 2 * 2 = ");
			io.out_int(2 + 2 * 2);
			io.out_string("\n");
			io.out_string("5! = ");
			io.out_int(math.factorial(5));
			io.out_string("\n");

			io.out_string("Fibonacci numbers in range 0..10: ");
			while i <= 10
			loop
			{
				io.out_int(math.fibonacci(i));
				io.out_string(" ");
				i <- i + 1;
			}
			pool;
		
			io.out_string("\n");
			
			if isvoid math
			then
				io.out_string("math is void\n")
			else
				io.out_string("math is not void\n")
			fi;
			
						
			s <- io.in_string();
			new Object;	
		}
	};
};