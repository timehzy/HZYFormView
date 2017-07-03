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
#import "HZYFormViewCellConfigurator.h"
#import "HZYFormViewSectionHeaderConfigurator.h"

NSString *const HZYFormViewCellValueBeginDateKey = @"HZYFormViewCellValueBeginDateKey";
NSString *const HZYFormViewCellValueEndDateKey = @"HZYFormViewCellValueEndDateKey";
NSString *const HZYFormCellAccessoryView = @"HZYFormCellAccessoryView";

@interface HZYFormView ()
@property (nonatomic, strong) HZYFormViewDataModel *dataModel;
@property (nonatomic, strong) HZYFormVIewCellSubViewCreater *cellSubviewCreater;
@end

@implementation HZYFormView
@dynamic delegate;
#pragma mark - public
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows {
    HZYFormView *view = [[self alloc]initWithFrame:frame rowsCount:-1 sectionRows:sectionRows options:HZYFormViewCellOptions];
    return view;
}

+ (instancetype)formViewWithOption:(HZYFormViewCellOption)option frame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows {
    HZYFormView *view = [[self alloc]initWithFrame:frame rowsCount:-1 sectionRows:sectionRows options:option];
    return view;
}

- (void)configCellForRow:(NSUInteger)row inSection:(NSUInteger)section settings:(void (^)(HZYFormViewCellConfigurator *))setting {
    HZYFormViewCellConfigurator *setter = [[HZYFormViewCellConfigurator alloc] initWithDataModel:self.dataModel forRow:row inSection:section];
    HZYFormViewCellOption originOption = [self.dataModel getCellForRow:row inSection:section].options;
    if (setting) {
        setting(setter);
        HZYFormViewCell *cell = [setter configedCell];
        [self.dataModel replaceCell:cell forRow:row inSection:section];
        if (originOption != cell.options) {
            [self.cellSubviewCreater createCellSubviewsForRow:row inSection:section accessory:nil];
        }
        [self.dataModel setupCellValueForRow:row inSection:section];
        [self reLayout:NO];
    }
}

- (void)configSection:(NSUInteger)section settings:(void (^)(HZYFormViewSectionHeaderConfigurator *))setting {
    HZYFormViewSectionHeaderConfigurator *setter = [[HZYFormViewSectionHeaderConfigurator alloc] initWithDataModel:self.dataModel forSection:section];
    if (setting) {
        setting(setter);
        HZYFormSectionHeaderView *header = [setter configedHeader];
        [self.dataModel replaceHeaderView:header forSection:section];
        [self reLayout:NO];
    }
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    return [self.dataModel getRowCountInSection:section];;
}

- (HZYFormViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    return [self.dataModel getCellForRow:indexPath.row inSection:indexPath.section];
}

- (void)setHeaderView:(UIView *)view forSection:(NSUInteger)section {
    UIView *origin = [self.dataModel getSectionHeaderViewForSection:section];
    CGRect frame = origin.frame;
    frame.size.height = view.bounds.size.height;
    view.frame = frame;
    [self addSubview:view];
    [origin removeFromSuperview];
    [self.dataModel setSectionHeaderView:view.copy forSection:section];
}

- (void)setCustomViewAsCell:(UIView *)view atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(view, @"【HZYFormView Warning】: can't set nil for custom view");
    HZYFormViewCell *cell = [self.dataModel getCellForRow:indexPath.row inSection:indexPath.section];
    view.frame = cell.frame;
    [cell removeFromSuperview];
    [self addSubview:view];
    [self.dataModel setCell:cell forRow:indexPath.row inSection:indexPath.section];
}

- (UIView *)headerViewForSection:(NSUInteger)section {
    [self isIndexPathOutofBounds:[NSIndexPath indexPathForRow:-1 inSection:section]];
    return [self.dataModel getSectionHeaderViewForSection:section];
}

- (void)hide:(BOOL)hidden cellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animate:(BOOL)animate {
    for (NSIndexPath *path in indexPaths) {
        [self.dataModel getCellForRow:path.row inSection:path.section].hidden = hidden;
    }
    [self reLayout:animate];
}

