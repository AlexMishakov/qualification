//
//  SearchCategoryViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 21/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "SearchCategoryViewController.h"
#import "CategoryTableViewCell.h"
@import  SPStorkController;

@interface SearchCategoryViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *categoryArray;
}

@end

@implementation SearchCategoryViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.modalPresentationCapturesStatusBarAppearance = true;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, self.view.frame.size.width-32, 27)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    titleLabel.text = @"Категории";
    
    UILabel *discripationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 59, self.view.frame.size.width-32, 20)];
    discripationLabel.text = @"Выберите одну или несколько категорий";
    discripationLabel.textColor = [UIColor darkGrayColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = false;
    tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    tableView.tableFooterView = [[UIView alloc] init];
    
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:discripationLabel];
    [self.view addSubview:tableView];
    
    categoryArray = @[
                      @{@"title": @"Кино", @"imageName": @"emoji_cinema"},
                      @{@"title": @"Музыка", @"imageName": @"emoji_music"},
                      @{@"title": @"Музеи, выставки, библиотеки", @"imageName": @"emoji_museum"},
                      @{@"title": @"Фестивали, массовые гуляния, конкурсы", @"imageName": @"emoji_festival"},
                      @{@"title": @"Спорт", @"imageName": @"emoji_sport"},
                      @{@"title": @"Образование", @"imageName": @"emoji_education"},
                      @{@"title": @"Услуги", @"imageName": @"emoji_amenities"}
                      ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryArray.count;
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
    
    cell.titleLabel.text = categoryArray[indexPath.row][@"title"];
    cell.imageViewIcon.image = [UIImage imageNamed:categoryArray[indexPath.row][@"imageName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

// TODO: close model view when tabel scroll
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //SPStorkController.scrollViewDidScroll(scrollView) //swift
//    [SPStorkController scrollViewDidScroll:scrollView];
//}

@end
