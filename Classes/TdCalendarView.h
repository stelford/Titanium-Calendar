//
//  CalendarView.h
//

#import <UIKit/UIKit.h>

@protocol CalendarViewDelegate;

@interface TdCalendarView : UIView {
	CFGregorianDate currentMonthDate;
	CFGregorianDate currentSelectDate;
	CFAbsoluteTime	currentTime;
	UIImageView* viewImageView;
	id<CalendarViewDelegate> calendarViewDelegate;
	int *monthFlagArray; 
}

@property CFGregorianDate currentMonthDate;
@property CFGregorianDate currentSelectDate;
@property CFAbsoluteTime  currentTime;

@property (nonatomic, retain) UIImageView* viewImageView;
@property (nonatomic, assign) id<CalendarViewDelegate> calendarViewDelegate;
-(int)getDayCountOfaMonth:(CFGregorianDate)date;
-(int)getMonthWeekday:(CFGregorianDate)date;
@end



@protocol CalendarViewDelegate<NSObject>
- (int) getDayFlag:(CFGregorianDate)day;
- (void) setDayFlag:(CFGregorianDate)day flag:(int)flag;
@optional
- (void) clearAllDayFlag;
- (void) selectDateChanged:(CFGregorianDate) selectDate;
- (void) monthChanged:(CFGregorianDate) currentMonth viewLeftTop:(CGPoint)viewLeftTop height:(float)height;
- (void) beforeMonthChange:(TdCalendarView*) calendarView willto:(CFGregorianDate) currentMonth;
@end