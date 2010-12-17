//
//  CalendarView.m
//
//

#import "TdCalendarView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

const float headHeight=30;
const float itemHeight=35;
const float prevNextButtonSize=10;
const float prevNextButtonSpaceWidth=15;
const float prevNextButtonSpaceHeight=4;
const float titleFontSize=15;
const int	weekFontSize=10;

@implementation TdCalendarView

@synthesize currentMonthDate;
@synthesize currentSelectDate;
@synthesize currentTime;
@synthesize viewImageView;
@synthesize calendarViewDelegate;

-(void)initCalView{
	currentTime=CFAbsoluteTimeGetCurrent();
	currentMonthDate=CFAbsoluteTimeGetGregorianDate(currentTime,CFTimeZoneCopyDefault());
	currentMonthDate.day=1;
	currentSelectDate.year=0;
	monthFlagArray=malloc(sizeof(int)*31);
	if ([self.calendarViewDelegate respondsToSelector:@selector(clearAllDayFlag)]) {
		[self.calendarViewDelegate clearAllDayFlag];	
	}
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
		[self initCalView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		[self initCalView];
	}
	return self;
}

-(int)getDayCountOfaMonth:(CFGregorianDate)date{
	switch (date.month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
			
		case 2:
			if((date.year % 4==0 && date.year % 100!=0) || date.year % 400==0)
				return 29;
			else
				return 28;
		case 4:
		case 6:
		case 9:		
		case 11:
			return 30;
		default:
			return 31;
	}
}

-(void)drawPrevButton:(CGPoint)leftTop
{
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	CGContextSetGrayStrokeColor(ctx,0,1);
	CGContextMoveToPoint	(ctx,  0 + leftTop.x, prevNextButtonSize/2 + leftTop.y);
	CGContextAddLineToPoint	(ctx, prevNextButtonSize + leftTop.x,  0 + leftTop.y);
	CGContextAddLineToPoint	(ctx, prevNextButtonSize + leftTop.x,  prevNextButtonSize + leftTop.y);
	CGContextAddLineToPoint	(ctx,  0 + leftTop.x,  prevNextButtonSize/2 + leftTop.y);
	CGContextFillPath(ctx);
}

-(void)drawNextButton:(CGPoint)leftTop
{
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	CGContextSetGrayStrokeColor(ctx,0,1);
	CGContextMoveToPoint	(ctx,  0 + leftTop.x,  0 + leftTop.y);
	CGContextAddLineToPoint	(ctx, prevNextButtonSize + leftTop.x,  prevNextButtonSize/2 + leftTop.y);
	CGContextAddLineToPoint	(ctx,  0 + leftTop.x,  prevNextButtonSize + leftTop.y);
	CGContextAddLineToPoint	(ctx,  0 + leftTop.x,  0 + leftTop.y);
	CGContextFillPath(ctx);
}


-(void)drawTopGradientBar{
	[self drawPrevButton:CGPointMake(prevNextButtonSpaceWidth,prevNextButtonSpaceHeight)];
	[self drawNextButton:CGPointMake(self.frame.size.width-prevNextButtonSpaceWidth-prevNextButtonSize,prevNextButtonSpaceHeight)];
}

-(void)drawTopBarWords{
	int width=self.frame.size.width;
	int s_width=width/7;

	NSArray *months=[NSArray arrayWithObjects: @"-", @"January",@"February",
												@"March",@"April",@"May",@"June",@"July",
												@"August",@"September",@"October",@"November",@"December", nil];
	[[UIColor blackColor] set];
	NSString *title_Month   = [[NSString alloc] initWithFormat:@"%@ %d",
							   [months objectAtIndex: currentMonthDate.month],
							   currentMonthDate.year];
	// all this, jst so we can horizontally center the month at the top of the widget.
	int fontsize=[UIFont buttonFontSize];
    UIFont   *font    = [UIFont systemFontOfSize:titleFontSize];
	int textWidth = [title_Month sizeWithFont:font forWidth:width lineBreakMode:UILineBreakModeWordWrap].width;

	CGPoint  location = CGPointMake((width-textWidth)/2, 0);
    [title_Month drawAtPoint:location withFont:font];
	[title_Month release];
		
	UIFont *weekfont=[UIFont boldSystemFontOfSize:weekFontSize];
	
	[[UIColor redColor] set];
	[@"Su" drawAtPoint:CGPointMake(s_width*0+12,fontsize) withFont:weekfont];
	[[UIColor blackColor] set];
	[@"M" drawAtPoint:CGPointMake(s_width*1+13,fontsize) withFont:weekfont];
	[@"Tu" drawAtPoint:CGPointMake(s_width*2+12,fontsize) withFont:weekfont];
	[@"W" drawAtPoint:CGPointMake(s_width*3+13,fontsize) withFont:weekfont];
	[@"Th" drawAtPoint:CGPointMake(s_width*4+12,fontsize) withFont:weekfont];
	[@"F" drawAtPoint:CGPointMake(s_width*5+13,fontsize) withFont:weekfont];
	[[UIColor redColor] set];
	[@"Sa" drawAtPoint:CGPointMake(s_width*6+12,fontsize) withFont:weekfont];
	
	[[UIColor blackColor] set];
	
}

