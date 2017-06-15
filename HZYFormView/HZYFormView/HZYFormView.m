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
    return [self.dataModel getRowCountInSection:section];;
}

- (NSArray<HZYFormViewCell *> *)visibleCells {
    NSMutableArray *temp = [NSMutableArray array];
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        [temp addObject:cell];
    }];
    return temp.copy;
}


- (HZYFormViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    return [self.dataModel getCellForRow:indexPath.row inSection:indexPath.section];
}

- (void)hide:(BOOL)hidden cellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animate:(BOOL)animate {
    for (NSIndexPath *path in indexPaths) {
        [self.dataModel getCellForRow:path.row inSection:path.section].hidden = hidden;
    }
    [self reLayout:animate];
}

- (void)setCellOptions:(HZYFormViewCellOption)options forRowsAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        [self isIndexPathOutofBounds:indexPath];
        [self changeFrameWithOptions:options forRow:indexPath.row inSection:indexPath.section];
    }
}

- (void)setCellAccessory:(NSDictionary *)dict atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormButton *btn = [dict objectForKey:HZYFormCellAccessoryActionButton];
    if (btn) {
        [self reCreateCellAtIndexPath:indexPath options:[self.dataModel getCellForRow:indexPath.row inSection:indexPath.section].options];
    }
}

- (void)setCellHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath animate:(BOOL)animate {
    if (!indexPath || indexPath.row == -1) {
        [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row) {
            if (!indexPath || section == indexPath.section) {
                [self changeCellHeigthAtRow:row inSection:section newHeight:height];
            }
        } cellBlock:nil];
    } else {
        [self changeCellHeigthAtRow:indexPath.row inSection:indexPath.section newHeight:height];
    }
    [self reLayout:animate];
}


- (void)setHeaderHeight:(CGFloat)height forSection:(NSArray<NSNumber *> *)section {
    for (NSInteger i=0; i<[self.dataModel getSectionCount]; i++) {
        if (section.count == 0 || !section) {
            [self changeSection:i Height:height];
        }else{
            for (NSNumber *sectionIndex in section) {
                if (sectionIndex.integerValue == i) {
                    [self changeSection:i Height:height];
                }
            }
        }
    }
    [self reLayout:YES];
}


- (void)setHeaderTitle:(NSString *)title content:(NSString *)content forSection:(NSUInteger)section {
    [self isIndexPathOutofBounds:[NSIndexPath indexPathForRow:NSUIntegerMax inSection:section]];
    [self.dataModel getSectionHeaderViewForSection:section].titleLabel.text = title;
    [self.dataModel getSectionHeaderViewForSection:section].contentLable.text = content;
}

- (void)setHeaderView:(UIView *)view forSection:(NSArray<NSNumber *> *)section {
    for (NSInteger i=0; i<[self.dataModel getSectionCount]; i++) {
        if (!section || section.count == 0) {
            UIView *origin = [self.dataModel getSectionHeaderViewForSection:i];
            view.frame = origin.frame;
            [origin removeFromSuperview];
            [self addSubview:view];
            [self.dataModel setSectionHeaderView:view.copy forSection:i];
        }else{
            for (NSNumber *sectionIndex in section) {
                if (sectionIndex.integerValue == i) {
                    UIView *origin = [self.dataModel getSectionHeaderViewForSection:i];
                    view.frame = origin.frame;
                    [origin removeFromSuperview];
                    [self addSubview:view];
                    [self.dataModel setSectionHeaderView:view.copy forSection:i];
                }
            }
        }
    }
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

- (void)setContentValue:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellAtIndexPath:indexPath];
    [cell setContentValue:value forOptions:options];
}

