import java.net.*;
import java.io.*;

class RTCP{
	public static void main(String args[]) throws IOException{
		Socket sock = new Socket("localhost",5009);
		System.out.println("Enter the filename");
		BufferedReader keyread = new BufferedReader(new InputStreamReader(System.in));
		String fname = keyread.readLine();
		OutputStream ostream = sock.getOutputStream();
		PrintWriter pwrite = new PrintWriter(ostream,true);
		pwrite.println(fname);
		InputStream istream = sock.getInputStream();
		BufferedReader sockread = new BufferedReader(new InputStreamReader(istream));
		String msg;
		while((msg=sockread.readLine())!=null){
			System.out.println(msg);
		}
}
}
