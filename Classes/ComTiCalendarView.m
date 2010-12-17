/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComTiCalendarView.h"

#import "TiUtils.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TdCalendarView.h"
#import "ComTiCalendarItemProxy.h"

@implementation ComTiCalendarView

@synthesize events, eventsSelectedCallback;

-(void)dealloc {
	RELEASE_TO_NIL(cal); 
	RELEASE_TO_NIL(eventsSelectedCallback);
	RELEASE_TO_NIL(events);
	[super dealloc];
}

-(UIView *)cal 
{
	if (cal==nil) {
		cal = [[TdCalendarView alloc] initWithFrame:[self frame]]; 
		[(TdCalendarView *)cal setCalendarViewDelegate: self];
		[self addSubview:cal];
	}	
	return cal;
}
 

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds {
	if (cal!=nil) {
		[TiUtils setView:cal positionRect:bounds];
	}
}

// handy little function for making a date sans time 
-(NSDate *)dateWithNoTime:(NSDate *)dateTime {
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
											   fromDate:dateTime];
	NSDate *dateOnly = [calendar dateFromComponents:components];
	[dateOnly dateByAddingTimeInterval:(60.0 * 60.0 * 12.0)];           // Make all date's the middle of day.
	return dateOnly;
}


-(void)setEvents_:(id)theEvents {
	if (theEvents != nil) {		
		self.events = [[[NSMutableDictionary alloc] init] autorelease];
		for (NSString *key in theEvents) {
			ComTiCalendarItemProxy *event = [theEvents objectForKey:key];
			NSDate *aDate = [self dateWithNoTime: [event valueForUndefinedKey:@"sdate"]];
			// a dict of arrays.. sorry :)
			NSMutableArray *potentialDict = [self.events objectForKey: aDate];
			if (potentialDict == nil) {
				NSMutableArray *arr = [[[NSMutableArray alloc] initWithObjects: event, nil] autorelease];
				[self.events setObject:arr forKey: aDate];
			}
			else{
				[potentialDict addObject: event];
			}
		}
		self.events = events;
	}
}

-(void)setColor_:(id)color {
	UIColor *c = [[TiUtils colorValue:color] _color]; 
	UIView *s = [self cal]; 
	s.backgroundColor = c;
}



-(void)setEventsSelected_:(id)args
{
	ENSURE_SINGLE_ARG(args,KrollCallback);
	id _ev = args; 
	RELEASE_TO_NIL(eventsSelectedCallback);
	eventsSelectedCallback = [_ev retain];
}
 
 
#pragma mark -
#pragma mark TdCalendarViewDelegateMethods

-(int)getDayFlag:(CFGregorianDate)day
{
	// TBD
	// a redraw shouldn't call this 30+ times .. this happens when we click around
	// the calendar widget jst selecting random days .. boo
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat = @"yyyy-MM-dd 12:00:00";	
	NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat: @"%d-%d-%d", day.year, day.month, day.day] ];
		
	if ([self.events objectForKey: date] != nil) {
		return -1;
	}
	else {
		return 0;
	}
}


-(void)setDayFlag:(CFGregorianDate)day flag:(int)flag
{
    // TBD
}

- (void)selectDateChanged:(CFGregorianDate)selectDate
{
	if (eventsSelectedCallback) {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		dateFormatter.dateFormat = @"yyyy-MM-dd 12:00:00";	
		NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat: @"%d-%d-%d", 
													  selectDate.year, selectDate.month, selectDate.day] ];
		
		NSArray *tmpDates = [self.events objectForKey: date];
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys: tmpDates, @"events", nil];
		[self.proxy _fireEventToListener:@"eventsSelected" withObject:event listener: eventsSelectedCallback thisObject: nil];
	}
};


@end
