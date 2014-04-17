#import <UIKit/UIKit.h>
@class KKNaturalValuePicker;

typedef NS_ENUM(NSInteger, KKNaturalValuePickerGridType) {
    KKNaturalValuePickerGridTypeSmall,
    KKNaturalValuePickerGridTypeMiddle,
    KKNaturalValuePickerGridTypeLarge
};

typedef NS_ENUM(NSUInteger, KKNaturalValuePickerLabelType) {
    KKNaturalValuePickerLabelTypeMain,
    KKNaturalValuePickerLabelTypeAssist
};

@protocol KKNaturalValuePickerDelegate <NSObject>

- (void)didSelectRowAtIndex:(NSInteger)index ForPicker:(KKNaturalValuePicker *)picker;
- (NSString *)updateContentForLabelType:(KKNaturalValuePickerLabelType)type AtRowIndex:(NSInteger)index ForPicker:(KKNaturalValuePicker *)picker;
- (UIView *)prepareViewForRowAtIndex:(NSInteger)index IsSelected:(BOOL)selected WithGridType:(KKNaturalValuePickerGridType)type ForPicker:(KKNaturalValuePicker *)picker;

- (void)prepareLayoutArrowView:(UIView*)view WithSelectionRect:(CGRect)selectionRect;
- (void)prepareLayoutTextLabel:(UILabel*)label WithLabelType:(KKNaturalValuePickerLabelType)type WithSelectionRect:(CGRect)selectionRect;
- (void)prepareLayoutActionButton:(UIButton*)actionButton WithSelectionRect:(CGRect)selectionRect;

- (IBAction)onActionButton:(id)sender;

@end

@protocol KKNaturalValuePickerDataSource <NSObject>

- (NSInteger)numberOfRowsInSelector:(KKNaturalValuePicker *)picker;
- (CGFloat)rowHeightInPicker:(KKNaturalValuePicker *)picker;
- (CGFloat)rowWidthInPicker:(KKNaturalValuePicker *)picker;
- (CGRect)rectForSelectionInPicker:(KKNaturalValuePicker *)picker;
- (NSInteger)bigScaleUnitForPicker:(KKNaturalValuePicker *)picker;
- (NSInteger)midScaleUnitForPicker:(KKNaturalValuePicker *)picker;

@end

@interface KKNaturalValuePicker : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<KKNaturalValuePickerDelegate> delegate;
@property (nonatomic, assign) id<KKNaturalValuePickerDataSource> datasource;
@property (nonatomic, assign) BOOL isHorizontalScrolling;
@property (nonatomic, assign) BOOL isDebugEnabled;
@property (nonatomic, assign) BOOL isDeceleratingEnabled;

- (void)setCurrentValue:(NSUInteger)value;

@end
