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

@end

@implementation HZYFormView
@dynamic delegate;

#pragma mark - public
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows {
    HZYFormView *view = [[self alloc]initWithFrame:frame rowsCount:-1 sectionRows:sectionRows];
    return view;
}

- (void)configComplete {
    CGFloat height = [self createCells];
    self.contentSize = CGSizeMake(self.bounds.size.width, height);
}

- (void)refresh {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self configComplete];
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

- (HZYFormViewCell *)cellForRow:(NSUInteger)row inSection:(NSUInteger)section {
    [self isIndexPathOutofBounds:[NSIndexPath indexPathForRow:row inSection:section]];
    return self.dataModel.cellArray[section][row];
}

- (void)hide:(BOOL)hidden Cell:(NSArray *)sectionRowArray animate:(BOOL)animate{
    for (NSInteger i=0; i<sectionRowArray.count; i++) {
        for (NSInteger j=0; j<[sectionRowArray[i] count]; j++) {
            self.dataModel.cellHideArray[i][[sectionRowArray[i][j] integerValue]] = [NSNumber numberWithBool:hidden];
        }
    }
    [self reLayout:animate];
}

- (void)setCellContent:(HZYFormViewCellOption)contentOption property:(NSString *)property value:(id)value InSectionsRow:(NSArray *)sectionRowArray {
    for (NSInteger i=0; i<sectionRowArray.count; i++) {
        for (NSInteger j=0; j<[sectionRowArray[i] count]; j++) {
            NSInteger section = [sectionRowArray[i][j] integerValue];
            if (contentOption & HZYFormViewCellContentInputField) {
                HZYFormInputField *inputField = (HZYFormInputField *)[[self cellForRow:section inSection:i] subViewForType:HZYFormViewCellContentInputField];
                [inputField setValue:value forKey:property];
            }
            if (contentOption & HZYFormViewCellContentSinglePhotoPicker) {
                HZYFormImageView *imageView = (HZYFormImageView *)[[self cellForRow:section inSection:i] subViewForType:HZYFormViewCellContentSinglePhotoPicker];
                [imageView setValue:value forKey:property];
            }
        }
    }
}

- (void)setCellOptions:(HZYFormViewCellOption)options forRows:(NSArray<NSNumber *> *)rows inSections:(NSArray<NSNumber *> *)sections {
    if (!sections) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            for (NSInteger j=0; j<self.dataModel.sectionRowCountArray[i].integerValue; j++) {
                [self changeFrameWithOptions:[NSNumber numberWithInteger:options] forRow:j inSection:i];
            }
        }
    }else{
        for (NSInteger i=0; i<sections.count; i++) {
            for (NSInteger j=0; j<self.dataModel.sectionRowCountArray[sections[i].integerValue].integerValue; j++) {
                if (!rows) {
                    [self changeFrameWithOptions:[NSNumber numberWithInteger:options] forRow:j inSection:sections[i].integerValue];
                } else {
                    for (NSNumber *rowIndex in rows) {
                        if (rowIndex.integerValue == j) {
                            [self changeFrameWithOptions:[NSNumber numberWithUnsignedLongLong:options] forRow:j inSection:sections[i].integerValue];
                        }
                    }
                }
            }
        }        
    }
}

- (void)setCellOptions:(HZYFormViewCellOption)options forRowsAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        NSAssert(self.dataModel.sectionRowCountArray.count > indexPath.section, @"【HZYFormView Warning】:section index can not greater than section count");
        NSAssert(self.dataModel.sectionRowCountArray[indexPath.section].integerValue > indexPath.row, @"【HZYFormView Warning】:row index can not greater than row count");
        [self changeFrameWithOptions:[NSNumber numberWithInteger:options] forRow:indexPath.row inSection:indexPath.section];
    }
}

