//
//  Event.m
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.category = @[
                          @{@"id": @2, @"title": @"Кино", @"imageName": @"emoji_cinema"},
                          @{@"id": @3, @"title": @"Музыка", @"imageName": @"emoji_music"},
                          @{@"id": @4, @"title": @"Музеи, выставки, библиотеки", @"imageName": @"emoji_museum"},
                          @{@"id": @5, @"title": @"Фестивали, массовые гуляния, конкурсы", @"imageName": @"emoji_festival"},
                          @{@"id": @6, @"title": @"Спорт", @"imageName": @"emoji_sport"},
                          @{@"id": @7, @"title": @"Образование", @"imageName": @"emoji_education"},
                          @{@"id": @8, @"title": @"Услуги", @"imageName": @"emoji_amenities"}
                         ];
    }
    return self;
}

- (Event *)dictinaryToEvent:(NSDictionary *)dictinary
{
    Event *event = [[Event alloc] init];
    
    event.idEvent = [dictinary[@"id"] intValue];
    event.price = [dictinary[@"price"] floatValue];
    event.title = dictinary[@"title"];
    event.age_rating = dictinary[@"age_rating"];
    event.main_photo = dictinary[@"main_photo"];
    event.organization_title = dictinary[@"organization_title"];
    event.profile_name = dictinary[@"profile_name"];
    event.profile_surname = dictinary[@"profile_surname"];
    event.rating = [dictinary[@"rating"] floatValue];
    event.category = dictinary[@"tag"];
    event.more_photos = dictinary[@"image"];
    
    if (dictinary[@"description"] == (NSString *)[NSNull null])
    {
        event.description_text = @"";
    }
    else
    {
        event.description_text = dictinary[@"description"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    event.created_date = [dateFormatter dateFromString:dictinary[@"created_date"]];
    event.end_event = [[NSDate alloc] init];

    if (dictinary[@"end_event"] != (NSString *)[NSNull null])
    {
        event.end_event = [dateFormatter dateFromString:dictinary[@"end_event"]];
    }
    
    return event;
}

@end
