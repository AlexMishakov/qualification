//
//  SearchViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 19/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "DateViewController.h"
@import SPStorkController;

@interface SearchViewController () <UISearchBarDelegate, UISearchResultsUpdating>
{
    NSArray *cellArray;
}

@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellArray = @[@"Категория", @"Дата", @"Бесплатные"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.tintColor = COLOR_MAIN;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchController.searchBar.placeholder = @"События";
    self.definesPresentationContext = YES;
    
    self.navigationItem.searchController = self.searchController;
    self.navigationController.navigationBar.prefersLargeTitles = true;
    
    self.navigationItem.hidesSearchBarWhenScrolling = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.hidesSearchBarWhenScrolling = true;
    });
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
}

// MARK: SearchController

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    DLog(@"searchController: %@", searchController.searchBar.text);
}

- (void)searchBar:(UISearchBar * _Nonnull)searchBar
{
    DLog(@"searchBar: %@", searchBar.text);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    [theSearchBar setShowsCancelButton:NO animated:YES];

    DLog(@"Test");
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar setShowsCancelButton:YES animated:YES];
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
//}

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
        
    }
    else if (indexPath.row == 1)
    {
        DateViewController *modal = [[DateViewController alloc] init];
        SPStorkTransitioningDelegate *transitionDelegate = [[SPStorkTransitioningDelegate alloc] init];
        
        modal.transitioningDelegate = transitionDelegate;
        modal.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:modal animated:true completion:nil];
    }
}

@end
