package org.adamtheengineer.examples.regex;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexExample {

	/**
	 * @author Adam Duke
	 * @param args
	 */
	public static void main( String[] args ) {

		// create the Pattern object
		Pattern testPattern = Pattern.compile( "[0-9]+" );

		// create a numeric String object
		String integerString = "133813";

		// create a non-numeric String object
		String nonIntegerString = "blahblahblah";

		// create Matcher objects for the test strings
		Matcher integerStringMatcher = testPattern.matcher( integerString );
		Matcher nonIntegerStringMatcher = testPattern.matcher( nonIntegerString );

		// check the matchers and print results
		if ( integerStringMatcher.matches() ) {
			System.out.println( "The string '" + integerString + "' is an integer" );
		}
		else {
			System.out.println( "The string '" + integerString + "' is not an integer" );
		}
		if ( nonIntegerStringMatcher.matches() ) {
			System.out.println( "The string '" + nonIntegerString + "' is an integer" );
		}
		else {
			System.out.println( "The string '" + nonIntegerString + "' is not an integer" );
		}
	}
}
