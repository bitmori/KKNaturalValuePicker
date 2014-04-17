#import "KKNaturalValuePicker.h"
#import <QuartzCore/QuartzCore.h>

@interface KKNaturalValuePicker()

@property (strong, nonatomic) UIView * arrowView;
@property (strong, nonatomic) UILabel * textLabelMain;
@property (strong, nonatomic) UILabel * textLabelAssist;
@property (strong, nonatomic) UIButton * actionButton;
@property (assign, nonatomic) NSInteger bigScale;
@property (assign, nonatomic) NSInteger midScale;

@end

@implementation KKNaturalValuePicker {
    UITableView *m_contentTableView;
    CGRect m_selectionRect;
    NSIndexPath *m_selectedIndexPath;

    BOOL m_is_scrolling;
    NSInteger m_rowCount;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.isHorizontalScrolling = NO;
    self.isDebugEnabled = NO;
    self.isDeceleratingEnabled = YES;
    m_selectedIndexPath = nil;
    m_is_scrolling = NO;
}

- (void)layoutSubviews {
    self.bigScale = [self.datasource bigScaleUnitForPicker:self];
    self.midScale = [self.datasource midScaleUnitForPicker:self];
    if (nil == m_contentTableView) {
        [self createContentTableView];
    }
    if (nil == self.arrowView) {
        self.arrowView = [[UIView alloc] initWithFrame:m_selectionRect];
        [self.delegate prepareLayoutArrowView:self.arrowView WithSelectionRect:m_selectionRect];
        [self addSubview:self.arrowView];
    }
    if (nil == self.textLabelMain) {
        self.textLabelMain = [[UILabel alloc] init];
        [self.delegate prepareLayoutTextLabel:self.textLabelMain WithLabelType:KKNaturalValuePickerLabelTypeMain WithSelectionRect:m_selectionRect];
        [self addSubview:self.textLabelMain];
    }
    if (nil == self.textLabelAssist) {
        self.textLabelAssist = [[UILabel alloc] init];
        [self.delegate prepareLayoutTextLabel:self.textLabelAssist WithLabelType:KKNaturalValuePickerLabelTypeAssist WithSelectionRect:m_selectionRect];
        [self addSubview:self.textLabelAssist];
    }
    if (nil == self.actionButton) {
        self.actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.delegate prepareLayoutActionButton:self.actionButton WithSelectionRect:m_selectionRect];
        [self.actionButton addTarget:self action:@selector(onActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.actionButton];
    }
    [super layoutSubviews];
}

- (IBAction)onActionButton:(id)sender
{
    if (m_is_scrolling == NO) {
        [self.delegate onActionButton:sender];
    }
}

- (void)setCurrentValue:(NSUInteger)value
{
    [self selectRowAtIndex:value animated:YES];
}

- (void)selectRowAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    m_selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [m_contentTableView scrollToRowAtIndexPath:m_selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    [self.delegate didSelectRowAtIndex:m_selectedIndexPath.row ForPicker:self];
    [m_contentTableView reloadData];
}

- (void)selectRowAtIndex:(NSUInteger)index
{
    [self selectRowAtIndex:index animated:YES];
}

