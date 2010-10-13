/*
 Copyright (c) 2010 Adam Duke
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "TwitterHelper.h"
#import "TwitterHarvester.h"
#import "JSON.h"
#import "stdio.h"

int main (int argc, const char * argv[]) {
	
	// create auto release pool
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// get the path to write to
	printf("What is the output path?\n");
	char userInputPath;
	scanf("%s", &userInputPath);
	
	//convert the char's to NSString's
	NSString *path = [[NSString alloc ]initWithUTF8String:&userInputPath];
	
	NSString *rootOutputPath = nil;
	
	if (![path hasSuffix:@"/"]) 
	{
		rootOutputPath = [[NSString alloc ]initWithFormat:@"%@%@", path, @"/"];
	}
	else 
	{
		rootOutputPath = [[NSString alloc ]initWithString:path];
	}
	
	//get the username to harvest data for
	printf("What user would you like data for?\n");
	char userInputName;
	scanf("%s", &userInputName);

	NSString *userName = [[NSString alloc ]initWithUTF8String:&userInputName];
	TwitterHarvester *harvester = [[TwitterHarvester alloc]init];
	[harvester harvestToPath:rootOutputPath userName:userName];
		
	[path release];
	[rootOutputPath release];
	[userName release];
	[harvester release];
	
	[pool drain];
    return 0;
}
