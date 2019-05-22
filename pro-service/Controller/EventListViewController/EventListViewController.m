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

@interface EventListViewController ()
{
//    Calendar *calendar;
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
    return self.arrayEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"selectEvent" sender:nil];
}

@end