#pragma mark - init & lifeCycle
- (instancetype)initWithFrame:(CGRect)frame rowsCount:(NSInteger)numberOfRow sectionRows:(NSArray<NSNumber *> *)sectionRows options:(HZYFormViewCellOption)option{
    if (self = [super initWithFrame:frame]) {
        [self initVariable:sectionRows];
        [self initDefaultViews:option];
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

#pragma mark - private
- (void)initVariable:(NSArray *)rowCountArray {
    _dataModel = [HZYFormViewDataModel new];
    [_dataModel setSectionRowCount:rowCountArray];
    _cellSubviewCreater = [[HZYFormVIewCellSubViewCreater alloc] initWithDataModel:self.dataModel];
}

- (void)initDefaultViews:(HZYFormViewCellOption)options {
    self.backgroundColor = HZYFormViewDefaultBackgroundColor;
    //headerView
    [self addSubview:self.headerView];
    //用于存放创建好的cell的array
    CGFloat lastCellMaxY = 0 + (self.headerView ? self.headerView.bounds.size.height : 0);
    for (NSInteger i=0; i<[self.dataModel getSectionCount]; i++) {
        //添加section headerView
        [self createSectionHeaderView:HZYFormViewSectionHeaderHeight originY:lastCellMaxY sectionIndex:i];
        lastCellMaxY += HZYFormViewSectionHeaderHeight;
        //添加cell
        for (NSInteger j=0; j<[self.dataModel getRowCountInSection:i]; j++) {
            [self createCell:lastCellMaxY cellHeight:HZYFormViewCellHeight forRow:j inSection:i options:options];
            [self.cellSubviewCreater createCellSubviewsForRow:j inSection:i accessory:nil];
            lastCellMaxY += HZYFormViewCellHeight;
        }
    }
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

- (HZYFormViewCell *)createCell:(CGFloat)cellY cellHeight:(CGFloat)cellHeight forRow:(NSUInteger)row inSection:(NSUInteger)section options:(HZYFormViewCellOption)options{
    HZYFormViewCell *view = [[HZYFormViewCell alloc]initWithFrame:CGRectMake(0, cellY, self.bounds.size.width, cellHeight)];
    view.options = options;
    view.backgroundColor = HZYFormViewCellBackgroundColor;
    __weak typeof(view)weakView = view;
    __weak typeof(self)weakSelf = self;
    view.tapHandler = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(formView:cellDidSelected:indexPath:)]) {
            [weakSelf.delegate formView:weakSelf cellDidSelected:weakView indexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    };
    if (self.autoNext) {
        [self autoNextBecomeFirstResponder:view];
    }
    [self addSubview:view];
    [self.dataModel setCell:view forRow:row inSection:section];
    return view;
}

- (void)createSectionHeaderView:(CGFloat)height originY:(CGFloat)y sectionIndex:(NSUInteger) section {
    HZYFormSectionHeaderView *header = [HZYFormSectionHeaderView new];
    header.frame = CGRectMake(0, y, self.bounds.size.width, height);
    if ([header respondsToSelector:@selector(customLayout)]) {
        [header customLayout];
    }
    [self.dataModel setSectionHeaderView:header forSection:section];
    [self addSubview:header];
}

- (void)reLayout:(BOOL)animate {
    [UIView animateWithDuration:animate ? 0.25 : 0 animations:^{
        CGFloat lastCellMaxY = self.headerView ? self.headerView.bounds.size.height : 0;
        for (NSInteger i=0; i<[self.dataModel getSectionCount]; i++) {
            if ([self.dataModel getSectionHeaderViewForSection:i].hidden) {
                HZYFormSectionHeaderView *header = [self.dataModel getSectionHeaderViewForSection:i];
                header.hidden = YES;
                header.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, 0);
            }else{
                HZYFormSectionHeaderView *header = [self.dataModel getSectionHeaderViewForSection:i];
                header.hidden = NO;
                header.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, header.frame.size.height);
                if ([header respondsToSelector:@selector(customLayout)]) {
                    [header customLayout];
                }
                lastCellMaxY += header.bounds.size.height;
            }
            for (NSInteger j=0; j<[self.dataModel getRowCountInSection:i]; j++) {
                if (![self.dataModel getCellForRow:j inSection:i].hidden) {
                    HZYFormViewCell *cell = [self.dataModel getCellForRow:j inSection:i];
                    cell.hidden = NO;
                    cell.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, cell.frame.size.height);
                    lastCellMaxY += cell.frame.size.height;
                } else {
                    HZYFormViewCell *cell = [self.dataModel getCellForRow:j inSection:i];
                    cell.hidden = YES;
                    cell.frame = CGRectMake(0, lastCellMaxY, self.bounds.size.width, 0);
                }
            }
        }
        self.contentSize = CGSizeMake(self.bounds.size.width, lastCellMaxY);
    }];
}


