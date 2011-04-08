package com.adamvduke.examples.thread;

public class UnsafeFinalClassDriver {

	private static int threadCount = 5;
	/**
	 * @param args
	 * @throws InterruptedException
	 */
	public static void main(String[] args) throws InterruptedException {

		UnsafeFinalClass class1 = new UnsafeFinalClass();
		SafeFinalClassV1 class2 = new SafeFinalClassV1();
		SafeFinalClassV2 class3 = new SafeFinalClassV2();

		runWorkers(class1);
		Thread.sleep(threadCount * 50);
		runWorkers(class2);
		Thread.sleep(threadCount * 2050);
		runWorkers(class3);
	}

	private static void runWorkers(IFinalClass finalClass) {

		for (int i = 0; i < threadCount; i++) {
			Worker worker = new Worker(finalClass);
			worker.start();
		}
	}
}
