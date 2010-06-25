package org.adamtheengineer.examples.thread;

public class UnsafeFinalClassDriver {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		UnsafeFinalClass clazz = new UnsafeFinalClass();

		for (int i = 0; i < 5; i++) {
			UnsafeFinalClassWorker unsafeFinalClassWorker = new UnsafeFinalClassWorker(clazz);
			unsafeFinalClassWorker.start();
		}
	}
}
