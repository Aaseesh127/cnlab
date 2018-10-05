import java.util.*;


class CRC {
	public static int[] div(int data[],int gen[],int n,int g){
		int[] r = new int[n+g];

		for(int i=0;i<g;i++){
			r[i] = data[i];
		}
		for(int i=0;i<n;i++){
			int k=0;
			int msb= r[i];
			for(int j=i;j<g+i;j++){
				if(msb==0)
					r[j]=r[j]^0;
				else
					r[j]=r[j]^gen[k];
			k++;
			}
		
		r[g+i] = data[g+i];
		}
	
	System.out.println("Reminder:");
	for(int i=n;i<n+g-1;i++){
		data[i]=r[i];
		System.out.println(data[i]);
	}
	return data;
}			

	public static void main(String args[]){
	int[] data = new int[100];
	int[] gen = new int[100];
	int n,g;
	System.out.println("Enter number of data bits for the data");
	Scanner input = new Scanner(System.in);
	n = input.nextInt();
	System.out.println("Enter number of generator bits");
	g = input.nextInt();
	System.out.println("Enter the data bits one by one");
	for(int i=0;i<n;i++){
		data[i] = input.nextInt();
	}
	
	System.out.println("Enter the generator bits one by one");
	for(int i=0;i<g;i++){
		gen[i] = input.nextInt();
	}
	
	for(int i=n;i<n+g-1;i++){
		data[i] = 0;
	}
	
	int[] codeword = new int[100];
	codeword = div(data,gen,n,g);
	
	System.out.println("The codeword sent by Sender");
	for(int i=0;i<n+g-1;i++){
		System.out.println(codeword[i]);
	}
	
	
	int[] codewordR = new int[100]; 
	int[] Rdata = new int[100];
	System.out.println("Enter your databit again to check for error:");
	for(int i=0;i<n;i++){
		Rdata[i] = input.nextInt();
	}
	
	codewordR = div(Rdata,gen,n,g);
	int errorflag = 0;
	for(int i=n;i<g+n-1;i++){
		if(codewordR[i] !=0){
			errorflag=1;
			break;
		}
	}
	
	if(errorflag==0)
		System.out.println("No error");
	else
		System.out.println("Error!");
}
				
}
	
	
		
		
	
			
