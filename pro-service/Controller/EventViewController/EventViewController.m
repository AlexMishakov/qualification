//
//  EventViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 23/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "EventViewController.h"

#import "HeaderEventTableViewCell.h"
#import "ImagesEventTableViewCell.h"
#import "FooterEventTableViewCell.h"

@interface EventViewController ()
{
    BOOL checkMorePhotos;
}

@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checkMorePhotos = self.event.more_photos.count != 0;
    
    [self.navigationController.navigationBar setValue:@(NO) forKeyPath:@"hidesShadow"];
    self.navigationController.navigationBar.prefersLargeTitles = false;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger eventCount = checkMorePhotos ? 3 : 2;
    return eventCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"HeaderEventTableViewCell";
        HeaderEventTableViewCell *cell = (HeaderEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd MMMM yyyy в HH:mm";
        
        cell.dateLabel.text = [dateFormatter stringFromDate:self.event.created_date];
        cell.titleLabel.text = self.event.title;
        cell.categoryLabel.text = [self.event.category componentsJoinedByString:@", "];
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@\n\nВозростное ограничение: %@+", self.event.description_text, self.event.age_rating];
        
        NSString *stringUrl = [NSString stringWithFormat:@"%@%@", DOMEN, self.event.main_photo];
        DLog(@"%@", stringUrl);
        NSURL *urlImage = [NSURL URLWithString:stringUrl];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (cell) cell.imageImageView.image = image;
                    });
                }
            }
        }];
        [task resume];
        
        
        return cell;
    }
    
    if (checkMorePhotos)
    {
        if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"ImagesEventTableViewCell";
            ImagesEventTableViewCell *cell = (ImagesEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.images = self.event.more_photos;
            
            return cell;
        }
        else if (indexPath.row == 2 && checkMorePhotos)
        {
            static NSString *CellIdentifier = @"FooterEventTableViewCell";
            FooterEventTableViewCell *cell = (FooterEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.organizationLabel.text = self.event.organization_title;
            
            return cell;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"FooterEventTableViewCell";
        FooterEventTableViewCell *cell = (FooterEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.organizationLabel.text = self.event.organization_title;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    return cell;
}

@end
