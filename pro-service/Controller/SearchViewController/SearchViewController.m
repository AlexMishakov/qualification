//
//  SearchViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 19/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SearchCategoryViewController.h"
#import "DateViewController.h"
#import "EventListViewController.h"
#import "Calendar.h"
@import SPStorkController;

@interface SearchViewController () <UISearchBarDelegate>
{
    NSArray *cellArray;
    Calendar *calendar;
    NSDate *selectDate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    calendar = [[Calendar alloc] init];
    cellArray = @[@"Категория", @"Дата", @"Бесплатные"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCategory:) name:@"setCategory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDate:) name:@"setDate" object:nil];
}

// при выходе с контроллера очищаются все поля
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setCategorySearch"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCategory" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setDate" object:nil];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    SearchTableViewCell *cell = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.searchBar.text = @"";
}

- (void)setCategory:(NSNotification *)notification
{
    NSMutableArray *categoryTitle = [[NSMutableArray alloc] init];
    NSDictionary *dict = [notification object];
    NSArray *keys = [dict allKeys];
    
    for (int i = 0; i < keys.count; i++)
    {
        [categoryTitle addObject:dict[keys[i]]];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SearchTableViewCell *cell = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.supLabel.hidden = false;
    cell.supLabel.text = [categoryTitle componentsJoinedByString:@", "];
    
    DLog(@"%@", [notification object]);
}

- (void)setDate:(NSNotification *)notification
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    selectDate = [dateFormatter dateFromString:[notification object]];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"dd MMMM yyyy";
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    SearchTableViewCell *cell = (SearchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.supLabel.hidden = false;
    cell.supLabel.text = [dateFormatter2 stringFromDate:selectDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
    self.navigationController.navigationBar.prefersLargeTitles = true;
}

// MARK: SearchController

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    [theSearchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

// MARK: Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTableViewCell";
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = cellArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        SearchCategoryViewController *modal = [[SearchCategoryViewController alloc] init];
        SPStorkTransitioningDelegate *transitionDelegate = [[SPStorkTransitioningDelegate alloc] init];
        
        modal.transitioningDelegate = transitionDelegate;
        modal.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:modal animated:true completion:nil];
    }
    else if (indexPath.row == 1)
    {
        DateViewController *modal = [[DateViewController alloc] init];
        SPStorkTransitioningDelegate *transitionDelegate = [[SPStorkTransitioningDelegate alloc] init];
        
        modal.transitioningDelegate = transitionDelegate;
        modal.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:modal animated:true completion:nil];
    }
    else if (indexPath.row == 2)
    {
        SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

- (IBAction)selectSearch:(id)sender
{
    [self performSegueWithIdentifier:@"eventToSearch" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventToSearch"])
    {
        EventListViewController *vc = segue.destinationViewController;
        
        [calendar searchTag:nil date:nil free:nil text:nil];
        
        vc.navPrefersLargeTitles = true;
    }
}

@end
