//
//  Calendar.m
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "Calendar.h"
#import "Event.h"

@implementation Calendar

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.today = [[NSArray alloc] init];
    }
    return self;
}

- (void)loadToday
{
    NSString *StrUrl = @"/event.get?today=true";
    StrUrl = [DOMEN stringByAppendingString: StrUrl];
    DLog(@"StrUrl: %@", StrUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:StrUrl]];
    NSError *error = nil;
    NSDictionary *dictionary = nil;
    
    if (data != nil)
    {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    
    if ([dictionary[@"error"] intValue] == 910 && dictionary != nil)
    {
        DLog(@"events: %@", dictionary[@"events"]);
        NSArray *arrayEventResponse = dictionary[@"events"];
        NSMutableArray *arrayEvent = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < arrayEventResponse.count; i++)
        {
            NSDictionary *row = arrayEventResponse[i];
            Event *event = [[Event alloc] init];
            event = [event dictinaryToEvent:row];
            [arrayEvent addObject:event];
        }
        
        self.today = [arrayEvent copy];
        DLog(@"self.today: %@", self.today);
        
    }
    else
    {
        self.today = [[NSArray alloc] init];
    }
}

- (void)loadAllDay
{
    NSString *StrUrl = @"/event.getAllDate";
    StrUrl = [DOMEN stringByAppendingString: StrUrl];
    DLog(@"StrUrl: %@", StrUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:StrUrl]];
    NSError *error = nil;
    NSDictionary *dictionary = nil;
    
    if (data != nil)
    {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    
    if ([dictionary[@"error"] intValue] == 910 && dictionary != nil)
    {
        DLog(@"events: %@", dictionary[@"events"]);
        self.allDay = dictionary[@"events"];
        
    }
    else
    {
        self.allDay = [[NSArray alloc] init];
    }
}

- (void)loadFromDate:(NSDate *)date
{
    [self searchTag:nil date:date free:nil text:nil];
}

- (void)loadTag:(NSArray *)tags
{
    [self searchTag:tags date:nil free:nil text:nil];
}

- (void)searchTag:(nullable NSArray *)tags date:(nullable NSDate *)date free:(BOOL)free text:(nullable NSString *)text
{
    NSString *StrUrl = @"/event.get?";
    NSString *freeString = free ? @"true" : @"false";
    StrUrl = [NSString stringWithFormat:@"%@free=%@", StrUrl, freeString];
    
    if (tags.count != 0 && tags != nil)
    {
        StrUrl = [NSString stringWithFormat:@"%@&tag=%@", StrUrl, [tags componentsJoinedByString:@","]];
    }
    
    if (date != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        StrUrl = [NSString stringWithFormat:@"%@&date=%@", StrUrl, [dateFormatter stringFromDate:date]];
    }
    
    if (text != nil && ![text  isEqual: @""])
    {
        DLog(@"text no nil");
    }
    
    StrUrl = [DOMEN stringByAppendingString: StrUrl];
    DLog(@"StrUrl: %@", StrUrl);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:StrUrl]];
    NSError *error = nil;
    NSDictionary *dictionary = nil;

    if (data != nil)
    {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }

    if ([dictionary[@"error"] intValue] == 910 && dictionary != nil)
    {
        DLog(@"events: %@", dictionary[@"events"]);
        NSArray *arrayEventResponse = dictionary[@"events"];
        NSMutableArray *arrayEvent = [[NSMutableArray alloc] init];

        for (int i = 0; i < arrayEventResponse.count; i++)
        {
            NSDictionary *row = arrayEventResponse[i];
            Event *event = [[Event alloc] init];
            event = [event dictinaryToEvent:row];
            [arrayEvent addObject:event];
        }

        self.today = [arrayEvent copy];
        DLog(@"self.today: %@", self.today);
    }
    else
    {
        self.today = [[NSArray alloc] init];
    }
}

@end