-(void)drawGridLines{
	
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	int width=self.frame.size.width;
	int row_Count=([self getDayCountOfaMonth:currentMonthDate]+[self getMonthWeekday:currentMonthDate]-2)/7+1;

	
	int s_width=width/7;
	int tabHeight=row_Count*itemHeight+headHeight;

	CGContextSetGrayStrokeColor(ctx,0,1);
	CGContextMoveToPoint	(ctx,0,headHeight);
	CGContextAddLineToPoint	(ctx,0,tabHeight);
	CGContextStrokePath		(ctx);
	CGContextMoveToPoint	(ctx,width,headHeight);
	CGContextAddLineToPoint	(ctx,width,tabHeight);
	CGContextStrokePath		(ctx);
	
	for(int i=1;i<7;i++){
		CGContextSetGrayStrokeColor(ctx,1,1);
		CGContextMoveToPoint(ctx, i*s_width, headHeight);
		CGContextAddLineToPoint( ctx, i*s_width,tabHeight);
		CGContextStrokePath(ctx);
	}
	
	for(int i=0;i<row_Count+1;i++){
		CGContextSetGrayStrokeColor(ctx,1,1);
		CGContextMoveToPoint(ctx, 0, i*itemHeight+headHeight+1);
		CGContextAddLineToPoint( ctx, width,i*itemHeight+headHeight+1);
		CGContextStrokePath(ctx);
		
		CGContextSetGrayStrokeColor(ctx,0.3,1);
		CGContextMoveToPoint(ctx, 0, i*itemHeight+headHeight);
		CGContextAddLineToPoint( ctx, width,i*itemHeight+headHeight);
		CGContextStrokePath(ctx);
	}
	for(int i=1;i<7;i++){
		CGContextSetGrayStrokeColor(ctx,0.3,1);
		CGContextMoveToPoint(ctx, i*s_width+1, headHeight);
		CGContextAddLineToPoint( ctx, i*s_width+1,tabHeight);
		CGContextStrokePath(ctx);
	}
}


-(int)getMonthWeekday:(CFGregorianDate)date
{
	CFTimeZoneRef tz = CFTimeZoneCopyDefault();
	CFGregorianDate month_date;
	month_date.year=date.year;
	month_date.month=date.month;
	month_date.day=1;
	month_date.hour=0;
	month_date.minute=0;
	month_date.second=1;
	return (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(month_date,tz),tz);
}

-(void)drawDateWords{
	CGContextRef ctx=UIGraphicsGetCurrentContext();

	int width=self.frame.size.width;
	
	int dayCount=[self getDayCountOfaMonth:currentMonthDate];
	int day=0;
	int x=0;
	int y=0;
	int s_width=width/7;
	int curr_Weekday=[self getMonthWeekday:currentMonthDate];
	UIFont *weekfont=[UIFont boldSystemFontOfSize:12];

	for(int i=1;i<dayCount+1;i++)
	{
		day=i+curr_Weekday-1;
		x=day % 7;
		y=day / 7;
		NSString *date=[[[NSString alloc] initWithFormat:@"%2d",i] autorelease];
		[date drawAtPoint:CGPointMake(x*s_width+15,y*itemHeight+headHeight+10) withFont:weekfont];
		
		CFGregorianDate tmpDate = currentMonthDate;
		tmpDate.day = i;
		// TBD make this into an array of matching events ?
		int retFlag = [self.calendarViewDelegate getDayFlag:tmpDate];
		
		if(retFlag==1)
		{
			CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
			[@"." drawAtPoint:CGPointMake(x*s_width+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:25]];
		}
		else if(retFlag==-1)
		{
			CGContextSetRGBFillColor(ctx, 0, 8.5, 0.3, 1);
			[@"." drawAtPoint:CGPointMake(x*s_width+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:25]];
		}
			
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
	}
}