- (void)createContentTableView {
    m_selectionRect = [self.datasource rectForSelectionInPicker:self];

    if (self.isHorizontalScrolling) {
        //In this case user might have created a view larger than taller
        m_contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.width)];
    }
    else {
        m_contentTableView = [[UITableView alloc] initWithFrame:self.bounds];
    }
    
    if (self.isDebugEnabled) {
        m_contentTableView.layer.borderColor = [UIColor blueColor].CGColor;
        m_contentTableView.layer.borderWidth = 1.0;
        m_contentTableView.layer.cornerRadius = 10.0;
        
        m_contentTableView.tableHeaderView.layer.borderColor = [UIColor blackColor].CGColor;
        m_contentTableView.tableFooterView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    
    // Initialization code
//    CGFloat OffsetCreated;
    
    //If this is an horizontal scrolling we have to rotate the table view
    if (self.isHorizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
        m_contentTableView.transform = rotateTable;
        
//        OffsetCreated = _contentTableView.frame.origin.x;
        m_contentTableView.frame = self.bounds;
    }
    
    m_contentTableView.backgroundColor = [UIColor clearColor];
    m_contentTableView.delegate = self;
    m_contentTableView.dataSource = self;
    m_contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.isHorizontalScrolling) {
        m_contentTableView.rowHeight = [self.datasource rowWidthInPicker:self];
    }
    else {
        m_contentTableView.rowHeight = [self.datasource rowHeightInPicker:self];
    }
    
    if (self.isHorizontalScrolling) {
        m_contentTableView.contentInset = UIEdgeInsetsMake( m_selectionRect.origin.x,  0,m_contentTableView.frame.size.width - m_selectionRect.origin.x - m_selectionRect.size.width , 0);
        //- 2 * OffsetCreated, dont know the reason why we need to fix the inset;
    }
    else {
        m_contentTableView.contentInset = UIEdgeInsetsMake( m_selectionRect.origin.y, 0, m_contentTableView.frame.size.height - m_selectionRect.origin.y - m_selectionRect.size.height , 0);
    }
    m_contentTableView.showsVerticalScrollIndicator = NO;
    m_contentTableView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:m_contentTableView];
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    m_rowCount = [self.datasource numberOfRowsInSelector:self];
    return m_rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *contentSubviews = [cell.contentView subviews];
    //We the content view already has a subview we just replace it, no need to add it again
    //hopefully ARC will do the rest and release the old retained view
    if ([contentSubviews count] >0 ) {
        UIView *contentSubV = [contentSubviews objectAtIndex:0];
        
        //This will release the previous contentSubV
        [contentSubV removeFromSuperview];
        NSUInteger idx = indexPath.row;
        BOOL selected = (idx == m_selectedIndexPath.row);
        BOOL isBigGrid = (idx % self.bigScale) == 0;
        BOOL isMidGrid = (idx % self.midScale) == 0;
        
        KKNaturalValuePickerGridType gridType;
        if (isBigGrid) {
            gridType = KKNaturalValuePickerGridTypeLarge;
        } else if (isMidGrid) {
            gridType = KKNaturalValuePickerGridTypeMiddle;
        } else {
            gridType = KKNaturalValuePickerGridTypeSmall;
        }
        
        UIView *viewToAdd = nil;
        if ([self.delegate respondsToSelector:@selector(prepareViewForRowAtIndex:IsSelected:WithGridType:ForPicker:)]) {
            viewToAdd = [self.delegate prepareViewForRowAtIndex:idx IsSelected:selected WithGridType:gridType ForPicker:self];
        } else {
            viewToAdd = [self.delegate prepareViewForRowAtIndex:idx IsSelected:NO WithGridType:gridType ForPicker:self];
        }

        contentSubV = viewToAdd;
        
        if (self.isDebugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        
        [cell.contentView addSubview:contentSubV];
    }
    else {
        NSUInteger idx = indexPath.row;
        BOOL selected = (idx == m_selectedIndexPath.row);
        BOOL isBigGrid = (idx % self.bigScale) == 0;
        BOOL isMidGrid = (idx % self.midScale) == 0;
        
        KKNaturalValuePickerGridType gridType;
        if (isBigGrid) {
            gridType = KKNaturalValuePickerGridTypeLarge;
        } else if (isMidGrid) {
            gridType = KKNaturalValuePickerGridTypeMiddle;
        } else {
            gridType = KKNaturalValuePickerGridTypeSmall;
        }
        
        UIView *viewToAdd = nil;
        if ([self.delegate respondsToSelector:@selector(prepareViewForRowAtIndex:IsSelected:WithGridType:ForPicker:)]) {
            viewToAdd = [self.delegate prepareViewForRowAtIndex:idx IsSelected:selected WithGridType:gridType ForPicker:self];
        } else {
            viewToAdd = [self.delegate prepareViewForRowAtIndex:idx IsSelected:NO WithGridType:gridType ForPicker:self];
        }

        //This is a new cell so we just have to add the view
        if (self.isDebugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [cell.contentView addSubview:viewToAdd];
    }
    
    if (self.isDebugEnabled) {
        cell.layer.borderColor = [UIColor greenColor].CGColor;
        cell.layer.borderWidth = 1.0;
    }
    
    if (self.isHorizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
        cell.transform = rotateTable;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == m_contentTableView) {
        m_selectedIndexPath = indexPath;
        [m_contentTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate didSelectRowAtIndex:indexPath.row ForPicker:self];
        [m_contentTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isDeceleratingEnabled) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (!self.isDeceleratingEnabled) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    m_is_scrolling = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger old_value;
    CGRect selectionRectConverted = [self convertRect:m_selectionRect toView:m_contentTableView];
    NSArray *indexPathArray = [m_contentTableView indexPathsForRowsInRect:selectionRectConverted];
    NSIndexPath* path = indexPathArray.firstObject;
    if (old_value != path.row && !(path.row == 0 && old_value > m_rowCount/2))
    {
        old_value = path.row;
        [self.textLabelMain setText:[self.delegate updateContentForLabelType:KKNaturalValuePickerLabelTypeMain AtRowIndex:path.row ForPicker:self]];
        [self.textLabelAssist setText:[self.delegate updateContentForLabelType:KKNaturalValuePickerLabelTypeAssist AtRowIndex:path.row ForPicker:self]];
    }
}

- (void)scrollToTheSelectedCell
{
    CGRect selectionRectConverted = [self convertRect:m_selectionRect toView:m_contentTableView];
    NSArray *indexPathArray = [m_contentTableView indexPathsForRowsInRect:selectionRectConverted];
    
    __block CGFloat intersectionHeight = 0.0;

    [indexPathArray enumerateObjectsUsingBlock:^(NSIndexPath* index, NSUInteger it, BOOL *stop) {
        //looping through the closest cells to get the closest one
        // fast enumeration
        UITableViewCell *cell = [m_contentTableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
        
        if (intersectedRect.size.height >= intersectionHeight) {
            m_selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }];
    
    if (nil != m_selectedIndexPath) {
        //As soon as we elected an indexpath we just have to scroll to it
        [m_contentTableView scrollToRowAtIndexPath:m_selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate didSelectRowAtIndex:m_selectedIndexPath.row ForPicker:self];
        [m_contentTableView reloadData];
    }
    m_is_scrolling = NO;
}

- (void)reloadData {
    [m_contentTableView reloadData];
}




@end
