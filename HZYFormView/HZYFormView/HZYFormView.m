//
//  HZYFormView.m
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/4/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormView.h"
#import "HZYFormSectionHeaderView.h"
#import "HZYPicturePickerView.h"
#import "HZYFormViewCell.h"
#import "HZYFormVIewCellSubViewCreater.h"
#import "HZYFormViewDataModel.h"

NSString *const HZYFormViewCellValueBeginDateKey = @"HZYFormViewCellValueBeginDateKey";
NSString *const HZYFormViewCellValueEndDateKey = @"HZYFormViewCellValueEndDateKey";
NSString *const HZYFormCellAccessoryActionButton = @"HZYFormCellAccessoryActionButton";

@interface HZYFormView ()
@property (nonatomic, strong) HZYFormViewDataModel *dataModel;
@property (nonatomic, strong) HZYFormVIewCellSubViewCreater *cellSubviewCreater;

@end

@implementation HZYFormView
@dynamic delegate;

#pragma mark - public
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows {
    HZYFormView *view = [[self alloc]initWithFrame:frame rowsCount:-1 sectionRows:sectionRows];
    return view;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    NSAssert(self.dataModel.sectionRowCountArray.count > section, @"【HZYFormView Warning】: section index should not greater than section count");
    return self.dataModel.sectionRowCountArray[section].integerValue;
}

- (NSArray<HZYFormViewCell *> *)visibleCells {
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataModel.cellArray.count; i++) {
        for (HZYFormViewCell *cell in self.dataModel.cellArray[i]) {
            if (cell.isVisible) {
                [temp addObject:cell];
            }
        }
    }
    return temp.copy;
}

- (HZYFormViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    return self.dataModel.cellArray[indexPath.section][indexPath.row];
}

- (void)hide:(BOOL)hidden Cell:(NSArray *)sectionRowArray animate:(BOOL)animate{
    for (NSInteger i=0; i<sectionRowArray.count; i++) {
        for (NSInteger j=0; j<[sectionRowArray[i] count]; j++) {
            self.dataModel.cellHideArray[i][[sectionRowArray[i][j] integerValue]] = [NSNumber numberWithBool:hidden];
        }
    }
    [self reLayout:animate];
}

- (void)setCellOptions:(HZYFormViewCellOption)options forRowsAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        NSAssert(self.dataModel.sectionRowCountArray.count > indexPath.section, @"【HZYFormView Warning】:section index can not greater than section count");
        NSAssert(self.dataModel.sectionRowCountArray[indexPath.section].integerValue > indexPath.row, @"【HZYFormView Warning】:row index can not greater than row count");
        [self changeFrameWithOptions:[NSNumber numberWithInteger:options] forRow:indexPath.row inSection:indexPath.section];
    }
}

- (void)setCellAccessory:(NSDictionary *)dict atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataModel.sectionRowCountArray.count > indexPath.section && self.dataModel.sectionRowCountArray[indexPath.section].integerValue > indexPath.row) {
        HZYFormButton *btn = [dict objectForKey:HZYFormCellAccessoryActionButton];
        if (btn) {
            [self.dataModel.cellAccessoryArray[indexPath.section][indexPath.row] setObject:btn forKey:HZYFormCellAccessoryActionButton];
            [self reCreateCellAtIndexPath:indexPath];
        }
    }
}

- (void)setCellHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath animate:(BOOL)animate {
    if (!indexPath) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            for (NSInteger j=0; i<self.dataModel.sectionRowCountArray[i].integerValue; j++) {
                self.dataModel.sectionRowHeightArray[i][j] = [NSNumber numberWithFloat:height];
            }
        }
    } else if (indexPath.row == -1) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray[indexPath.section].integerValue; i++) {
            self.dataModel.sectionRowHeightArray[indexPath.section][i] = [NSNumber numberWithFloat:height];
        }
    } else {
        self.dataModel.sectionRowHeightArray[indexPath.section][indexPath.row] = [NSNumber numberWithFloat:height];
    }
    [self reLayout:animate];
}

- (void)setHeaderHeight:(CGFloat)height forSection:(NSArray<NSNumber *> *)section {
    if (!section || section.count == 0) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            self.dataModel.sectionHeaderHeightArray[i] = [NSNumber numberWithFloat:height];
        }
    } else {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            for (NSNumber *sectionIndex in section) {
                if (sectionIndex.integerValue == i) {
                    self.dataModel.sectionHeaderHeightArray[i] = [NSNumber numberWithFloat:height];
                }
            }
        }
    }
    [self reLayout:YES];
}

