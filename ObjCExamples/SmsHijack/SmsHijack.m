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
#import "FMDatabase.h"
#import "stdio.h"

int main (int argc, const char * argv[]) {
   
	// auto release pool for the app
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// database for the app
	NSString *databasePath = @"/Users/adamd/sms.db";
	FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
	if (![database open]) {
		NSLog(@"Error opening database.");
		if ([database hadError]) {
			NSLog(@"Err %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		}
	}
	
	// ask the user what the output file path is
	printf("What is the output file path?\n");
	
	// scan the name of the person from the console
	char outputFilePath;
	scanf("%s", &outputFilePath);
	
	// convert the path into an NSString
	NSString *filePath = [[NSString alloc] initWithUTF8String:&outputFilePath];
	
	// ask the user what the outgoing person's name is
	printf("What is the outgoing person's name?\n");
	
	// scan the name of the person from the console
	char outgoing;
	scanf("%s", &outgoing);
	
	// convert the name into an NSString 
	NSString *outgoingName = [[NSString alloc] initWithUTF8String:&outgoing];
	
	// get the distinct phone numbers from the sms database
	FMResultSet *distinct = [database executeQuery:@"select distinct address from message"];
	
	// allocate a dictionary to hold address/name pairs
	NSMutableDictionary *addressToNames = [[NSMutableDictionary alloc]init];
	
	// for each distinct phone number
	while ([distinct next]) {
		
		// get the phone number from the result set
		NSString *current = [distinct stringForColumn:@"address"];
		
		if (current) {
			
			// ask the user who the number belongs to
			printf("Who's phone number is %s ?\n", [current UTF8String]);
			
			// scan the name of the person from the console
			char name;
			scanf("%s", &name);
			
			// convert the name into an NSString and add it to the dictionary
			// with the address as the key
			NSString *theName = [[NSString alloc] initWithUTF8String:&name];
			[addressToNames setObject:theName forKey:current];
			[theName release];
		}
	}
	
	// select the date, text, and flags columns from the message table
	FMResultSet *resultSet = [database executeQuery:@"select address, date, text, flags from message"];
	
	// create the output file
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager createFileAtPath:filePath contents:nil attributes:nil];
	
	// get an NSFileHandle object for the file
	NSFileHandle *outputFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	
	// for each row in the result set
	while ([resultSet next]) {
		
		// get the NSDate from the epoch time in the database
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"date"]];
		NSString *dateString = [date descriptionWithCalendarFormat:@"%m-%d-%Y %H:%M" timeZone:nil locale:nil];
		
		// get the value of the address column
		NSString *address = [resultSet stringForColumn:@"address"];

		// set up the sender's name
		NSString *sender = nil;
		NSInteger flag = [resultSet intForColumn:@"flags"];
		
		// if the "flag" is 3 it's outgoing
		if (flag == 3) {
			sender = outgoingName;
		}
		
		// else it's incoming
		else {
			sender = [addressToNames valueForKey:address];;
		}

		// get the text
		NSString *message = [resultSet stringForColumn:@"text"];
		NSString *testout = [NSString stringWithFormat:@"%@ : %@ : %@\n", dateString, sender, message];
		
		// convert string to NSData
		NSData *outData = [testout dataUsingEncoding:NSUTF8StringEncoding];
		
		// append a formatted message to the output
		[outputFileHandle seekToEndOfFile];
		[outputFileHandle writeData:outData];
	}
	
	// release allocated objects
	[filePath release];
	[addressToNames release];
	[resultSet close];
	[database close];
	
	// release the pool
    [pool drain];
	
	// exit
    return 0;
}