- (void)setCellAccessory:(NSDictionary *)dict forRow:(NSUInteger)row inSection:(NSUInteger)section {
    if (self.dataModel.sectionRowCountArray.count > section && self.dataModel.sectionRowCountArray[section].integerValue > row) {
        HZYFormButton *btn = [dict objectForKey:HZYFormCellAccessoryActionButton];
        if (btn) {
            [self.dataModel.cellAccessoryArray[section][row] setObject:btn forKey:HZYFormCellAccessoryActionButton];
        }
    }
}

- (void)setHeight:(CGFloat)height forRow:(NSUInteger)row inSection:(NSUInteger)section animate:(BOOL)animate {
    if (section == -1) {
        self.cellHeight = height;
    } else if (row == -1) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray[section].integerValue; i++) {
            self.dataModel.sectionRowHeightArray[section][i] = [NSNumber numberWithFloat:height];
        }
    } else {
        self.dataModel.sectionRowHeightArray[section][row] = [NSNumber numberWithFloat:height];
    }
    if (self.dataModel.cellArray.count > 0) {
        [self reLayout:animate];
    }
}

- (void)setHeaderHeight:(CGFloat)height forSection:(NSArray<NSNumber *> *)section {
    if (!section) {
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
}

- (void)setHeaderTitle:(NSString *)title content:(NSString *)content forSection:(NSUInteger)section {
    if (section < self.dataModel.sectionRowCountArray.count) {
        ((HZYFormSectionHeaderView *)self.dataModel.sectionHeaderViewArray[section]).titleLabel.text = title;
        ((HZYFormSectionHeaderView *)self.dataModel.sectionHeaderViewArray[section]).contentLable.text = content;
    }
}

- (void)setHeaderView:(UIView *)view forSection:(NSArray<NSNumber *> *)section {
    if (!section) {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            self.dataModel.sectionHeaderViewArray[i] = view.copy;
        }
    } else {
        for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
            if (section[i].integerValue == i) {
                self.dataModel.sectionHeaderViewArray[i] = view.copy;
            }
        }
    }
}

- (void)setCustomView:(HZYFormViewCell *)view forRow:(NSUInteger)row inSection:(NSUInteger)section {
    NSAssert(view, @"【HZYFormView Warning】: can't set nil for custom view");
    NSAssert([view isKindOfClass:[HZYFormViewCell class]], @"自定义view必须是HZYFormViewCell的子类");
    [self.dataModel.customCellDictionary setObject:view forKey:[NSString stringWithFormat:@"r:%zd,s:%zd", row, section]];
    self.dataModel.allCellTypeArray[section][row] = @"c";
}

- (UIView *)headerViewForSection:(NSUInteger)section {
    NSAssert(self.dataModel.sectionHeaderViewArray.count > section, @"【HZYFormView Warning】: section header view index must less than section header view count");
    return self.dataModel.sectionHeaderViewArray[section];
}

- (void)setContentValue:(id)value forCellAtIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellForRow:indexPath.row inSection:indexPath.section];
    if ([cell subViewForType:HZYFormViewCellContentSingleSelector] || [cell subViewForType:HZYFormViewCellContentMultiSelector]) {
        cell.selectList = value;
    }else if ([cell subViewForType:HZYFormViewCellContentInputField]) {
        ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).text = value;
    }else if ([cell subViewForType:HZYFormViewCellContentInputView]) {
        ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).text = value;
    }else if ([cell subViewForType:HZYFormViewCellContentDetail]) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentDetail]).text = value;
    }else if ([cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]) {
        if ([value isKindOfClass:[UIImage class]]) {
            ((HZYFormImageView *)[cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]).image = value;
        } else {
            ((HZYFormImageView *)[cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]).url = value;
        }
    }else if ([cell subViewForType:HZYFormViewCellContentMultiPhotoPicker]) {
        if ([[value firstObject]isKindOfClass:[UIImage class]]) {
            ((HZYPicturePickerView *)[cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]).pictures = value;
        }else{
            ((HZYPicturePickerView *)[cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]).urls = value;
        }
    }else {
        NSAssert(0, @"没有实现");
    }
}

