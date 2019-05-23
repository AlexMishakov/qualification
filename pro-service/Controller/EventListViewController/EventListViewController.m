//
//  EventListViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "EventListViewController.h"
#import "MainTableViewCell.h"
#import "Calendar.h"
#import "Event.h"
#import "EventViewController.h"
#import "PlugEventTableViewCell.h"

@interface EventListViewController ()
{
    NSInteger selectRow;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.navTitle;
    
    [self.navigationController.navigationBar setValue:@(NO) forKeyPath:@"hidesShadow"];
    self.navigationController.navigationBar.prefersLargeTitles = !self.navPrefersLargeTitles;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.prefersLargeTitles = !self.navPrefersLargeTitles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.arrayEvent.count == 0) ? 1 : self.arrayEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayEvent.count == 0)
    {
        static NSString *CellIdentifier = @"PlugEventTableViewCell";
        PlugEventTableViewCell *cell = (PlugEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"MainTableViewCell";
        MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        
        Event *event = self.arrayEvent[indexPath.row];
        cell.titleLabel.text = event.title;
        cell.dateLabel.text = [dateFormat stringFromDate:event.created_date];
        cell.catagoryLabel.text = [event.category componentsJoinedByString:@", "];
        
        NSString *stringUrl = [NSString stringWithFormat:@"%@%@", DOMEN, event.main_photo];
        DLog(@"%@", stringUrl);
        NSURL *urlImage = [NSURL URLWithString:stringUrl];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (cell) cell.image.image = image;
                    });
                }
            }
        }];
        [task resume];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayEvent.count != 0)
    {
        selectRow = indexPath.row;
        [self performSegueWithIdentifier:@"selectEvent" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectEvent"])
    {
        EventViewController *vc = segue.destinationViewController;
        vc.event = self.arrayEvent[selectRow];
    }
}

@end
