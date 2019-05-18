//
//  CalendarViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 16/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"

@interface CalendarViewController () <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;


@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.pagingEnabled = NO;
    self.calendar.firstWeekday = 2;
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    self.calendar.weekdayHeight = 0;
    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ru-RU"];
    self.calendar.headerHeight = 50;
    self.calendar.rowHeight = 50;
    self.calendar.appearance.headerTitleColor = COLOR_MAIN;
    self.calendar.appearance.headerTitleFont = [UIFont boldSystemFontOfSize:20];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:17];
    self.calendar.appearance.selectionColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    self.calendar.appearance.titleSelectionColor = [UIColor blackColor];
    self.calendar.appearance.todayColor = COLOR_MAIN;
    self.calendar.appearance.headerDateFormat = @"MMMM yyyy";
    
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.minimumDate = [NSDate date];
    self.maximumDate = [self.dateFormatter dateFromString:@"2021-04-10"];
}

// MARK: FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}

// MARK: FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DLog(@"did select %@", [self.dateFormatter stringFromDate:date]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.calendar deselectDate:date];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"scrollView: %f", scrollView.contentOffset.y);
}

@end
