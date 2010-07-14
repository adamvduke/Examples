package org.adamtheengineer.examples.thread;


public class Worker extends Thread {

	// an instance of the final class
	private IFinalClass finalclass;

	/**
	 * Construct this worker thread using an instance of the UnsafeFinalClass
	 * @param clazz
	 */
	public Worker(IFinalClass unsafeFinalClass){
		this.finalclass = unsafeFinalClass;
	}

	/**
	 * override the run method of java.lang.Thread
	 * @see Thread
	 */
	@Override
	public void run(){

		finalclass.doSomething();
	}
}