- (void)isIndexPathOutofBounds:(NSIndexPath *)indexPath {
    NSAssert([self.dataModel getSectionCount] > indexPath.section && [self.dataModel getRowCountInSection:indexPath.section] > indexPath.row, @"row or section index is out of bounds");
}

- (void)autoNextBecomeFirstResponder:(HZYFormViewCell *)view {
    __weak typeof(self)weakSelf = self;
    __weak typeof(view)weakView = view;
    view.nextEditAction = ^{
        if ([[weakSelf getNextCell:weakView] subViewForType:HZYFormViewCellContentInputField]) {
            [[[weakSelf getNextCell:weakView] subViewForType:HZYFormViewCellContentInputField] becomeFirstResponder];
        }else if ([[weakSelf getNextCell:weakView] subViewForType:HZYFormViewCellContentInputView]) {
            [[[weakSelf getNextCell:weakView] subViewForType:HZYFormViewCellContentInputView] becomeFirstResponder];
        }else{
            HZYFormViewCell *cell = [weakSelf getNextCell:weakView];
            while (![[weakSelf getNextCell:cell] subViewForType:HZYFormViewCellContentInputField] && ![[weakSelf getNextCell:cell] subViewForType:HZYFormViewCellContentInputView]) {
                cell = [weakSelf getNextCell:weakView];
            }
            if ([cell subViewForType:HZYFormViewCellContentInputField]) {
                [[cell subViewForType:HZYFormViewCellContentInputField] becomeFirstResponder];
            }else if ([cell subViewForType:HZYFormViewCellContentInputView]) {
                [[cell subViewForType:HZYFormViewCellContentInputView] becomeFirstResponder];
            }
        }
    };
}

- (HZYFormViewCell *)getNextCell:(HZYFormViewCell *)cell {
    NSIndexPath *indexPath = [self.dataModel indexPathOfCell:cell];
    if (indexPath.section >= [self.dataModel getSectionCount]) {
        return nil;
    }
   
    if (indexPath.row >= [self.dataModel getRowCountInSection:indexPath.section] && indexPath.section == [self.dataModel getSectionCount] - 1) {
        return nil;
    }
    if (indexPath.row == [self.dataModel getRowCountInSection:indexPath.section] - 1) {
        return [self.dataModel getCellForRow:0 inSection:indexPath.section + 1];
    }else{
        return [self.dataModel getCellForRow:indexPath.row + 1 inSection:indexPath.section];
    }
    return nil;
}

- (CGFloat)multiPhotoPickerHeightForNumberOfLine:(NSUInteger)lineNum {
    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - 16*2 -3*8) / 4;
    return itemWH*lineNum + 12 + lineNum * 8 + 4 + 28;
}


#pragma mark - notification
- (void)multiPicPickerDidAddImage:(NSNotification *)note {
    NSInteger index = [note.userInfo[HZYFormCellNewAddedImageIndexKey] integerValue];
    if (index == 3) {
        [self.dataModel enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
            if ([cell isEqual:note.object]) {
                CGRect frame = cell.frame;
                frame.size.height = [self multiPhotoPickerHeightForNumberOfLine:2];
                cell.frame = frame;
                [self reLayout:YES];
                return;
            }
        }];
    }
}

- (void)multiPicPickerDidDeletedImage:(NSNotification *)note {
    NSInteger count = [note.userInfo[HZYFormCellDeletedImageRemainCountKey] integerValue];
    if (count == 3) {
        [self.dataModel enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
            if ([cell isEqual:note.object]) {
                CGRect frame = cell.frame;
                frame.size.height = [self multiPhotoPickerHeightForNumberOfLine:1];
                cell.frame = frame;
                [self reLayout:YES];
                return;
            }
        }];
    }
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

