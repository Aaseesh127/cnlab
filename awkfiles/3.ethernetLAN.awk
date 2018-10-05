Begin{
	#include <stidio.h>
}

{
	if($6 == "cwnd_")
		print("%f\t%f\n",$1,$7)
}
END{
}
