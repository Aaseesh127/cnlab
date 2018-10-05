Begin{
	#include <stdio.h>
	c =0;
}

{
	if($1 == "d")
		c++
}

END{
	print("No. of packets dropped:",c);
}