- (void)setContentValue:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellForRow:indexPath.row inSection:indexPath.section];
    UIView *subView = [cell subViewForType:options];
    NSAssert(subView, @"no such view in cell");
    switch (options) {
        case HZYFormViewCellTitleIcon:
        case HZYFormViewCellContentCheckMark:
        case HZYFormViewCellContentIndicator:
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
        case HZYFormViewCellContentCitySelector:
        case HZYFormViewCellContentDatePickerDefault:
        case HZYFormViewCellContentDatePickerAtoB:
        case HZYFormViewCellContentSinglePhotoPicker:
            NSAssert([value isKindOfClass:[UIImage class]], @"value must be a UIImage object");
            ((HZYFormImageView *)subView).image = value;
            break;
        case HZYFormViewCellTitleText:
        case HZYFormViewCellContentDetail:
        case HZYFormViewCellContentInputView:
        case HZYFormViewCellContentSubDetail:
        case HZYFormViewCellContentInputField:
            NSAssert([value isKindOfClass:[NSString class]], @"value must be a NSString object");
            ((HZYFormLabel*)subView).text = value;
            break;
        case HZYFormViewCellContentMultiPhotoPicker:
        case HZYFormViewCellContentActionButton:
            NSAssert(0, @"not support for set value in such view");
            break;
    }
}

- (id)getValueFromCellAtIndex:(NSIndexPath *)index {
    [self isIndexPathOutofBounds:index];
    HZYFormViewCell *cell = self.dataModel.cellArray[index.section][index.row];
    if ([cell subViewForType:HZYFormViewCellContentDatePickerDefault]) {
        return cell.startDate;
    }else if ([cell subViewForType:HZYFormViewCellContentDatePickerAtoB]) {
        return @{HZYFormViewCellValueBeginDateKey : cell.startDate,
                 HZYFormViewCellValueEndDateKey : cell.endDate};
    }else if ([cell subViewForType:HZYFormViewCellContentInputField]) {
        return ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).text;
    }else if ([cell subViewForType:HZYFormViewCellContentInputView]) {
        return ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).value;
    }else if ([cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]) {
        return ((HZYFormImageView *)[cell subViewForType:HZYFormViewCellContentSinglePhotoPicker]).value;
    }else if ([cell subViewForType:HZYFormViewCellContentMultiPhotoPicker]) {
        return ((HZYPicturePickerView *)[cell subViewForType:HZYFormViewCellContentMultiPhotoPicker]).values;
    }
    return nil;
}

- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellForRow:indexPath.row inSection:indexPath.section];
    UIView *subView = [cell subViewForType:options];
    NSAssert(subView, @"no such view in cell");
    switch (options) {
        case HZYFormViewCellTitleIcon:
        case HZYFormViewCellContentCheckMark:
        case HZYFormViewCellContentIndicator:
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
        case HZYFormViewCellContentCitySelector:
        case HZYFormViewCellContentSinglePhotoPicker:
            return ((HZYFormImageView *)subView).image;
        case HZYFormViewCellContentDatePickerDefault:
            return cell.startDate;
        case HZYFormViewCellContentDatePickerAtoB:
            return @{HZYFormViewCellValueBeginDateKey : cell.startDate,
                     HZYFormViewCellValueEndDateKey : cell.endDate};
        case HZYFormViewCellTitleText:
        case HZYFormViewCellContentDetail:
        case HZYFormViewCellContentInputView:
        case HZYFormViewCellContentSubDetail:
        case HZYFormViewCellContentInputField:
            return ((HZYFormLabel*)subView).text;
        case HZYFormViewCellContentMultiPhotoPicker:
        case HZYFormViewCellContentActionButton:
            NSAssert(0, @"not support for set value in such view");
            return nil;
    }
}

