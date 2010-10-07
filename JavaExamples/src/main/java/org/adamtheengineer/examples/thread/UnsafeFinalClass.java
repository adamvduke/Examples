package org.adamtheengineer.examples.thread;

import java.util.ArrayList;

/**
 * This class is a demonstration that making a class final does not make it
 * thread safe
 *
 * @author adamd
 *
 */
public final class UnsafeFinalClass implements IFinalClass {

	/*
	 * Here we create some shared object for the class
	 */
	private ArrayList<Integer> list = new ArrayList<Integer>();
	public static String notThreadSafe = "Class isn't thread safe";
	private Long startTime = null;

	/**
	 * the object of the add method is to block a thread after it passes the
	 * null check if there are other threads trying to call the add method they
	 * will all block in the same place. The thread that wakes up first will set
	 * the shared object to null, any subsequent calls to the shared object will
	 * generate null pointer exceptions
	 */
	public void doSomething() {

		setStartTime();
		if (list != null) {

			try {
				// sleep any incoming threads, if there are multiple threads
				// calling this method
				// the threads will stack up here after they have checked for
				// null
				Thread.sleep(2000);

				// access the shared memory
				list.clear();

				// here we set the shared object to null
				list = null;
			} catch (InterruptedException interruptedException) {
				throw new RuntimeException("Thread was interrupted.",
						interruptedException);
			} catch (NullPointerException nullPointerException) {
				System.out.println(notThreadSafe);
			}
		}
		System.out.println("Thread " + Thread.currentThread().getId()
				+ " finished doing hard work from  "
				+ this.getClass().getSimpleName() + "  "
				+ System.currentTimeMillis() + " elapsed time is "
				+ (System.currentTimeMillis() - startTime));
	}

	private synchronized void setStartTime() {
		if (startTime == null) {
			startTime = Long.valueOf(System.currentTimeMillis());
		}
	}
}
