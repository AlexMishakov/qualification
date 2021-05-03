//
//  DateViewController.m
//  pro-service
//
//  Created by Александр Мишаков on 20/05/2019.
//  Copyright © 2019 Александр Мишаков. All rights reserved.
//

#import "DateViewController.h"
#import "Calendar.h"

@interface DateViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *datePicker;
    Calendar *calendar;
    NSInteger selectedRow;
}

@property (weak, nonatomic) UIView *wrapContent;

@end

@implementation DateViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    calendar = [[Calendar alloc] init];
    [calendar loadAllDay];
    
    self.modalPresentationCapturesStatusBarAppearance = true;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *viewsToRemove = [self.view subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        [self crateViews];
    });
}

- (void)crateViews
{
    UIView *wrapContent = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-349, self.view.frame.size.width, 349)];
    wrapContent.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:wrapContent];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:wrapContent.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = wrapContent.bounds;
    maskLayer.path = maskPath.CGPath;
    
    wrapContent.layer.mask = maskLayer;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, self.view.frame.size.width-32, 27)];
    titleLabel.text = @"Выберите дату";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    
    datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 216)];
    datePicker.delegate = self;
    datePicker.dataSource = self;
    [datePicker selectRow:0 inComponent:0 animated:YES];
    
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 259, self.view.frame.size.width-32, 42)];
    selectButton.backgroundColor = [UIColor redColor];
    selectButton.backgroundColor = COLOR_LIGHT_MAIN;
    selectButton.layer.cornerRadius = 8;
    [selectButton setTitle:@"Выбрать" forState:UIControlStateNormal];
    [selectButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium]];
    [selectButton addTarget:self action:@selector(buttonTouchSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-25-16, 16, 25, 25)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"clouse-button"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonTouchExit:) forControlEvents:UIControlEventTouchUpInside];
    
    [wrapContent addSubview:titleLabel];
    [wrapContent addSubview:datePicker];
    [wrapContent addSubview:selectButton];
    [wrapContent addSubview:closeButton];
}

- (void)buttonTouchExit:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonTouchSelect:(UIButton *)button
{
    DLog(@"%ld", (long)selectedRow);
    
    NSString *setText = @"";
    if(selectedRow != 0)
    {
        setText = calendar.allDay[selectedRow-1];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setDate" object:setText];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return calendar.allDay.count+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
    {
        return @"Не выбрано";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:calendar.allDay[row-1]];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        dateFormatter2.dateFormat = @"dd MMMM yyyy";
        
        return [dateFormatter2 stringFromDate:date];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}


@end