- (void)setHeaderTitle:(NSString *)title content:(NSString *)content forSection:(NSUInteger)section {
    if (section < self.dataModel.sectionRowCountArray.count) {
        ((HZYFormSectionHeaderView *)self.dataModel.sectionHeaderViewArray[section]).titleLabel.text = title;
        ((HZYFormSectionHeaderView *)self.dataModel.sectionHeaderViewArray[section]).contentLable.text = content;
    }
}

- (void)setHeaderView:(UIView *)view forSection:(NSArray<NSNumber *> *)section {
    for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
        if (!section || section.count == 0 || section[i].integerValue == i) {
            view.frame = [self.dataModel.sectionHeaderViewArray[i] frame];
            [self.dataModel.sectionHeaderViewArray[i] removeFromSuperview];
            [self addSubview:view];
            self.dataModel.sectionHeaderViewArray[i] = view;
        }
    }
}

- (void)setCustomViewAsCell:(HZYFormViewCell *)view atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(view, @"【HZYFormView Warning】: can't set nil for custom view");
    HZYFormViewCell *cell = self.dataModel.cellArray[indexPath.section][indexPath.row];
    view.frame = cell.frame;
    [cell removeFromSuperview];
    [self addSubview:view];
    self.dataModel.cellArray[indexPath.section][indexPath.row] = view;
}

- (UIView *)headerViewForSection:(NSUInteger)section {
    NSAssert(self.dataModel.sectionHeaderViewArray.count > section, @"【HZYFormView Warning】: section header view index must less than section header view count");
    return self.dataModel.sectionHeaderViewArray[section];
}

- (void)setContentValue:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellAtIndexPath:indexPath];
    [cell setContentValue:value forOptions:options];
}

- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellAtIndexPath:indexPath];
    return [cell getContentValueForOptions:options];
}

- (void)setInputEnable:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    [self getInputView:indexPath].userInteractionEnabled = enable;
}

- (void)setKeyboardType:(UIKeyboardType)type atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    [self getInputView:indexPath].keyboardType = type;
}

- (NSArray<NSIndexPath *> *)checkIsEmpty:(NSArray<NSIndexPath *> *)indexPaths {
    NSMutableArray *tempArr = [NSMutableArray array];
    if (!indexPaths) {
        for (NSInteger i=0; i<self.dataModel.cellArray.count; i++) {
            for (NSInteger j=0; j<[self.dataModel.cellArray[i] count]; j++) {
                HZYFormViewCell *cell = self.dataModel.cellArray[i][j];
                NSString *value = [self getValueFromCellOptions:HZYFormViewCellContentInputField | HZYFormViewCellContentInputView atIndex:[NSIndexPath indexPathForRow:j inSection:i]];
                if (([cell subViewForType:HZYFormViewCellContentInputField] || [cell subViewForType:HZYFormViewCellContentInputView]) &&
                    (!value || [value isEqualToString:@""])) {
                        [tempArr addObject:[NSIndexPath indexPathForRow:j inSection:i]];
                    }
            }
        }
    }else{        
        for (NSIndexPath *path in indexPaths) {
            NSAssert(self.dataModel.cellArray.count > path.section && [self.dataModel.cellArray[path.row] count], @"indexpath out of bounds");
            HZYFormViewCell *cell = self.dataModel.cellArray[path.section][path.row];
            NSString *value = [self getValueFromCellOptions:HZYFormViewCellContentInputField | HZYFormViewCellContentInputView atIndex:path];
            if (([cell subViewForType:HZYFormViewCellContentInputField] || [cell subViewForType:HZYFormViewCellContentInputView]) &&
                (!value || [value isEqualToString:@""])) {
                    [tempArr addObject:path];
                }
        }
    }
    return tempArr.copy;
}

- (void)setCellInputEmptyAlert:(NSArray<NSIndexPath *> *)rows {
    for (NSIndexPath *indexPath in rows) {
        HZYFormViewCell *cell = self.dataModel.cellArray[indexPath.section][indexPath.row];
        if ([cell subViewForType:HZYFormViewCellContentInputField]) {
            ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).layer.borderColor = [UIColor redColor].CGColor;
        }else if ([cell subViewForType:HZYFormViewCellContentInputView]) {
            ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).layer.borderColor = [UIColor redColor].CGColor;
        }
    }
}

