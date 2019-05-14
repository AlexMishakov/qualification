//
//  MainViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 14/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"

@interface MainViewController ()
{
    CGFloat tabelHeaderViewHeight;
    UIView *sectionSeparator;
}

@property (weak, nonatomic) IBOutlet UIView *viewSectionTopRadius;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *statusViewBg;
@property (weak, nonatomic) IBOutlet UIView *tabelHeaderView;
@property (weak, nonatomic) IBOutlet UIView *tabelHeaderViewContent;

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
    
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tabelHeaderViewHeight = self.tabelHeaderView.frame.size.height;
    
    self.statusViewBg.backgroundColor = [UIColor colorWithRed:1.000 green:0.388 blue:0.388 alpha:1.00];
    self.tabelHeaderViewContent.backgroundColor = [UIColor colorWithRed:1.000 green:0.388 blue:0.388 alpha:1.00];
    self.tabelHeaderView.backgroundColor = [UIColor colorWithRed:1.000 green:0.388 blue:0.388 alpha:1.00];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
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
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, width-32, 41)];
    [label setFont:[UIFont systemFontOfSize:34 weight:UIFontWeightBold]];
    [label setText:@"Сегодня"];
    
    sectionSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width, 0.5)];
    sectionSeparator.backgroundColor = [UIColor lightGrayColor];
    sectionSeparator.alpha = 0;
    
    [view addSubview:label];
    [view addSubview:sectionSeparator];
    
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView: %f", scrollView.contentOffset.y);
    
    CGRect newFrame = self.tabelHeaderViewContent.frame;
    
    if (scrollView.contentOffset.y < 0)
    {
        newFrame.size.height = tabelHeaderViewHeight-scrollView.contentOffset.y-self.viewSectionTopRadius.frame.size.height;
        newFrame.origin.y = scrollView.contentOffset.y;
    }
    else
    {
        newFrame.size.height = tabelHeaderViewHeight-self.viewSectionTopRadius.frame.size.height;
        newFrame.origin.y = 0;
    }
    
    [self.tabelHeaderViewContent setFrame:newFrame];
    
    UIColor *bg = [UIColor colorWithRed:1.000 green:0.388 blue:0.388 alpha:1.00];
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

@end
