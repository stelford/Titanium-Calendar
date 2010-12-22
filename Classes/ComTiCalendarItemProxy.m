/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComTiCalendarItemProxy.h"
#import "TiUtils.h"
#import "TiBase.h"
#import <EventKit/EventKit.h>
#import <Foundation/NSFormatter.h>



@implementation ComTiCalendarItemProxy


-(id)initWithEvent: (EKEvent *)event
{
	if (self=[super init])
	{
		[self setTitle:event.title];
		[self setStartDate:event.startDate];
		[self setEndDate:event.endDate];
		[self replaceValue:event.location forKey:@"location" notification:NO];
		[self replaceValue:event.eventIdentifier forKey:@"eventIdentifier" notification:NO];
	}
	return self;
}


-(void)dealloc
{
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}





#pragma mark -
#pragma mark HereAreTheSettersAndGetters

-(id)title
{	
	return [self valueForUndefinedKey:@"title"];
}

-(void)setTitle:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSString);
	// make sure to store the value into dynprops as well, this
	// normally is set during the createFooBar({title:"blah"}); 
	[self replaceValue:value forKey:@"title" notification:NO];
}


-(id)startDate
{
	// grab the value from the dynprops first of all
	NSDate *tmpSdate = [self valueForUndefinedKey:@"sdate"];
	// if it's a sane value, then let's format it out
	if (tmpSdate != nil) {
		return [NSDateFormatter localizedStringFromDate:tmpSdate
											dateStyle:NSDateFormatterMediumStyle
											timeStyle:NSDateFormatterShortStyle];
	}		
	return @"";
}

-(void)setStartDate:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSDate);
	// make sure to store the value into dynprops as well, this
	// normally is set during the createFooBar({title:"blah"}); 
	[self replaceValue:value forKey:@"sdate" notification:NO];
}

-(id)endDate
{
	// grab the value from the dynprops first of all
	NSDate *tmpEdate = [self valueForUndefinedKey:@"edate"];
	// if it's a sane value, then let's format it out
	if (tmpEdate != nil) {
		return [NSDateFormatter localizedStringFromDate:tmpEdate
											  dateStyle:NSDateFormatterMediumStyle
											  timeStyle:NSDateFormatterShortStyle];
	}		
	return @"";
}

-(void)setEndDate:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSDate);
	[self replaceValue:value forKey:@"edate" notification:NO];
}



// Surely there has to be a way to hook into the create....({}) call ?
-(NSDictionary *)saveEvent:(id)obj
{
	EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
	EKEvent *_event = [EKEvent eventWithEventStore:eventStore];
	_event.title = [self valueForUndefinedKey:@"title"];
	_event.startDate = [self valueForUndefinedKey:@"sdate"];	
	_event.location = [self valueForUndefinedKey:@"location"];	
	_event.endDate = [self valueForUndefinedKey:@"edate"];	
    if ([self valueForUndefinedKey:@"edate"] == nil) {
		_event.endDate = [[[NSDate alloc] initWithTimeInterval:1200 sinceDate:_event.startDate] autorelease];
	}
	
    [_event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err = nil;
    [eventStore saveEvent:_event span:EKSpanThisEvent error:&err];   
	BOOL status = (err == nil) ? TRUE : FALSE;
	NSString *errStr = (err != nil) ? [err localizedDescription] : @"none";
	
	NSDictionary *tmp = [[[NSDictionary alloc] initWithObjectsAndKeys: errStr, @"error", 
													   NUMBOOL(status), @"status",
													   _event.eventIdentifier, @"eventId",
													   nil] autorelease];
	return tmp;
}


-(NSDictionary *)deleteEvent:(id)value
{
	EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
	EKEvent *_event = [eventStore eventWithIdentifier: [self valueForUndefinedKey:@"eventIdentifier"]];
	// not setting this causes all SORTS of explosions when you try to call localizedDescription later
	NSError *err = nil;
	if (_event != nil) {
		[eventStore removeEvent:_event span:EKSpanThisEvent error:&err];
	}
	BOOL status = (err == nil) ? TRUE : FALSE;
	NSString *errStr = (err != nil) ? [err localizedDescription] : @"none";	
	NSDictionary *tmp = [[[NSDictionary alloc] initWithObjectsAndKeys: errStr, @"error", 
																	   NUMBOOL(status), @"status",
																	   nil] autorelease];
	return tmp;
}


@end