#pragma mark - private
- (instancetype)initWithFrame:(CGRect)frame rowsCount:(NSInteger)numberOfRow sectionRows:(NSArray<NSNumber *> *)sectionRows{
    if (self = [super initWithFrame:frame]) {
        _dataModel.sectionRowCountArray = sectionRows;
        [self initVariable];
        [self initDefaultViews];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(multiPicPickerDidAddImage:) name:HZYFormCellImageDidAddedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(multiPicPickerDidDeletedImage:) name:HZYFormCellImageDidDeletedNotification object:nil];
    }
    return self;
}

- (instancetype)init {
    NSAssert(0, @"use formViewWithFrame: to create HZYFormView");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(0, @"use formViewWithFrame: to create HZYFormView");
    return nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// 动画用
- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    CGFloat up = contentOffset.y + 64;
    CGFloat down = up + self.bounds.size.height - 64;
    for (NSInteger i=0; i<self.dataModel.cellArray.count; i++) {
        for (HZYFormViewCell *cell in self.dataModel.cellArray[i]) {
            if ((cell.frame.origin.y > up && CGRectGetMaxY(cell.frame) < down) || (cell.frame.origin.y < up && CGRectGetMaxY(cell.frame) > up) || (CGRectGetMaxY(cell.frame) > down && cell.frame.origin.y < down)) {
                cell.visible = YES;
            }else{
                cell.visible = NO;
            }
        }
    }
}

// 动画用
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
//    NSArray *cells = [self visibleCells];
//    for (NSInteger i=0; i<cells.count; i++) {
//        HZYFormViewCell *cell = cells[i];
//        cell.transform = CGAffineTransformMakeTranslation(375, 0);
//        [UIView animateWithDuration:.45 delay:10 + i*0.03 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            cell.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//    NSLog(@"a");
}

- (void)isIndexPathOutofBounds:(NSIndexPath *)indexPath {
    NSAssert(self.dataModel.sectionRowCountArray.count > indexPath.section && self.dataModel.sectionRowCountArray[indexPath.section].integerValue > indexPath.row, @"row or section index is out of bounds");
}

- (HZYFormInputView *)getInputView:(NSIndexPath *)indexPath {
    HZYFormInputView *inputView = (HZYFormInputView *)[[self cellAtIndexPath:indexPath]subViewForType:HZYFormViewCellContentInputView];
    if (!inputView) {
        inputView = (HZYFormInputView *)[[self cellAtIndexPath:indexPath]subViewForType:HZYFormViewCellContentInputField];
    }
    NSAssert(inputView, @"no inputView or inputField in cell");
    return inputView;
}
#pragma mark - notification
- (void)multiPicPickerDidAddImage:(NSNotification *)note {
    NSInteger index = [note.userInfo[HZYFormCellNewAddedImageIndexKey] integerValue];
    if (index == 3) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            for (NSInteger j=0; j<self.dataModel.sectionRowCountArray[i].integerValue; j++) {
                if (self.dataModel.cellArray[i][j] == note.object) {
                    self.dataModel.sectionRowHeightArray[i][j] = [NSNumber numberWithFloat:185];
                    [self reLayout:YES];
                }
            }
        }
    }
}

- (void)multiPicPickerDidDeletedImage:(NSNotification *)note {
    NSInteger count = [note.userInfo[HZYFormCellDeletedImageRemainCountKey] integerValue];
    if (count == 3) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            for (NSInteger j=0; j<self.dataModel.sectionRowCountArray[i].integerValue; j++) {
                if (self.dataModel.cellArray[i][j] == note.object) {
                    self.dataModel.sectionRowHeightArray[i][j] = [NSNumber numberWithFloat:100];
                    [self reLayout:YES];
                }
            }
        }
    }
}

- (void)initVariable {
    _dataModel = [HZYFormViewDataModel new];
    _cellSubviewCreater = [[HZYFormVIewCellSubViewCreater alloc] initWithDataModel:self.dataModel];
}

