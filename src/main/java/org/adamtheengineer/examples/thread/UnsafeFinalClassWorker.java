package org.adamtheengineer.examples.thread;


public class UnsafeFinalClassWorker extends Thread {

	// an instance of the final class
	private UnsafeFinalClass unsafeFinalClass;

	/**
	 * Construct this worker thread using an instance of the UnsafeFinalClass
	 * @param clazz
	 */
	public UnsafeFinalClassWorker(UnsafeFinalClass unsafeFinalClass){
		this.unsafeFinalClass = unsafeFinalClass;
	}

	/**
	 * override the run method of java.lang.Thread
	 * @see Thread
	 */
	@Override
	public void run(){

			unsafeFinalClass.doSomething();
	}
}
