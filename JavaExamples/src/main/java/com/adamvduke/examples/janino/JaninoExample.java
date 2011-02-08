package com.adamvduke.examples.janino;

import org.codehaus.janino.SimpleCompiler;

public class JaninoExample {

	@SuppressWarnings("all")
	public static void main(String[] args) {
		try {
			// get the text to compile
			String helloWorldClass = HelloWorldBuilder.helloWorld();

			// create the compiler and "cook" the text
			SimpleCompiler compiler = new SimpleCompiler();
			compiler.cook(helloWorldClass);

			// get a reference to the Class
			Class<IHelloWorld> clazz = (Class<IHelloWorld>) Class.forName(
					"com.adamvduke.examples.janino.HelloWorld", true, compiler
							.getClassLoader());

			// instantiate and call methods
			IHelloWorld instance = clazz.newInstance();
			instance.printHelloWorld();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
