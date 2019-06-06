class Complex inherits IO {
    a : Int;
    b : Int;

    toString() : String {
        {
            out_string(a);      --error, the variable 'a' is not a string
            out_string(" + ");
            out_string(b);      (*error, the variable 'a' is not a string*)
            out_string("i");
"s";
        }
    };

    sum(other : Complex) : String {
        {out_string("sumando");
"";}
    };

};

class Main inherits IO {
    number1 : Complex;
    number2 : Complex;
};

class Main {
	main() : Int {
		1
	};
};