- (void)setPlaceholder:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath {
    [self isIndexPathOutofBounds:indexPath];
    HZYFormViewCell *cell = [self cellAtIndexPath:indexPath];
    [cell setPlaceholder:value forOptions:options];
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
        [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row) {
            HZYFormViewCell *cell = [self.dataModel getCellForRow:row inSection:section];
            NSString *value = [self getValueFromCellOptions:HZYFormViewCellContentInputField | HZYFormViewCellContentInputView atIndex:[NSIndexPath indexPathForRow:row inSection:section]];
            if (([cell subViewForType:HZYFormViewCellContentInputField] || [cell subViewForType:HZYFormViewCellContentInputView]) &&
                (!value || [value isEqualToString:@""])) {
                [tempArr addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            }
        } cellBlock:nil];
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
            ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).layer.borderColor = [UIColor redColor].CGColor;
        }else if ([cell subViewForType:HZYFormViewCellContentInputView]) {
            ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).layer.borderColor = [UIColor redColor].CGColor;
        }
    }
}

#pragma mark - init & lifeCycle
- (instancetype)initWithFrame:(CGRect)frame rowsCount:(NSInteger)numberOfRow sectionRows:(NSArray<NSNumber *> *)sectionRows{
    if (self = [super initWithFrame:frame]) {
        [self initVariable:sectionRows];
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

// 动画用
- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    CGFloat up = contentOffset.y + 64;
    CGFloat down = up + self.bounds.size.height - 64;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        if ((cell.frame.origin.y > up && CGRectGetMaxY(cell.frame) < down) || (cell.frame.origin.y < up && CGRectGetMaxY(cell.frame) > up) || (CGRectGetMaxY(cell.frame) > down && cell.frame.origin.y < down)) {
            cell.visible = YES;
        }else{
            cell.visible = NO;
        }
    }];
}

- (void)initVariable:(NSArray *)rowCountArray {
    _dataModel = [HZYFormViewDataModel new];
    [_dataModel setSectionRowCount:rowCountArray];
    _cellSubviewCreater = [[HZYFormVIewCellSubViewCreater alloc] initWithDataModel:self.dataModel];
}

- (void)initDefaultViews {
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
            HZYFormViewCell *view = [self createCell:lastCellMaxY cellHeight:HZYFormViewCellHeight forRow:j inSection:i];
            view = [self.cellSubviewCreater createCellSubviews:view accessory:nil atSection:i row:j];
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

- (void)changeCellHeigthAtRow:(NSUInteger)row inSection:(NSUInteger)section newHeight:(CGFloat)height {
    HZYFormViewCell *cell = [self.dataModel getCellForRow:row inSection:section];
    CGRect frame = cell.frame;
    frame.size.height = height;
    cell.frame = frame;
}

- (void)changeSection:(NSUInteger)section Height:(CGFloat)height {
    UIView *header = [self.dataModel getSectionHeaderViewForSection:section];
    CGRect frame = header.frame;
    frame.size.height = height;
    header.frame = frame;
}

- (void)changeFrameWithOptions:(HZYFormViewCellOption)option forRow:(NSUInteger)row inSection:(NSUInteger)section {
    HZYFormViewCell *cell = [self.dataModel getCellForRow:row inSection:section];
    cell.options = option;
    CGRect frame = cell.frame;
    if (option & HZYFormViewCellContentSinglePhotoPicker) {
        frame.size.height = 166;
    }else if (option & HZYFormViewCellContentInputView) {
        frame.size.height = 120;
    }else if (option & HZYFormViewCellContentMultiPhotoPicker) {
        if (self.dataModel.pictures &&
            self.dataModel.pictures.count > section &&
            [self.dataModel.pictures[section] count] > row &&
            [self.dataModel.pictures[section][row] isKindOfClass:[NSArray class]] &&
            [self.dataModel.pictures[section][row] count] > 3) {
            frame.size.height = [self multiPhotoPickerHeightForNumberOfLine:2];
        }else{
            frame.size.height = [self multiPhotoPickerHeightForNumberOfLine:1];
        }
    }
    cell.frame = frame;
    [self reCreateCellAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] options:option];
    [self reLayout:YES];
}

- (CGFloat)multiPhotoPickerHeightForNumberOfLine:(NSUInteger)lineNum {
    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - 16*2 -3*8) / 4;
    return itemWH*lineNum + 12 + lineNum * 8 + 4;
}


