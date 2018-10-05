Begin{
	#include <stido.h>
	c =0;
	d =0;
}

{
	if($1 == "d" && $4 == "4")
		c++
	if($1 == "d" && $4 == "6")
		d++
}


END{
	print("From Source1 No. of packets dropped:\n",c);
	print("From Source2 No. of packets dropped:\n",d);


}
