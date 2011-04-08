package com.adamvduke.examples.thread;

import java.util.ArrayList;

/**
 * This class is a demonstration that making a class final does not make it
 * thread safe
 *
 * @author adamd
 *
 */
public final class SafeFinalClassV2 implements IFinalClass {

	/*
	 * Here we create some shared object for the class
	 */
	private ArrayList<Integer> list = new ArrayList<Integer>();
	public static String notThreadSafe = "Class isn't thread safe";
	private Long startTime = null;

	/**
	 * The object of the doSomething method in this class is to fix the non-thread safe
	 * version proposed in {@link UnsafeFinalClass} and improve on the performance of
	 * {@link SafeFinalClassV1} by limiting the synchronization to the section of code
	 * that actually accesses the shared memory
	 */
	public void doSomething() {

		setStartTime();
		synchronized (list) {
			if (list != null) {

				try {
					// sleep any incoming threads, if there are multiple threads
					// calling this method they will have to wait until the current
					// thread exits the method to continue
					Thread.sleep(2000);

					// access the shared memory
					list.clear();

					// here we set the shared object to null
					list = null;
				} catch (InterruptedException interruptedException) {
					throw new RuntimeException(
							"Thread was interrupted in synchronized block",
							interruptedException);
				} catch (NullPointerException nullPointerException) {
					System.out.println(notThreadSafe);
				}
			}
		}
		try {
			// simulate this method doing some other hard work after accessing
			// the shared memory
			Thread.sleep(2000);
		} catch (InterruptedException e) {
			throw new RuntimeException(
					"Thread was interrupted in unsynchronized block", e);
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
