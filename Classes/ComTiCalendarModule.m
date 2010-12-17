/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComTiCalendarModule.h"
#import "ComTiCalendarView.h"
#import "ComTiCalendarItemProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <EventKit/EventKit.h>


@implementation ComTiCalendarModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"86953d9f-08f1-44d6-8f40-857de82a8403";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.ti.calendar";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(NSDictionary *)findEvents:(id)args
{
	// grab the dictionary out and the start/end dates. 
	NSDictionary *argDict = [args objectAtIndex:0];
	NSDate *startDate = [argDict objectForKey:@"start"];
	NSDate *endDate = [argDict objectForKey:@"end"];	
	EKEventStore *store = [[[EKEventStore alloc] init] autorelease];
	NSDictionary *theDict = [[NSMutableDictionary alloc] init];
	NSInteger num=0;
	
	if ([startDate compare: endDate] == NSOrderedAscending) {
		NSPredicate *predicate = [store predicateForEventsWithStartDate: startDate endDate: endDate calendars: nil]; 
		NSArray *eventList = [store eventsMatchingPredicate:predicate];
		for (EKEvent *event in eventList) {           
			ComTiCalendarItemProxy *tmpTiObj = [[[ComTiCalendarItemProxy alloc] initWithEvent: event] autorelease];
			// more than 9999 calendar objects and this will break alpha-sort :(
			[theDict setValue: tmpTiObj forKey: [[[NSString alloc] initWithFormat: @"item_%04d", num] autorelease]];
			num++;
		}
	}
	return theDict;
}


@end
