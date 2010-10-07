package org.adamtheengineer.examples.io;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.PrintStream;

/**
 * Class contains main method that accepts an input file path, an output file
 * directory, a file extension, and a number of lines per output file
 * 
 * The input file is read line by line and saved into multiple smaller files to
 * the output file directory
 * 
 * @author adamd
 * 
 */
public class ReadWrite {

	public static void main(final String args[]) {

		// get input arguments
		String inputFilePath = args[0];
		String outputFileDirectory = args[1];
		String outputFileExtension = args[2];
		int linesInNewFile = Integer.parseInt(args[3]);

		File inputFile = new File(inputFilePath);
		FileReader fileReader;
		try {
			fileReader = new FileReader(inputFile);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
			String aLine = bufferedReader.readLine(); // prime reader
			int lineNumber = 1;

			while (aLine != null) {

				// Stream to write file
				FileOutputStream fileOutputStream;

				String fileName = buildFileName(lineNumber, linesInNewFile,
						outputFileExtension);

				// Open an output stream
				fileOutputStream = new FileOutputStream(outputFileDirectory
						+ fileName);
				for (int j = 0; j < linesInNewFile; j++) {

					// write a line of text
					new PrintStream(fileOutputStream).println(aLine);

					// read next line
					aLine = bufferedReader.readLine();
					if (aLine == null) {
						break;
					}
				}
				lineNumber += linesInNewFile;
				fileOutputStream.close();
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	private static String buildFileName(final int beginIndex,
			final int linesInNewFile, final String outputFileExtension) {

		StringBuilder filename = new StringBuilder();
		int endIndex = beginIndex + linesInNewFile - 1;
		filename
				.append(beginIndex + "-" + endIndex + "." + outputFileExtension);
		return filename.toString();
	}
}