- (HZYFormViewCell *)createCell:(CGFloat)cellY cellHeight:(CGFloat)cellHeight forRow:(NSUInteger)row inSection:(NSUInteger)section{
    HZYFormViewCell *view = [[HZYFormViewCell alloc]initWithFrame:CGRectMake(0, cellY, self.bounds.size.width, cellHeight)];
    view.shouldShowAnimation = self.cellShowAnimation;
    view.backgroundColor = HZYFormViewCellBackgroundColor;
    __weak typeof(view)weakView = view;
    __weak typeof(self)weakSelf = self;
    view.tapHandler = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(formView:cellDidSelected:indexPath:)]) {
            [weakSelf.delegate formView:weakSelf cellDidSelected:weakView indexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    };
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

- (void)reCreateCellAtIndexPath:(NSIndexPath *)indexPath options:(HZYFormViewCellOption)options {
    //重新创建这个cell
    HZYFormViewCell *cell = [self.dataModel getCellForRow:indexPath.row inSection:indexPath.section];
    [cell removeFromSuperview];
    cell = [self createCell:cell.frame.origin.y cellHeight:cell.frame.size.height forRow:indexPath.row inSection:indexPath.section];
    cell.options = options;
    cell = [self.cellSubviewCreater createCellSubviews:cell accessory:nil atSection:indexPath.section row:indexPath.row];
}

- (void)isIndexPathOutofBounds:(NSIndexPath *)indexPath {
    NSAssert([self.dataModel getSectionCount] > indexPath.section && [self.dataModel getRowCountInSection:indexPath.section] > indexPath.row, @"row or section index is out of bounds");
}

- (HZYFormInputView *)getInputView:(NSIndexPath *)indexPath {
    HZYFormInputView *inputView = (HZYFormInputView *)[[self cellAtIndexPath:indexPath]subViewForType:HZYFormViewCellContentInputView];
    if (!inputView) {
        inputView = (HZYFormInputView *)[[self cellAtIndexPath:indexPath]subViewForType:HZYFormViewCellContentInputField];
    }
    NSAssert(inputView, @"no inputView or inputField in cell");
    return inputView;
}

- (void)enumateAllCellsUsingIndexBlock:(void(^)(NSInteger section, NSUInteger row))indexBlock cellBlock:(void(^)(HZYFormViewCell *cell))cellBlock{
    for (NSInteger i=0; i<[self.dataModel getSectionCount]; i++) {
        for (NSInteger j=0; j<[self.dataModel getRowCountInSection:i]; j++) {
            if (indexBlock) {
                indexBlock(i, j);
            }
            if (cellBlock) {
                cellBlock([self.dataModel getCellForRow:j inSection:i]);
            }
        }
    }
}

#pragma mark - notification
- (void)multiPicPickerDidAddImage:(NSNotification *)note {
    NSInteger index = [note.userInfo[HZYFormCellNewAddedImageIndexKey] integerValue];
    if (index == 3) {
        [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
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
        [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
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
    for (NSInteger i=0; i<titles.count; i++) {
        for (NSInteger j=0; j<[titles[i] count]; j++) {
            [self setContentValue:titles[i][j] forCellOptions:HZYFormViewCellTitleText atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [[self.dataModel getCellForRow:j inSection:i] layoutIfNeeded];
        }
    }
}

- (void)setPlaceholders:(NSArray *)placeholders {
    _placeholders = placeholders.copy;
    self.dataModel.placeholders = placeholders;
    for (NSInteger i=0; i<placeholders.count; i++) {
        for (NSInteger j=0; j<[placeholders[i] count]; j++) {
            if ([placeholders[i][j] isKindOfClass:[UIImage class]]) {
                [self setPlaceholder:placeholders[i][j] forCellOptions:HZYFormViewCellContentSinglePhotoPicker atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            }else if ([placeholders[i][j] isKindOfClass:[NSArray class]] && [[placeholders[i][j] firstObject] isKindOfClass:[UIImage class]]) {
                [self setPlaceholder:placeholders[i][j] forCellOptions:HZYFormViewCellContentMultiPhotoPicker atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            }else{
                [self setPlaceholder:placeholders[i][j] forCellOptions:HZYFormViewCellContentInputView atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                [self setPlaceholder:placeholders[i][j] forCellOptions:HZYFormViewCellContentInputField atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];                
            }
        }
    }
}

- (void)setInputTexts:(NSArray *)inputTexts {
    _inputTexts = inputTexts.copy;
    self.dataModel.inputTexts = inputTexts;
    for (NSInteger i=0; i<inputTexts.count; i++) {
        for (NSInteger j=0; j<[inputTexts[i] count]; j++) {
            [self setContentValue:inputTexts[i][j] forCellOptions:HZYFormViewCellContentInputField atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [self setContentValue:inputTexts[i][j] forCellOptions:HZYFormViewCellContentInputView atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
}

- (void)setDetails:(NSArray *)details {
    _details = details.copy;
    self.dataModel.details = details;
    for (NSInteger i=0; i<details.count; i++) {
        for (NSInteger j=0; j<[details[i] count]; j++) {
            [self setContentValue:details[i][j] forCellOptions:HZYFormViewCellContentDetail atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
}

- (void)setSubDetails:(NSArray *)subDetails {
    _subDetails = subDetails.copy;
    self.dataModel.subDetails = subDetails;
    for (NSInteger i=0; i<subDetails.count; i++) {
        for (NSInteger j=0; j<[subDetails[i] count]; j++) {
            [self setContentValue:subDetails[i][j] forCellOptions:HZYFormViewCellContentSubDetail atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures.copy;
    self.dataModel.pictures = pictures;
    for (NSInteger i=0; i<pictures.count; i++) {
        for (NSInteger j=0; j<[pictures[i] count]; j++) {
            [self setContentValue:pictures[i][j] forCellOptions:HZYFormViewCellContentSinglePhotoPicker | HZYFormViewCellContentMultiPhotoPicker atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
}

- (void)setCheckmarks:(NSArray *)checkmarks {
    _checkmarks = checkmarks.copy;
    self.dataModel.checkmarks = checkmarks;
}

- (void)setCellBackgroundColor:(UIColor *)color {
    self.dataModel.cellBackgroundColor = color;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        cell.backgroundColor = color;
    }];
}

- (void)setCellSeperatorColor:(UIColor *)color {
    self.dataModel.cellSeperatorColor = color;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        cell.seperator.backgroundColor = color;
    }];
}

- (void)setCellSeperatorInsets:(UIEdgeInsets)insets {
    self.dataModel.cellSeperatorInsets = insets;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        cell.seperator.frame = CGRectMake(insets.left, cell.frame.size.height - 0.5, cell.frame.size.width - insets.left, 0.5);
    }];
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.dataModel.titleFont = titleFont;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellTitleText]).font = titleFont;
    }];
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.dataModel.titleColor = titleColor;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellTitleText]).textColor = titleColor;
    }];
}

- (void)setInputFieldFont:(UIFont *)inputFieldFont {
    self.dataModel.inputFieldFont = inputFieldFont;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).font = inputFieldFont;

    }];
}

- (void)setInputFieldTextColor:(UIColor *)inputFieldTextColor {
    self.dataModel.inputFieldTextColor = inputFieldTextColor;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).textColor = inputFieldTextColor;
    }];
}

- (void)setInputViewFont:(UIFont *)inputViewFont {
    self.dataModel.inputViewFont = inputViewFont;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).font = inputViewFont;
    }];
}

- (void)setInputViewTextColor:(UIColor *)inputViewTextColor {
    self.dataModel.inputViewTextColor = inputViewTextColor;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).textColor = inputViewTextColor;
    }];
}

- (void)setDetailFont:(UIFont *)detailFont {
    self.dataModel.detailFont = detailFont;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentDetail]).font = detailFont;
    }];
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    self.dataModel.detailTextColor = detailTextColor;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentDetail]).textColor = detailTextColor;
    }];
}

- (void)setSubDetailFont:(UIFont *)subDetailFont {
    self.dataModel.subDetailFont = subDetailFont;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentSubDetail]).font = subDetailFont;
    }];
}

- (void)setSubDetailTextColor:(UIColor *)subDetailTextColor {
    self.dataModel.subDetailTextColor = subDetailTextColor;
    [self enumateAllCellsUsingIndexBlock:nil cellBlock:^(HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentSubDetail]).textColor = subDetailTextColor;
    }];
}
@end