- (void)setFooterView:(UIView *)footerView {
    _footerView = footerView;
    CGRect rect = footerView.frame;
    rect.origin.x = 0;
    rect.size.width = self.bounds.size.width;
    _footerView.frame = rect;
}


@end

@implementation HZYFormView (HZYFormViewValue)
- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellAtIndexPath:indexPath];
    return [cell getContentValueForOptions:options];
}

- (NSArray *)getAllValues {
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.dataModel enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        if (row == 0) {
            [tempArray addObject:[NSMutableArray array]];
        }
        [tempArray[section] addObject:[cell getContentValueForOptions:HZYFormViewCellContentInputField]];
        if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentInputView];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentSinglePhotoPicker];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentMultiPhotoPicker];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentSingleSelector];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentMultiSelector];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentDatePickerDefault];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentDatePickerAtoB];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentCitySelector];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentDetail];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentSubDetail];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellContentCheckMark];
        }else if ([tempArray[section][row] isEqual:[NSNull null]]) {
            tempArray[section][row] = [cell getContentValueForOptions:HZYFormViewCellTitleText];
        }
    }];
    return tempArray.copy;
}


- (NSArray<NSIndexPath *> *)checkIsEmpty:(NSArray<NSIndexPath *> *)indexPaths {
    NSMutableArray *tempArr = [NSMutableArray array];
    if (!indexPaths) {
        [self.dataModel enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
            NSString *value = [self getValueFromCellOptions:HZYFormViewCellContentInputField | HZYFormViewCellContentInputView atIndex:[NSIndexPath indexPathForRow:row inSection:section]];
            if (([cell subViewForType:HZYFormViewCellContentInputField] || [cell subViewForType:HZYFormViewCellContentInputView]) &&
                (!value || [value isEqualToString:@""])) {
                [tempArr addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            }
        }];
    }else{
        for (NSIndexPath *path in indexPaths) {
            [self isIndexPathOutofBounds:path];
            HZYFormViewCell *cell = [self.dataModel getCellForRow:path.row inSection:path.section];
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
        HZYFormViewCell *cell = [self.dataModel getCellForRow:indexPath.row inSection:indexPath.section];
        if ([cell subViewForType:HZYFormViewCellContentInputField]) {
            ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).layer.borderColor = HZYFormViewCellAlertBorderColor.CGColor;
        }else if ([cell subViewForType:HZYFormViewCellContentInputView]) {
            ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).layer.borderColor = HZYFormViewCellAlertBorderColor.CGColor;
        }
    }
}

- (void)setTitles:(NSArray *)titles {
    self.dataModel.titles = titles.mutableCopy;
}

- (NSArray *)titles {
    return self.dataModel.titles;
}

- (void)setIcons:(NSArray *)icons {
    self.dataModel.icons = icons.mutableCopy;
}

- (NSArray *)icons {
    return self.dataModel.icons;
}

- (void)setPlaceholders:(NSArray *)placeholders {
    self.dataModel.placeholders = placeholders.mutableCopy;
}

- (NSArray *)placeholders {
    return self.dataModel.placeholders;
}

- (void)setInputTexts:(NSArray *)inputTexts {
    self.dataModel.inputTexts = inputTexts.mutableCopy;
}

- (NSArray *)inputTexts {
    return self.dataModel.inputTexts;
}

- (void)setDetails:(NSArray *)details {
    self.dataModel.details = details.mutableCopy;
}

- (NSArray *)details {
    return self.dataModel.details;
}

- (void)setSubDetails:(NSArray *)subDetails {
    self.dataModel.subDetails = subDetails.mutableCopy;
}

- (NSArray *)subDetails {
    return self.dataModel.subDetails;
}

- (void)setPictures:(NSArray *)pictures {
    self.dataModel.pictures = pictures.mutableCopy;
}

- (NSArray *)pictures {
    return self.dataModel.pictures;
}

- (void)setCheckmarks:(NSArray *)checkmarks {
    self.dataModel.checkmarks = checkmarks.mutableCopy;
}

- (NSArray *)checkmarks {
    return self.dataModel.checkmarks;
}
@end

@implementation HZYFormView (HZYFormViewStyleSetting)
- (void)setInputTextAlignment:(NSTextAlignment)alignment {
    self.dataModel.inputTextAlignment = alignment;
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
