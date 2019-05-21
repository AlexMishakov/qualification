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

@end