- (void) movePrevNext:(int)isPrev{
	currentSelectDate.year=0;
	if ([self.calendarViewDelegate respondsToSelector:@selector(beforeMonthChange:willto:)]) {		
		[calendarViewDelegate beforeMonthChange:self willto:currentMonthDate];
	}
	int width=self.frame.size.width;
	int posX;
	if(isPrev==1)
	{
		posX=width;
	}
	else
	{
		posX=-width;
	}
	
	UIImage *viewImage;
	
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];	
	viewImage= UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	if(viewImageView==nil)
	{
		viewImageView=[[UIImageView alloc] initWithImage:viewImage];
		
		viewImageView.center=self.center;
		[[self superview] addSubview:viewImageView];
	}
	else
	{
		viewImageView.image=viewImage;
	}
	
	viewImageView.hidden=NO;
	viewImageView.transform=CGAffineTransformMakeTranslation(0, 0);
	self.hidden=YES;
	[self setNeedsDisplay];
	self.transform=CGAffineTransformMakeTranslation(posX,0);
	
	
	float height;
	int row_Count=([self getDayCountOfaMonth:currentMonthDate]+[self getMonthWeekday:currentMonthDate]-2)/7+1;
	height=row_Count*itemHeight+headHeight;
	self.hidden=NO;
	[UIView beginAnimations:nil	context:nil];
	[UIView setAnimationDuration:0.5];
	self.transform=CGAffineTransformMakeTranslation(0,0);
	viewImageView.transform=CGAffineTransformMakeTranslation(-posX, 0);
	[UIView commitAnimations];
	if ([self.calendarViewDelegate respondsToSelector:@selector(monthChanged:viewLeftTop:height:)]) {
		[calendarViewDelegate monthChanged:currentMonthDate viewLeftTop:self.frame.origin height:height];
	}
}

- (void)movePrevMonth{
	if(currentMonthDate.month>1)
		currentMonthDate.month-=1;
	else
	{
		currentMonthDate.month=12;
		currentMonthDate.year-=1;
	}
	[self movePrevNext:0];
}

- (void)moveNextMonth{
	if(currentMonthDate.month<12)
		currentMonthDate.month+=1;
	else
	{
		currentMonthDate.month=1;
		currentMonthDate.year+=1;
	}
	[self movePrevNext:1];	
}

- (void) drawToday{
	int x;
	int y;
	int day;
	CFGregorianDate today=CFAbsoluteTimeGetGregorianDate(currentTime, CFTimeZoneCopyDefault());
	if(today.month==currentMonthDate.month && today.year==currentMonthDate.year)
	{
		int width=self.frame.size.width;
		int swidth=width/7;
		int weekday=[self getMonthWeekday:currentMonthDate];
		day=today.day+weekday-1;
		x=day%7;
		y=day/7;
		CGContextRef ctx=UIGraphicsGetCurrentContext(); 
		CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0.5, 1);
		CGContextMoveToPoint(ctx, x*swidth+1, y*itemHeight+headHeight);
		CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight);
		CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight+itemHeight);
		CGContextAddLineToPoint(ctx, x*swidth+1, y*itemHeight+headHeight+itemHeight);
		CGContextFillPath(ctx);

		CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
		UIFont *weekfont=[UIFont boldSystemFontOfSize:12];
		NSString *date=[[[NSString alloc] initWithFormat:@"%2d",today.day] autorelease];
		[date drawAtPoint:CGPointMake(x*swidth+15,y*itemHeight+headHeight+10) withFont:weekfont];
		
		int retFlag = [self.calendarViewDelegate getDayFlag:today];

		if(retFlag==1)
		{
			CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
			[@"." drawAtPoint:CGPointMake(x*swidth+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:25]];
		}
		else if(retFlag==-1)
		{
			CGContextSetRGBFillColor(ctx, 0, 8.5, 0.3, 1);
			[@"." drawAtPoint:CGPointMake(x*swidth+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:25]];
		}
		
	}
}

