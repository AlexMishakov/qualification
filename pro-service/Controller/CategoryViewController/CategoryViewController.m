//
//  CategoryViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"

@interface CategoryViewController ()
{
    NSArray *categoryArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categoryArray = @[
                          @{@"title": @"Кино", @"imageName": @"emoji_cinema"},
                          @{@"title": @"Музыка", @"imageName": @"emoji_music"},
                          @{@"title": @"Музеи, выставки, библиотеки", @"imageName": @"emoji_museum"},
                          @{@"title": @"Фестивали, массовые гуляния, конкурсы", @"imageName": @"emoji_festival"},
                          @{@"title": @"Спорт", @"imageName": @"emoji_sport"},
                          @{@"title": @"Образование", @"imageName": @"emoji_education"},
                          @{@"title": @"Услуги", @"imageName": @"emoji_amenities"}
                      ];
    
    self.tableView.tableFooterView = [UIView new];
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

@end
