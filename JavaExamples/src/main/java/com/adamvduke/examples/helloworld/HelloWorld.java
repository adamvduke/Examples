package com.adamvduke.examples.helloworld;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

public class HelloWorld {

	/**
	 * @param args
	 */
	public static void main( String[] args ) {

		File inputFile = new File( "src/main/resources/message.txt" );
		String message = readMessageFromFile( inputFile );
		System.out.println( message );
	}

	private static String readMessageFromFile( File inputFile ) {

		try {
			FileReader fileReader = new FileReader( inputFile );
			BufferedReader bufferedReader = new BufferedReader( fileReader );
			String input = bufferedReader.readLine();
			return input;
		}
		catch ( Exception exception ) {
			String errorMessage = "Hey Dumbass, You forgot the file!: " + exception.getMessage();
			System.out.println( errorMessage );
			throw new RuntimeException( errorMessage );
		}
	}
}
