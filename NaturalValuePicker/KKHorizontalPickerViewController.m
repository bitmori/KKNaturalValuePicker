//
//  KKHorizontalPickerViewController.m
//  NaturalValuePicker
//
//  Created by Ke Yang on 4/17/14.
//  Copyright (c) 2014 Pyrus. All rights reserved.
//

#import "KKHorizontalPickerViewController.h"
#import "KKNaturalValuePicker.h"

@interface KKHorizontalPickerViewController () <KKNaturalValuePickerDelegate, KKNaturalValuePickerDataSource>

@property (weak, nonatomic) IBOutlet KKNaturalValuePicker *pickerView;
@property (assign, nonatomic) CGFloat rowWidth;

@end

@implementation KKHorizontalPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rowWidth = 10.0;
    self.pickerView.isHorizontalScrolling = YES;
    [self.pickerView setDelegate:self];
    [self.pickerView setDatasource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - delegate
- (void)didSelectRowAtIndex:(NSInteger)index ForPicker:(KKNaturalValuePicker *)picker
{
}

- (NSString *)updateContentForLabelType:(KKNaturalValuePickerLabelType)type AtRowIndex:(NSInteger)index ForPicker:(KKNaturalValuePicker *)picker
{
    NSInteger lb = index+10;
    return [NSString stringWithFormat:@"%ld lb", lb];
}

- (UIView *)prepareViewForRowAtIndex:(NSInteger)index IsSelected:(BOOL)selected WithGridType:(KKNaturalValuePickerGridType)type ForPicker:(KKNaturalValuePicker *)picker
{
    NSInteger lb = index+10;
    
    CGFloat rowWidth = self.rowWidth;
    
    CGFloat y_pos = picker.frame.size.height/2;
    
    UIView * cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rowWidth, picker.frame.size.height)];
    cell.backgroundColor = [UIColor clearColor];
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f].CGColor;
    
    switch (type) {
        case KKNaturalValuePickerGridTypeLarge:
        {
            sublayer.backgroundColor = [UIColor cyanColor].CGColor;
            sublayer.frame = CGRectMake((rowWidth-2)/2, y_pos, 2, 36);
            cell.clipsToBounds = NO;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(-10, y_pos+40, rowWidth+20, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%ld",lb];
            label.textAlignment =  NSTextAlignmentCenter;
            if (selected) {
                label.textColor = [UIColor redColor];
            } else {
                label.textColor = [UIColor blackColor];
            }
            [cell addSubview:label];
        }
            break;
        case KKNaturalValuePickerGridTypeMiddle:
        {
            sublayer.frame = CGRectMake((rowWidth-2)/2, y_pos, 2, 22);
        }
            break;
        case KKNaturalValuePickerGridTypeSmall:
        {
            sublayer.frame = CGRectMake((rowWidth-2)/2, y_pos, 2, 12);
        }
            break;
    }
    
    [cell.layer addSublayer:sublayer];
    return cell;
}

- (void)prepareLayoutArrowView:(UIView*)view WithSelectionRect:(CGRect)selectionRect
{
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor orangeColor].CGColor;
    CGFloat y_pos = selectionRect.size.height/2 - 80;
    sublayer.frame = CGRectMake((selectionRect.size.width-2)/2, y_pos, 2, selectionRect.size.height-y_pos);
    
    [view.layer insertSublayer:sublayer atIndex:0];
}

- (void)prepareLayoutTextLabel:(UILabel*)label WithLabelType:(KKNaturalValuePickerLabelType)type WithSelectionRect:(CGRect)selectionRect
{
//    CGFloat x_pos = selectionRect.size.width/2 + 30-100;
    switch (type) {
        case KKNaturalValuePickerLabelTypeMain:
        {
            CGRect rect = CGRectMake(0, selectionRect.size.height/2 - 130, self.pickerView.frame.size.width, 50);
            [label setFrame:rect];
            [label setText:@"10 lb"];
        }
            break;
        case KKNaturalValuePickerLabelTypeAssist:
            break;
    }
    [label setTextAlignment:NSTextAlignmentCenter];
}

- (void)prepareLayoutActionButton:(UIButton*)actionButton WithSelectionRect:(CGRect)selectionRect
{
    [actionButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [actionButton setFrame:CGRectMake(self.pickerView.frame.size.width/2-50, self.pickerView.frame.size.height-80, 100.0, 40.0)];
    [actionButton setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)onActionButton:(id)sender
{
    NSLog(@"Action button pressed");
}

#pragma mark - datasource
- (NSInteger)numberOfRowsInSelector:(KKNaturalValuePicker *)picker
{
    return 501;
}

- (CGFloat)rowHeightInPicker:(KKNaturalValuePicker *)picker
{
    return 0.0;
}

- (CGFloat)rowWidthInPicker:(KKNaturalValuePicker *)picker
{
    return self.rowWidth;
}

- (CGRect)rectForSelectionInPicker:(KKNaturalValuePicker *)picker
{
    return CGRectMake((picker.frame.size.width-self.rowWidth)/2, 0, self.rowWidth, picker.frame.size.height);
}

- (NSInteger)bigScaleUnitForPicker:(KKNaturalValuePicker *)picker
{
    return 10;
}

- (NSInteger)midScaleUnitForPicker:(KKNaturalValuePicker *)picker
{
    return 5;
}


@end
