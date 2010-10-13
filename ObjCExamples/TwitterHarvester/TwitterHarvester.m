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

#import "TwitterHarvester.h"
#import "TwitterHelper.h"
#import <JSON/JSON.h>

@interface TwitterHarvester ()

- (void)createOutputDirectories;
- (NSString *)initOutputPath:(NSString *)rootPath forFile:(NSString *)fileName;
- (void)processUser:(NSString *)userId;
- (NSTimeInterval)calculateSleepTimeInterval;

@end


@implementation TwitterHarvester

@synthesize extension, rootInfoPath, rootTimelinePath, rootFriendsIDsPath;

- (NSTimeInterval)calculateSleepTimeInterval
{
	NSURL *rateLimitURL = [[NSURL alloc]initWithString:@"http://api.twitter.com/1/account/rate_limit_status.json"];
	NSString *rateLimitString = [[NSString alloc] initWithContentsOfURL:rateLimitURL];
	NSDictionary *rateLimitDictionary = [rateLimitString JSONValue];
	NSDecimalNumber *remainingHits = [rateLimitDictionary valueForKey:@"remaining_hits"];
	NSDecimalNumber *resetTime = [rateLimitDictionary valueForKey:@"reset_time_in_seconds"];
	double now = [[NSDate date] timeIntervalSince1970];
	double secondsToReset = [resetTime doubleValue] - now;
	
	// (remaining_hits / seconds to reset) * 60 = remaining requestes per minute
	// 60 / remain requests per minute = wait interval
	double remainingReqPerMin = ([remainingHits doubleValue]/secondsToReset) * 60;
	double interval = 60 / remainingReqPerMin;
	NSLog(@"Waiting %.2f seconds, %.2f seconds to reset", interval, secondsToReset);
	return interval;
}

- (void)createOutputDirectories
{
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *paths = [[NSArray alloc]initWithObjects:self.rootInfoPath, self.rootTimelinePath, self.rootFriendsIDsPath,nil ];
	for(NSString *path in paths)
	{
		NSError *error = nil;
		[manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
		if (error != nil) {
			NSLog(@"%@",[error description]);
		}
	}
}

- (NSString *)initOutputPath:(NSString *)rootPath forFile:(NSString *)fileName
{
	NSString *outputPath = [[NSString alloc ]initWithFormat:@"%@%@%@", rootPath, fileName, extension];
	return outputPath;
}

- (void)processUser:(NSString *)userId
{
	// construct the full path for this iterations info
	NSString *fullInfoPath = [self initOutputPath:rootInfoPath forFile:userId];
	
	// construct the full path for this iterations timeline
	NSString *fullTimelinePath = [self initOutputPath:rootTimelinePath forFile:userId];
	
	// get the URL for the info api request
	NSURL *userInfoURL = [TwitterHelper initNSURLForUserInfo:userId];
	
	// use stringWithContentsOfURL to get the data
	NSString *userInfoString = [[NSString alloc ]initWithContentsOfURL:userInfoURL encoding:NSUTF8StringEncoding error:nil];
	[userInfoURL release];
	
	// sleep to avoid rate limiting
	[NSThread sleepForTimeInterval:[self calculateSleepTimeInterval]];

	// write the data to the appropriate path
	[userInfoString writeToFile:fullInfoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	// get the url for the timeline api request
	NSURL *timelineURL = [TwitterHelper initNSURLForUserTimeline:userId];
	
	// use stringWithContentsOfURL to get the data
	NSString *timelineString = [[NSString alloc ]initWithContentsOfURL:timelineURL encoding:NSUTF8StringEncoding error:nil];
	[timelineURL release];
	
	// sleep to avoid rate limiting
	[NSThread sleepForTimeInterval:[self calculateSleepTimeInterval]];

	// write the data to the appropriate path
	[timelineString writeToFile:fullTimelinePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	// get the dictionary representation of the user info
	NSDictionary *userInfo = [userInfoString JSONValue];
	
	// get the value for the key "screen_name"
	NSString *screenName = [userInfo valueForKey:@"screen_name"];
	
	// construct another path to save the same data with the username instead of id for the filename
	fullInfoPath = [self initOutputPath:rootInfoPath forFile:screenName];
	
	// construct another path to save the same data with the username instead of id for the filename
	fullTimelinePath = [self initOutputPath:rootTimelinePath forFile:screenName];
	
	// write the files to the appropriate paths
	[userInfoString writeToFile:fullInfoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[timelineString writeToFile:fullTimelinePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	[fullInfoPath release];
	[fullTimelinePath release];
	[userInfoString release];
	[timelineString release];
	[screenName release];
	
}

- (void)harvestToPath:(NSString *)rootOutputPath userName:(NSString *)userName
{
	// define where to write the output
	self.rootTimelinePath = [[NSString alloc ]initWithFormat:@"%@statuses/user_timeline/", rootOutputPath];
	self.rootInfoPath = [[NSString alloc ]initWithFormat:@"%@users/show/", rootOutputPath];
	self.rootFriendsIDsPath = [[NSString alloc ]initWithFormat:@"%@friends/ids/", rootOutputPath];
	
	// the extension for the files
	self.extension = [[NSString alloc]initWithString:@".json"];
	
	[self createOutputDirectories];
	
	// construct full path to save the JSON containing the id's
	NSString *idsDataPath = [self initOutputPath:rootFriendsIDsPath forFile:userName];

	// get the url for the api request
	NSURL *idsURL = [TwitterHelper initNSURLForFollowingIDs:userName];
	
	// use stringWithContentsOfURL to get the data
	NSString *idsString = [[NSString alloc ]initWithContentsOfURL:idsURL encoding:NSUTF8StringEncoding error:nil];
	[idsURL release];
	
	// write the data to the path defined earlier
	[idsString writeToFile:idsDataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[idsDataPath release];

	// use the json-framework to get an NSArray from the string
	NSArray *userIds = [idsString JSONValue];
	[idsString release];
	// for each id in the array fetch the two pieces of data and write them to the appropriate paths
	for (NSDecimalNumber *userid in userIds) 
	{
		// get a string representation of the id
		NSString *userId = [[NSString alloc ]initWithFormat:@"%@", userid];
		[self processUser:userId];
		[userId release];
		
	}	
}

- (void)dealloc
{
	[super dealloc];
	[rootInfoPath release];
	[rootFriendsIDsPath release];
	[rootTimelinePath release];
	[extension release];
}

@end
