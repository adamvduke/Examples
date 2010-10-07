package org.adamtheengineer.examples.recursion;
public class Palindrome {

	private static String palindrome = "aaabbcbbaaa";
	private static String other = "aaaa";
	private static String notAPalindrome = "something";
	private static String empty = "";
	private static String nullString = null;

	public static void main( String[] args ) {

		System.out.println( palindrome + " is a palindrome " + reverse(palindrome));
		System.out.println( other + " is a palindrome " + reverse(other));
		System.out.println(notAPalindrome + " is a palindrome " + reverse(notAPalindrome));
		System.out.println( "empty string is a palindrome " + reverse(empty));
		System.out.println( "null is a palindrome " + reverse(nullString));
	}

	private static boolean reverse(String base){

		//input check
		if(isNullOrEmpty( base )){
			return false;
		}

		int length = base.length();

		// base case for odd lengths, assuming a single character is a palindrome
		if(length == 1){
			return true;
		}

		// base case for even lengths
		if(length == 2 && base.substring( 0,1 ).equals( base.substring(length -1, length) )){
			return true;
		}

		// recursively call reverse
		if(base.substring( 0, 1 ).equals( base.substring( length -1, length ) )){
			return reverse( base.substring(1, length -1));
		}
		return false;
	}

	private static boolean isNullOrEmpty(String base){
		return base == null || base.length() == 0;
	}
}