- (void) drawCurrentSelectDate{
	int x;
	int y;
	int day;
	int todayFlag;
	if (currentSelectDate.year!=0)
	{
		CFGregorianDate today=CFAbsoluteTimeGetGregorianDate(currentTime, CFTimeZoneCopyDefault());

		if(today.year==currentSelectDate.year && today.month==currentSelectDate.month && today.day==currentSelectDate.day)
			todayFlag=1;
		else
			todayFlag=0;
		
		int width=self.frame.size.width;
		int swidth=width/7;
		int weekday=[self getMonthWeekday:currentMonthDate];
		day=currentSelectDate.day+weekday-1;
		x=day%7;
		y=day/7;
		CGContextRef ctx=UIGraphicsGetCurrentContext();
		
		if(todayFlag==1)
			CGContextSetRGBFillColor(ctx, 0, 0, 0.7, 1);
		else
			CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
		CGContextMoveToPoint(ctx, x*swidth+1, y*itemHeight+headHeight);
		CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight);
		CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight+itemHeight);
		CGContextAddLineToPoint(ctx, x*swidth+1, y*itemHeight+headHeight+itemHeight);
		CGContextFillPath(ctx);	
		
		if(todayFlag==1)
		{
			CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
			CGContextMoveToPoint	(ctx, x*swidth+4,			y*itemHeight+headHeight+3);
			CGContextAddLineToPoint	(ctx, x*swidth+swidth-1,	y*itemHeight+headHeight+3);
			CGContextAddLineToPoint	(ctx, x*swidth+swidth-1,	y*itemHeight+headHeight+itemHeight-3);
			CGContextAddLineToPoint	(ctx, x*swidth+4,			y*itemHeight+headHeight+itemHeight-3);
			CGContextFillPath(ctx);	
		}
		
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);

		UIFont *weekfont=[UIFont boldSystemFontOfSize:12];
		NSString *date=[[[NSString alloc] initWithFormat:@"%2d",currentSelectDate.day] autorelease];
		[date drawAtPoint:CGPointMake(x*swidth+15,y*itemHeight+headHeight+10) withFont:weekfont];
		
		int retFlag = [self.calendarViewDelegate getDayFlag:today];
		if (retFlag!=0)
		{
			[@"." drawAtPoint:CGPointMake(x*swidth+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:25]];
		}
		
	}
}

- (void) touchAtDate:(CGPoint) touchPoint{
	int x;
	int y;
	int width=self.frame.size.width;
	int weekday=[self getMonthWeekday:currentMonthDate];
	int monthDayCount=[self getDayCountOfaMonth:currentMonthDate];
	x=touchPoint.x*7/width;
	y=(touchPoint.y-headHeight)/itemHeight;
	int monthday=x+y*7-weekday+1;
	if(monthday>0 && monthday<monthDayCount+1)
	{
		currentSelectDate.year=currentMonthDate.year;
		currentSelectDate.month=currentMonthDate.month;
		currentSelectDate.day=monthday;
		currentSelectDate.hour=0;
		currentSelectDate.minute=0;
		currentSelectDate.second=1;
		if ([self.calendarViewDelegate respondsToSelector:@selector(selectDateChanged:)]) {
			[calendarViewDelegate selectDateChanged:currentSelectDate];
		}
		[self setNeedsDisplay];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	int width=self.frame.size.width;
	UITouch* touch=[touches anyObject];
	CGPoint touchPoint=[touch locationInView:self];
	if(touchPoint.x<40 && touchPoint.y<headHeight)
		[self movePrevMonth];
	else if(touchPoint.x>width-40 && touchPoint.y<headHeight)
		[self moveNextMonth];
	else if(touchPoint.y>headHeight)
	{
		[self touchAtDate:touchPoint];
	}
}

- (void)drawRect:(CGRect)rect{

	static int once=0;
	currentTime=CFAbsoluteTimeGetCurrent();
	
	[self drawTopGradientBar];
	[self drawTopBarWords];
	[self drawGridLines];
	
	if(once==0)
	{
		once=1;
		float height;
		int row_Count=([self getDayCountOfaMonth:currentMonthDate]+[self getMonthWeekday:currentMonthDate]-2)/7+1;
		height=row_Count*itemHeight+headHeight;
		if ([self.calendarViewDelegate respondsToSelector:@selector(monthChanged:viewLeftTop:height:)]) {
			[calendarViewDelegate monthChanged:currentMonthDate viewLeftTop:self.frame.origin height:height];
		}
		if ([self.calendarViewDelegate respondsToSelector:@selector(beforeMonthChange:willto:)]) {		
			[calendarViewDelegate beforeMonthChange:self willto:currentMonthDate];
		}
	}
	[self drawDateWords];
	[self drawToday];
	[self drawCurrentSelectDate];
	
}

- (void)dealloc {
    [super dealloc];
	free(monthFlagArray);
}


@end
