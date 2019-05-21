//
//  CategoryViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "Event.h"
#import "EventListViewController.h"

@interface CategoryViewController ()
{
    Event *event;
    NSInteger rowSelectIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    event = [[Event alloc] init];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return event.category.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryTableViewCell";
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = event.category[indexPath.row][@"title"];
    cell.imageViewIcon.image = [UIImage imageNamed:event.category[indexPath.row][@"imageName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    rowSelectIndex = indexPath.row;
    [self performSegueWithIdentifier:@"eventToCategory" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventToCategory"])
    {
        EventListViewController *vc = segue.destinationViewController;
        vc.navTitle = event.category[rowSelectIndex][@"title"];
    }
}

@end
