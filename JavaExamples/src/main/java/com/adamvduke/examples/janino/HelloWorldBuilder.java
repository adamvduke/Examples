package com.adamvduke.examples.janino;

public class HelloWorldBuilder {

	
	public static String helloWorld(){
		
		StringBuilder builder = new StringBuilder();
		builder.append("package com.adamvduke.examples.janino;");
		builder.append("public class HelloWorld implements IHelloWorld {");
		builder.append("    public void printHelloWorld() {");
		builder.append("        System.out.println( \"Hello World!\");");
		builder.append("    }");
		builder.append("}");
		return builder.toString();
	}
}