- (void)initDefaultViews {
    //headerView
    [self addSubview:self.headerView];
    //用于存放创建好的cell的array
    NSMutableArray *tempArr = [NSMutableArray array];
    
    CGFloat lastCellMaxY = 0 + (self.headerView ? self.headerView.bounds.size.height : 0), cellHeight = 0;
    for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
        [tempArr addObject:[NSMutableArray array]];
        //添加section headerView
        [self createSectionHeaderView:self.dataModel.sectionHeaderHeightArray[i].floatValue originY:lastCellMaxY sectionIndex:i];
        //添加cell
        for (NSInteger j=0; j<self.dataModel.sectionRowCountArray[i].integerValue; j++) {
            if (j == 0) {
                lastCellMaxY += self.dataModel.sectionHeaderHeightArray[i].floatValue;
            }
            cellHeight = ((NSNumber *)self.dataModel.sectionRowHeightArray[i][j]).floatValue;
            HZYFormViewCell *view = [self createCell:lastCellMaxY cellHeight:cellHeight withSperatLine:j != self.dataModel.sectionRowCountArray[i].integerValue - 1 isSectionLast:self.dataModel.sectionRowCountArray[i].integerValue - 1 == j];
            view = [self.cellSubviewCreater createCellSubviews:view atSection:i row:j];
            __weak typeof(view)weakView = view;
            __weak typeof(self)weakSelf = self;
            view.tapHandler = ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(formView:cellDidSelected:indexPath:)]) {
                    [weakSelf.delegate formView:weakSelf cellDidSelected:weakView indexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                }
            };
            lastCellMaxY += cellHeight;
            [tempArr[i] addObject:view];
        }
    }
    
    self.dataModel.cellArray = tempArr;
    //footerView
    if (self.footerView) {
        CGRect rect = self.footerView.frame;
        rect.origin.y = lastCellMaxY;
        self.footerView.frame = rect;
        [self addSubview:self.footerView];
        lastCellMaxY += self.footerView.bounds.size.height;
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, lastCellMaxY);
}

- (void)createSectionHeaderView:(CGFloat)height originY:(CGFloat)y sectionIndex:(NSUInteger) section {
    HZYFormSectionHeaderView *header = self.dataModel.sectionHeaderViewArray[section];
    header.frame = CGRectMake(0, y, self.bounds.size.width, height);
    if ([header respondsToSelector:@selector(customLayout)]) {
        [header customLayout];
    }
    [self addSubview:header];
}

- (void)reLayout:(BOOL)animate {
    NSAssert(self.dataModel.cellArray.count > 0, @"no cell to layout");
    [UIView animateWithDuration:animate ? 0.25 : 0 animations:^{
        CGFloat lastCellMaxY = self.headerView ? self.headerView.bounds.size.height : 0;
        for (NSInteger i=0; i<self.dataModel.cellArray.count; i++) {
            for (NSInteger j=0; j<[self.dataModel.cellArray[i] count]; j++) {
                if (!((NSNumber *)self.dataModel.cellHideArray[i][j]).boolValue) {
                    if (j == 0) {
                        HZYFormSectionHeaderView *header = self.dataModel.sectionHeaderViewArray[i];
                        header.hidden = NO;
                        header.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, self.dataModel.sectionHeaderHeightArray[i].floatValue);
                        if ([header respondsToSelector:@selector(customLayout)]) {
                            [header customLayout];
                        }
                        lastCellMaxY += header.bounds.size.height;
                    }
                    HZYFormViewCell *cell = self.dataModel.cellArray[i][j];
                    cell.hidden = NO;
                    cell.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, [self.dataModel.sectionRowHeightArray[i][j] floatValue]);
                    lastCellMaxY += cell.frame.size.height;
                } else {
                    if (j == 0) {
                        HZYFormSectionHeaderView *header = self.dataModel.sectionHeaderViewArray[i];
                        header.hidden = YES;
                        header.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, 0);
                    }
                    HZYFormViewCell *cell = self.dataModel.cellArray[i][j];
                    cell.hidden = YES;
                    cell.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, 0);
                }
            }
        }
        self.contentSize = CGSizeMake(self.bounds.size.width, lastCellMaxY);
    }];
}

- (HZYFormViewCell *)createCell:(CGFloat)cellY cellHeight:(CGFloat)cellHeight withSperatLine:(BOOL)hasSep isSectionLast:(BOOL)isSectionLast{
    HZYFormViewCell *view = [[HZYFormViewCell alloc]initWithFrame:CGRectMake(0, cellY, self.bounds.size.width, cellHeight)];
    view.shouldShowAnimation = self.cellShowAnimation;
    view.backgroundColor = [UIColor whiteColor];
    if (hasSep && !isSectionLast) {
        CALayer *sep = [CALayer layer];
        UIEdgeInsets insets = self.dataModel.cellSeperatorInsets;
        sep.frame = CGRectMake(isSectionLast ? 0 : insets.left, cellHeight - (insets.bottom + 0.5), view.bounds.size.width - insets.left - insets.right, 0.5);
        sep.backgroundColor = self.dataModel.cellSeperatorColor.CGColor;
        [view.layer addSublayer:sep];
    }
    [self addSubview:view];
    return view;
}

