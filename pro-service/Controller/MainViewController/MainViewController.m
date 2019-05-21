//
//  MainViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainCollectionViewCell.h"
#import "Calendar.h"
#import "Event.h"

@interface MainViewController ()
{
    CGFloat tabelHeaderViewHeight;
    UIView *sectionSeparator;
    Calendar *calendar;
}

@property (weak, nonatomic) IBOutlet UIView *viewSectionTopRadius;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *statusViewBg;
@property (weak, nonatomic) IBOutlet UIView *tabelHeaderView;
@property (strong, nonatomic) UILabel *tabelHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *tabelHeaderViewContent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionNew;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewSectionTopRadius.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30, 30)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.viewSectionTopRadius.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.viewSectionTopRadius.layer.mask = maskLayer;
    
    tabelHeaderViewHeight = self.tabelHeaderView.frame.size.height;
    self.statusViewBg.backgroundColor = COLOR_MAIN;
    self.tabelHeaderViewContent.backgroundColor = COLOR_MAIN;
    self.tabelHeaderView.backgroundColor = COLOR_MAIN;
    
    self.collectionNew.pagingEnabled = NO;
    self.collectionNew.showsVerticalScrollIndicator = false;
    self.collectionNew.showsHorizontalScrollIndicator = false;
    self.collectionNew.delaysContentTouches = false;
    [self.collectionNew registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCell"];
    
    calendar = [[Calendar alloc] init];
    [calendar loadToday];
}

// MARK: TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return calendar.today.count;
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
    
    Event *event = calendar.today[indexPath.row];
    cell.titleLabel.text = event.title;
    cell.dateLabel.text = [dateFormat stringFromDate:event.created_date];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.tabelHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, width-32, 41)];
    [self.tabelHeaderLabel setFont:[UIFont systemFontOfSize:34 weight:UIFontWeightBold]];
    [self.tabelHeaderLabel setText:@"Сегодня"];
    
    sectionSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width, 0.5)];
    sectionSeparator.backgroundColor = [UIColor lightGrayColor];
    sectionSeparator.alpha = 0;
    
    [view addSubview:self.tabelHeaderLabel];
    [view addSubview:sectionSeparator];
    
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    DLog(@"scrollView: %f", scrollView.contentOffset.y);
    
    CGRect newFrame = self.tabelHeaderViewContent.frame;
    
    CGAffineTransform totalTransform = CGAffineTransformMakeTranslation(0, 0);
    if (scrollView.contentOffset.y < 0)
    {
        newFrame.size.height = tabelHeaderViewHeight-scrollView.contentOffset.y-self.viewSectionTopRadius.frame.size.height;
        newFrame.origin.y = scrollView.contentOffset.y;
        
        CGFloat scale = 1-scrollView.contentOffset.y/2000;
        CGFloat scale2 = 1-scrollView.contentOffset.y/11.5;
        totalTransform = CGAffineTransformTranslate(totalTransform, scale2, 0);
        totalTransform = CGAffineTransformScale(totalTransform, scale, scale);
    }
    else
    {
        newFrame.size.height = tabelHeaderViewHeight-self.viewSectionTopRadius.frame.size.height;
        newFrame.origin.y = 0;
    }
    
    self.tabelHeaderLabel.transform = totalTransform;
    [self.tabelHeaderViewContent setFrame:newFrame];
    
    UIColor *bg = COLOR_MAIN;
    int sAlpha = 0;
    if (scrollView.contentOffset.y > self.tabelHeaderView.frame.size.height-5)
    {
        bg = [UIColor whiteColor];
        sAlpha = 1;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.statusViewBg.backgroundColor = bg;
        self->sectionSeparator.alpha = sAlpha;
    }];
}

// MARK: CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCollectionViewCell" forIndexPath:indexPath];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width-32-50, 150);
}

@end