- (void)setInputViewEnable:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath {
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
                if (([cell subViewForType:HZYFormViewCellContentInputField] ||
                     [cell subViewForType:HZYFormViewCellContentInputView]) &&
                    (![self getValueFromCellAtIndex:[NSIndexPath indexPathForRow:j inSection:i]] ||
                     [[self getValueFromCellAtIndex:[NSIndexPath indexPathForRow:j inSection:i]] isEqualToString:@""])) {
                        [tempArr addObject:[NSIndexPath indexPathForRow:j inSection:i]];
                    }
            }
        }
    }else{        
        for (NSIndexPath *path in indexPaths) {
            NSAssert(self.dataModel.cellArray.count > path.section && [self.dataModel.cellArray[path.row] count], @"indexpath out of bounds");
            HZYFormViewCell *cell = self.dataModel.cellArray[path.section][path.row];
            if (([cell subViewForType:HZYFormViewCellContentInputField] ||
                 [cell subViewForType:HZYFormViewCellContentInputView]) &&
                (![self getValueFromCellAtIndex:path] ||
                 [[self getValueFromCellAtIndex:path] isEqualToString:@""])) {
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
        [self initVariable];
        _dataModel.sectionRowCountArray = sectionRows;
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

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    NSArray *cells = [self visibleCells];
    for (NSInteger i=0; i<cells.count; i++) {
        HZYFormViewCell *cell = cells[i];
        cell.transform = CGAffineTransformMakeTranslation(375, 0);
        [UIView animateWithDuration:.45 delay:10 + i*0.03 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
    NSLog(@"a");
}

- (void)isIndexPathOutofBounds:(NSIndexPath *)indexPath {
    NSAssert(self.dataModel.sectionRowCountArray.count > indexPath.section && self.dataModel.sectionRowCountArray[indexPath.section].integerValue > indexPath.row, @"row or section index is out of bounds");
}

- (HZYFormInputView *)getInputView:(NSIndexPath *)indexPath {
    HZYFormInputView *inputView = (HZYFormInputView *)[[self cellForRow:indexPath.row inSection:indexPath.section]subViewForType:HZYFormViewCellContentInputView];
    if (!inputView) {
        inputView = (HZYFormInputView *)[[self cellForRow:indexPath.row inSection:indexPath.section]subViewForType:HZYFormViewCellContentInputField];
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
    _cellHeight = HZYFormCellHeight;
    _seperatorInsets = HZYFormCellSeperatorInsets;
    _seperatorColor = HZYFormCellSeperatorColor;
    _dataModel = [HZYFormViewDataModel new];
}

- (CGFloat)createCells {
    //headerView
    [self addSubview:self.headerView];
    //用于存放创建好的cell的array
    NSMutableArray *tempArr = [NSMutableArray array];
    HZYFormVIewCellSubViewCreater *creater = [[HZYFormVIewCellSubViewCreater alloc] initWithDataModel:self.dataModel];
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
            HZYFormViewCell *view;
            if ([self.dataModel.allCellTypeArray[i][j] isEqualToString:@"c"]) {
                view = [self.dataModel.customCellDictionary valueForKey:[NSString stringWithFormat:@"r:%zd,s:%zd", j, i]];
            }else{
                HZYFormViewCellOption options = [self.dataModel.optionsArray[i][j] unsignedIntegerValue];
                view = [self createCell:lastCellMaxY cellHeight:cellHeight withSperatLine:j != self.dataModel.sectionRowCountArray[i].integerValue - 1 isSectionLast:self.dataModel.sectionRowCountArray[i].integerValue - 1 == j];
                view = [creater createCellSubviews:view options:options atSection:i row:j];
            }
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
    return lastCellMaxY;
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
        sep.frame = CGRectMake(isSectionLast ? 0 : _seperatorInsets.left, cellHeight - (_seperatorInsets.bottom + 0.5), view.bounds.size.width - _seperatorInsets.left - _seperatorInsets.right, 0.5);
        sep.backgroundColor = _seperatorColor.CGColor;
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
}

#pragma mark - setter
- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    for (NSInteger i=0; i<self.dataModel.sectionRowCountArray.count; i++) {
        for (NSInteger j=0; j<self.dataModel.sectionRowCountArray[i].integerValue; j++) {
            self.dataModel.sectionRowHeightArray[i][j] = [NSNumber numberWithFloat:_cellHeight];
        }
    }
}

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