- (void)changeFrameWithOptions:(NSNumber *)option forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.dataModel.optionsArray[section][row] = option;
    if (option.integerValue & HZYFormViewCellContentSinglePhotoPicker) {
        self.dataModel.sectionRowHeightArray[section][row] = [NSNumber numberWithFloat:166];
    }else if (option.integerValue & HZYFormViewCellContentInputView) {
        self.dataModel.sectionRowHeightArray[section][row] = [NSNumber numberWithFloat:120];
    }else if (option.integerValue & HZYFormViewCellContentMultiPhotoPicker) {
        self.dataModel.sectionRowHeightArray[section][row] = [NSNumber numberWithFloat:100];
    }
    [self reCreateCellAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    [self reLayout:YES];
}

- (void)reCreateCellAtIndexPath:(NSIndexPath *)indexPath {
    //重新创建这个cell
    HZYFormViewCell *cell = self.dataModel.cellArray[indexPath.section][indexPath.row];
    cell = [self createCell:cell.frame.origin.y cellHeight:[self.dataModel.sectionRowHeightArray[indexPath.section][indexPath.row] floatValue] withSperatLine:YES isSectionLast:indexPath.row == [self.dataModel.cellArray[indexPath.section] count] - 1];
    self.dataModel.cellArray[indexPath.section][indexPath.row] = [self.cellSubviewCreater createCellSubviews:cell atSection:indexPath.section row:indexPath.row];
}

#pragma mark - setter

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    CGRect rect = headerView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = self.bounds.size.width;
    _headerView.frame = rect;
}

- (void)setCellShowAnimation:(BOOL)cellShowAnimation {
    if (cellShowAnimation == _cellShowAnimation) {
        return;
    }
    _cellShowAnimation = cellShowAnimation;
    self.bounces = !cellShowAnimation;
}

- (void)setFooterView:(UIView *)footerView {
    _footerView = footerView;
    CGRect rect = footerView.frame;
    rect.origin.x = 0;
    rect.size.width = self.bounds.size.width;
    _footerView.frame = rect;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles.copy;
    self.dataModel.titles = titles;
}

- (void)setPlaceholders:(NSArray *)placeholders {
    _placeholders = placeholders.copy;
    self.dataModel.placeholders = placeholders;
}

- (void)setInputTexts:(NSArray *)inputTexts {
    _inputTexts = inputTexts.copy;
    self.dataModel.inputTexts = inputTexts;
}

- (void)setDetails:(NSArray *)details {
    _details = details.copy;
    self.dataModel.details = details;
}

- (void)setSubDetails:(NSArray *)subDetails {
    _subDetails = subDetails.copy;
    self.dataModel.subDetails = subDetails;
}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures.copy;
    self.dataModel.pictures = pictures;
}

- (void)setCheckmarks:(NSArray *)checkmarks {
    _checkmarks = checkmarks.copy;
    self.dataModel.checkmarks = checkmarks;
}

- (void)setCellBackgroundColor:(UIColor *)color {
    self.dataModel.cellBackgroundColor = color;
}

- (void)setCellSeperatorColor:(UIColor *)color {
    self.dataModel.cellSeperatorColor = color;
}

- (void)setCellSeperatorInsets:(UIEdgeInsets)insets {
    self.dataModel.cellSeperatorInsets = insets;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.dataModel.titleFont = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.dataModel.titleColor = titleColor;
}

- (void)setInputFieldFont:(UIFont *)inputFieldFont {
    self.dataModel.inputFieldFont = inputFieldFont;
}

- (void)setInputFieldTextColor:(UIColor *)inputFieldTextColor {
    self.dataModel.inputFieldTextColor = inputFieldTextColor;
}

- (void)setInputViewFont:(UIFont *)inputViewFont {
    self.dataModel.inputViewFont = inputViewFont;
}

- (void)setInputViewTextColor:(UIColor *)inputViewTextColor {
    self.dataModel.inputViewTextColor = inputViewTextColor;
}

- (void)setDetailFont:(UIFont *)detailFont {
    self.dataModel.detailFont = detailFont;
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    self.dataModel.detailTextColor = detailTextColor;
}

- (void)setSubDetailFont:(UIFont *)subDetailFont {
    self.dataModel.subDetailFont = subDetailFont;
}

- (void)setSubDetailTextColor:(UIColor *)subDetailTextColor {
    self.dataModel.subDetailTextColor = subDetailTextColor;
}
@end

