//
//  KKViewController.m
//  NaturalValuePicker
//
//  Created by Ke Yang on 4/17/14.
//  Copyright (c) 2014 Pyrus. All rights reserved.
//

#import "KKVerticalPickerViewController.h"
#import "KKNaturalValuePicker.h"

@interface KKVerticalPickerViewController () <KKNaturalValuePickerDelegate, KKNaturalValuePickerDataSource>

@property (weak, nonatomic) IBOutlet KKNaturalValuePicker *pickerView;
@property (assign, nonatomic) CGFloat rowHeight;

@end

@implementation KKVerticalPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rowHeight = 12.0;
    [self.pickerView setDelegate:self];
    [self.pickerView setDatasource:self];
}

#pragma  mark - delegate
- (void)didSelectRowAtIndex:(NSInteger)index ForPicker:(KKNaturalValuePicker *)picker
{
}

- (NSString *)updateContentForLabelType:(KKNaturalValuePickerLabelType)type AtRowIndex:(NSInteger)index ForPicker:(KKNaturalValuePicker *)picker
{
    NSInteger totalInch = 96-index+12;
    switch (type) {
        case KKNaturalValuePickerLabelTypeMain:
            return [NSString stringWithFormat:@"%ld ft", totalInch/12];
        case KKNaturalValuePickerLabelTypeAssist:
            return [NSString stringWithFormat:@"%ld in", totalInch - (totalInch/12)*12];
    }
}

- (UIView *)prepareViewForRowAtIndex:(NSInteger)index IsSelected:(BOOL)selected WithGridType:(KKNaturalValuePickerGridType)type ForPicker:(KKNaturalValuePicker *)picker
{
    //Inch is the total number of inches
    NSInteger inch = 96-index;
    
    CGFloat width = 70;
    CGFloat rowHeight = self.rowHeight;
    
    UIView * cell = [[UIView alloc] initWithFrame:CGRectMake(picker.frame.size.width-width, 0, width, rowHeight)];
    cell.backgroundColor = [UIColor clearColor];
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f].CGColor;
    
    switch (type) {
        case KKNaturalValuePickerGridTypeLarge:
        {
            sublayer.backgroundColor = [UIColor cyanColor].CGColor;
            sublayer.frame = CGRectMake(width-64, (rowHeight-2)/2, 64, 2);
            cell.clipsToBounds = NO;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(width-62, rowHeight/2+4, width, rowHeight)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%d",(int)inch/12+1];
            label.textAlignment =  NSTextAlignmentLeft;
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
            sublayer.frame = CGRectMake(width-22, (rowHeight-2)/2, 22, 2);
        }
        break;
        case KKNaturalValuePickerGridTypeSmall:
        {
            sublayer.frame = CGRectMake(width-12, (rowHeight-2)/2, 12, 2);
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
    CGFloat x_pos = selectionRect.size.width/2 + 30;
    sublayer.frame = CGRectMake(x_pos, (selectionRect.size.height-2)/2, selectionRect.size.width-x_pos, 2);
    [view.layer insertSublayer:sublayer atIndex:0];
}

- (void)prepareLayoutTextLabel:(UILabel*)label WithLabelType:(KKNaturalValuePickerLabelType)type WithSelectionRect:(CGRect)selectionRect
{
    CGFloat x_pos = selectionRect.size.width/2 + 30-100;
    switch (type) {
        case KKNaturalValuePickerLabelTypeMain:
        {
            CGRect rect = CGRectMake(x_pos-10, selectionRect.origin.y-20, 50, 50);
            // TODO: if app does not work properly, it might because this method is not effective
            [label setFrame:rect];
            [label setText:@"9 ft"];
        }
        break;
        case KKNaturalValuePickerLabelTypeAssist:
        {
            CGRect rect = CGRectMake(x_pos-10+50, selectionRect.origin.y-20, 50, 50);
            [label setFrame:rect];
            [label setText:@"0 in"];
        }
        break;
    }
    [label setTextAlignment:NSTextAlignmentRight];
}

- (void)prepareLayoutActionButton:(UIButton*)actionButton WithSelectionRect:(CGRect)selectionRect
{
    [actionButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [actionButton setFrame:CGRectMake(self.pickerView.frame.size.width/2-50, self.pickerView.frame.size.height-80, 100.0, 40.0)];
    [actionButton setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)onActionButton:(id)sender
{
    [self.pickerView setCurrentValue:20];
}

#pragma mark - datasource
- (NSInteger)numberOfRowsInSelector:(KKNaturalValuePicker *)picker
{
    return 97;
}
- (CGFloat)rowHeightInPicker:(KKNaturalValuePicker *)picker
{
    return self.rowHeight;
}

- (CGFloat)rowWidthInPicker:(KKNaturalValuePicker *)picker
{
    return 0.0;
}

- (CGRect)rectForSelectionInPicker:(KKNaturalValuePicker *)picker
{
    return CGRectMake(0, picker.frame.size.height/2, picker.frame.size.width, self.rowHeight);
}

- (NSInteger)bigScaleUnitForPicker:(KKNaturalValuePicker *)picker
{
    return 12;
}

- (NSInteger)midScaleUnitForPicker:(KKNaturalValuePicker *)picker
{
    return 6;
}

@end
