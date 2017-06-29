//
//  HZYFormViewDataModel.m
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/5/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormViewDataModel.h"
#import "HZYFormViewDefine.h"
#import "HZYFormSectionHeaderView.h"
#import "HZYFormViewCell.h"

@interface HZYFormViewDataModel ()
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *sectionRowCountArray;
@property (nonatomic, strong) NSMutableArray *sectionHeaderViewArray;

@property (nonatomic, assign) BOOL isSingleSection;

@end

@implementation HZYFormViewDataModel
@synthesize titleFont = _titleFont;
@synthesize titleColor = _titleColor;
@synthesize inputFieldFont = _inputFieldFont;
@synthesize inputFieldTextColor = _inputFieldTextColor;
@synthesize inputViewFont = _inputViewFont;
@synthesize inputViewTextColor = _inputViewTextColor;
@synthesize detailFont = _detailFont;
@synthesize detailTextColor = _detailTextColor;
@synthesize subDetailFont = _subDetailFont;
@synthesize subDetailTextColor = _subDetailTextColor;
@synthesize cellBackgroundColor = _cellBackgroundColor;
@synthesize cellSeperatorColor = _cellSeperatorColor;
@synthesize cellSeperatorInsets = _cellSeperatorInsets;
@synthesize textAlignment = _textAlignment;
@synthesize titles = _titles;
@synthesize icons = _icons;
@synthesize placeholders = _placeholders;
@synthesize inputTexts = _inputTexts;
@synthesize details = _details;
@synthesize subDetails = _subDetails;
@synthesize pictures = _pictures;
@synthesize selectLists = _selectLists;
@synthesize checkmarks = _checkmarks;
- (instancetype)init {
    if (self = [super init]) {
        _textAlignment = NSTextAlignmentRight;
        _cellSeperatorInsets = HZYFormViewCellSeperatorInsets;
    }
    return self;
}

#pragma mark - public
- (void)setCell:(HZYFormViewCell *)cell forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.cellArray[section][row] = cell;
}

- (HZYFormViewCell *)getCellForRow:(NSUInteger)row inSection:(NSUInteger)section {
    return self.cellArray[section][row];
}

- (void)replaceCell:(HZYFormViewCell *)cell forRow:(NSUInteger)row inSection:(NSUInteger)section {
    [self.cellArray[section] replaceObjectAtIndex:row withObject:cell];
}

- (NSIndexPath *)indexPathOfCell:(HZYFormViewCell *)cell {
    if (!cell) {
        return nil;
    }
    for (NSInteger i=0; i<self.cellArray.count; i++) {
        for (NSInteger j=0; j<[self.cellArray[i] count]; j++) {
            if ([self.cellArray[i][j] isEqual:cell]) {
                return [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
    }
    return nil;
}

- (void)enumateAllCellsUsingIndexBlock:(void(^)(NSInteger section, NSUInteger row, HZYFormViewCell *cell))indexBlock {
    for (NSInteger i=0; i<[self getSectionCount]; i++) {
        for (NSInteger j=0; j<[self getRowCountInSection:i]; j++) {
            if (indexBlock) {
                indexBlock(i, j, [self getCellForRow:j inSection:i]);
            }
        }
    }
}

- (void)setSectionRowCount:(NSMutableArray *)array {
    _sectionRowCountArray = array;
    if (array.count > 0 && ![array.firstObject isKindOfClass:[NSArray class]]) {
        self.isSingleSection = YES;
    }
}

- (NSUInteger)getRowCountInSection:(NSUInteger)section {
    NSAssert(section <= self.sectionRowCountArray.count - 1, @"【HZYFormView Warning】: section index should not greater than section count");
    return self.sectionRowCountArray[section].integerValue;
}

- (NSUInteger)getSectionCount {
    return self.sectionRowCountArray.count;
}

- (void)setSectionHeaderView:(UIView *)view forSection:(NSUInteger)section {
    self.sectionHeaderViewArray[section] = view;
}

- (HZYFormSectionHeaderView *)getSectionHeaderViewForSection:(NSUInteger)section {
    return self.sectionHeaderViewArray[section];
}

- (void)setupAllCellValue {
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        [self setupCellValueForRow:row inSection:section];
    }];
}

- (void)setupCellValueForRow:(NSUInteger)row inSection:(NSUInteger)section {
    HZYFormViewCell *cell = [self getCellForRow:row inSection:section];
    for (UIView<HZYFormCellSubViewProtocol> *view in cell.subviews) {
        if ([view conformsToProtocol:@protocol(HZYFormCellSubViewProtocol)]) {
            [self setCellSubviewValueOfType:view forRow:row inSection:section];
        }
        if ([view conformsToProtocol:@protocol(HZYFormCellSubViewPlaceholderProtocol)]) {
            [self setCellSubViewPlaceholderOfType:(UIView<HZYFormCellSubViewPlaceholderProtocol, HZYFormCellSubViewProtocol> *)view forRow:row inSection:section];
        }
    }
    [cell layoutIfNeeded];
}

#pragma mark - private
- (void)setupCellValueOfType:(HZYFormViewCellOption)type forRow:(NSUInteger)row inSection:(NSUInteger)section {
    HZYFormViewCell *cell = [self getCellForRow:row inSection:section];
    [self setCellSubviewValueOfType:[cell subViewForType:type] forRow:row inSection:section];
    [cell layoutIfNeeded];
}

- (void)setupCellPlaceholder:(HZYFormViewCellOption)type forRow:(NSUInteger)row inSection:(NSUInteger)section {
    HZYFormViewCell *cell = [self getCellForRow:row inSection:section];
    [self setCellSubViewPlaceholderOfType:(UIView<HZYFormCellSubViewPlaceholderProtocol, HZYFormCellSubViewProtocol> *)[cell subViewForType:type] forRow:row inSection:section];
}

- (id)getValueForType:(HZYFormViewCellOption)type forRow:(NSUInteger)row inSection:(NSUInteger)section {
    NSArray *values;
    switch (type) {
        case HZYFormViewCellTitleIcon:
            values = self.icons;
            break;
        case HZYFormViewCellTitleText:
            values = self.titles;
            break;
        case HZYFormViewCellContentDetail:
            values = self.details;
            break;
        case HZYFormViewCellContentSubDetail:
            values = self.subDetails;
            break;
        case HZYFormViewCellContentInputField:
        case HZYFormViewCellContentInputView:
            values = self.inputTexts;
            break;
        case HZYFormViewCellContentCheckMark:
            values = self.checkmarks;
            break;
        case HZYFormViewCellContentSinglePhotoPicker:
            values = self.pictures;
            break;
        case HZYFormViewCellContentMultiPhotoPicker:
            values = self.pictures;
            break;
            
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
            values = self.selectLists;
            break;
        case HZYFormViewCellContentCitySelector:
        case HZYFormViewCellContentDatePickerDefault:
        case HZYFormViewCellContentDatePickerAtoB:
            if (type & HZYFormViewCellContentInputField) {
                values = self.inputTexts;
            }else if (type & HZYFormViewCellContentDetail) {
                values = self.details;
            }else if (type & HZYFormViewCellContentSubDetail) {
                values = self.subDetails;
            }
            break;
        case HZYFormViewCellContentIndicator:
        case HZYFormViewCellContentActionButton:
            break;
    }
    if (values.count > section && [values[section] count] > row) {
        return values[section][row];
    }
    return nil;
}

- (void)setCellSubviewValueOfType:(UIView<HZYFormCellSubViewProtocol> *)view forRow:(NSUInteger)row inSection:(NSUInteger)section {
    if (!view) {
        return;
    }
    HZYFormViewCell *curCell = [self getCellForRow:row inSection:section];
    switch (view.type) {
        case HZYFormViewCellTitleIcon:
        case HZYFormViewCellTitleText:
        case HZYFormViewCellContentDetail:
        case HZYFormViewCellContentSubDetail:
        case HZYFormViewCellContentInputField:
        case HZYFormViewCellContentInputView:
        case HZYFormViewCellContentCheckMark:
        case HZYFormViewCellContentSinglePhotoPicker:
        case HZYFormViewCellContentMultiPhotoPicker:
            view.value = [self getValueForType:view.type forRow:row inSection:section];
            break;
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
            curCell.selectList = [self getValueForType:view.type forRow:row inSection:section];
            break;
        case HZYFormViewCellContentCitySelector:
        case HZYFormViewCellContentDatePickerDefault:
        case HZYFormViewCellContentDatePickerAtoB:
            if (curCell.options & HZYFormViewCellContentInputField) {
                [curCell subViewForType:HZYFormViewCellContentInputField].value = [self getValueForType:view.type forRow:row inSection:section];
            }else if (curCell.options & HZYFormViewCellContentDetail) {
                [curCell subViewForType:HZYFormViewCellContentDetail].value = [self getValueForType:view.type forRow:row inSection:section];
            }else if (curCell.options & HZYFormViewCellContentSubDetail) {
                [curCell subViewForType:HZYFormViewCellContentSubDetail].value = [self getValueForType:view.type forRow:row inSection:section];
            }
            break;
        case HZYFormViewCellContentIndicator:
        case HZYFormViewCellContentActionButton:
            break;
    }
}

- (void)setCellSubViewPlaceholderOfType:(UIView<HZYFormCellSubViewPlaceholderProtocol, HZYFormCellSubViewProtocol> *)view forRow:(NSUInteger)row inSection:(NSUInteger)section {
    if (!view) {
        return;
    }
    if (self.placeholders.count > section && [self.placeholders[section] count] > row) {
        switch (view.type) {
            case HZYFormViewCellContentInputField:
            case HZYFormViewCellContentInputView:
            case HZYFormViewCellContentSinglePhotoPicker:
                view.placeholder = self.placeholders[section][row];
                break;
            case HZYFormViewCellTitleIcon:
            case HZYFormViewCellTitleText:
            case HZYFormViewCellContentDetail:
            case HZYFormViewCellContentSubDetail:
            case HZYFormViewCellContentCheckMark:
            case HZYFormViewCellContentMultiPhotoPicker:
            case HZYFormViewCellContentSingleSelector:
            case HZYFormViewCellContentMultiSelector:
            case HZYFormViewCellContentCitySelector:
            case HZYFormViewCellContentDatePickerDefault:
            case HZYFormViewCellContentDatePickerAtoB:
            case HZYFormViewCellContentIndicator:
            case HZYFormViewCellContentActionButton:
                break;
        }
    }
}

- (NSMutableArray *)createArray {
    NSMutableArray *section = [NSMutableArray array];
    for (NSInteger i=0; i<[self getSectionCount]; i++) {
        [section addObject:[NSMutableArray arrayWithCapacity:[self getRowCountInSection:i]]];
    }
    return section;
}

#pragma mark - getter & setter
- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
        for (NSInteger i=0; i<[self getSectionCount]; i++) {
            [_cellArray addObject:[NSMutableArray array]];
        }
    }
    return _cellArray;
}

- (NSMutableArray *)sectionHeaderViewArray {
    if (!_sectionHeaderViewArray) {
        _sectionHeaderViewArray = [NSMutableArray array];
        for (NSInteger i=0; i<_sectionRowCountArray.count; i++) {
            [_sectionHeaderViewArray addObject:[HZYFormSectionHeaderView new]];
        }
    }
    return _sectionHeaderViewArray;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [self createArray];
    }
    return _titles;
}

- (NSMutableArray *)icons {
    if (!_icons) {
        _icons = [self createArray];
    }
    return _icons;
}

- (NSMutableArray *)placeholders {
    if (!_placeholders) {
        _placeholders = [self createArray];
    }
    return _placeholders;
}

- (NSMutableArray *)inputTexts {
    if (!_inputTexts) {
        _inputTexts = [self createArray];
    }
    return _inputTexts;
}

- (NSMutableArray *)details {
    if (!_details) {
        _details = [self createArray];
    }
    return _details;
}

- (NSMutableArray *)subDetails {
    if (!_subDetails) {
        _subDetails = [self createArray];
    }
    return _subDetails;
}

- (NSMutableArray *)pictures {
    if (!_pictures) {
        _pictures = [self createArray];
    }
    return _pictures;
}

- (NSMutableArray *)selectLists {
    if (!_selectLists) {
        _selectLists = [self createArray];
    }
    return _selectLists;
}

- (NSMutableArray *)checkmarks {
    if (!_checkmarks) {
        _checkmarks = [self createArray];
    }
    return _checkmarks;
}

- (void)setTitle:(NSString *)title forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.titles[section][row] = title;
}

- (void)setIcon:(UIImage *)icon forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.icons[section][row] = icon;
}

- (void)setPlaceholder:(id)placeholder forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.placeholders[section][row] = placeholder;
}

- (void)setInputText:(NSString *)inputText forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.inputTexts[section][row] = inputText;
}

- (void)setDetail:(NSString *)detail forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.details[section][row] = detail;
}

- (void)setSubDetail:(NSString *)subDetail forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.subDetails[section][row] = subDetail;
}

- (void)setPicture:(id)pictures forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.pictures[section][row] = pictures;
}

- (void)setSelectList:(NSArray *)list forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.selectLists[section][row] = list;
}

- (void)setCheckMark:(HZYFormViewCheckmarkState)state forRow:(NSUInteger)row inSection:(NSUInteger)section {
    self.checkmarks[section][row] = @(state);
}

- (void)setTitles:(NSMutableArray *)titles {
    _titles = titles;
    for (NSInteger i=0; i<_titles.count; i++) {
        for (NSInteger j=0; j<[_titles[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellTitleText forRow:j inSection:i];
        }
    }
}

- (void)setIcons:(NSMutableArray *)icons {
    _icons = icons;
    for (NSInteger i=0; i<icons.count; i++) {
        for (NSInteger j=0; j<[icons[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellTitleIcon forRow:j inSection:i];
        }
    }
}

- (void)setPlaceholders:(NSMutableArray *)placeholders {
    _placeholders = placeholders;
    for (NSInteger i=0; i<placeholders.count; i++) {
        for (NSInteger j=0; j<[placeholders[i] count]; j++) {
            if ([placeholders[i][j] isKindOfClass:[UIImage class]]) {
                [self setupCellPlaceholder:HZYFormViewCellContentSinglePhotoPicker forRow:j inSection:i];
            }else if ([placeholders[i][j] isKindOfClass:[NSArray class]] && [[placeholders[i][j] firstObject] isKindOfClass:[UIImage class]]) {
                [self setupCellPlaceholder:HZYFormViewCellContentMultiPhotoPicker forRow:j inSection:i];
            }else{
                [self setupCellPlaceholder:HZYFormViewCellContentInputField forRow:j inSection:i];
                [self setupCellPlaceholder:HZYFormViewCellContentInputView forRow:j inSection:i];
            }
        }
    }
}

- (void)setInputTexts:(NSMutableArray *)inputTexts {
    _inputTexts = inputTexts;
    for (NSInteger i=0; i<inputTexts.count; i++) {
        for (NSInteger j=0; j<[inputTexts[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellContentInputField forRow:j inSection:i];
            [self setupCellValueOfType:HZYFormViewCellContentInputView forRow:j inSection:i];
        }
    }
}

- (void)setDetails:(NSMutableArray *)details {
    _details = details;
    for (NSInteger i=0; i<details.count; i++) {
        for (NSInteger j=0; j<[details[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellContentDetail forRow:j inSection:i];
        }
    }
}

- (void)setSubDetails:(NSMutableArray *)subDetails {
    _subDetails = subDetails;
    for (NSInteger i=0; i<subDetails.count; i++) {
        for (NSInteger j=0; j<[subDetails[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellContentSubDetail forRow:j inSection:i];
        }
    }
}

- (void)setPictures:(NSMutableArray *)pictures {
    _pictures = pictures;
    for (NSInteger i=0; i<pictures.count; i++) {
        for (NSInteger j=0; j<[pictures[i] count]; j++) {
            if ([pictures[i][j] isKindOfClass:[UIImage class]]) {
                [self setupCellValueOfType:HZYFormViewCellContentSinglePhotoPicker forRow:j inSection:i];
            }else{
                [self setupCellValueOfType:HZYFormViewCellContentMultiPhotoPicker forRow:j inSection:i];
            }
        }
    }
}

- (void)setSelectLists:(NSMutableArray *)selectLists {
    _selectLists = selectLists;
    for (NSInteger i=0; i<selectLists.count; i++) {
        for (NSInteger j=0; j<[selectLists[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellContentSingleSelector forRow:j inSection:i];
            [self setupCellValueOfType:HZYFormViewCellContentMultiSelector forRow:j inSection:i];
        }
    }
}

- (void)setCheckmarks:(NSMutableArray *)checkmarks {
    _checkmarks = checkmarks;
    for (NSInteger i=0; i<checkmarks.count; i++) {
        for (NSInteger j=0; j<[checkmarks[i] count]; j++) {
            [self setupCellValueOfType:HZYFormViewCellContentCheckMark forRow:j inSection:i];
        }
    }
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = HZYFormViewCellTitleFont;
    }
    return _titleFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = HZYFormViewCellTitleColor;
    }
    return _titleColor;
}

- (UIFont *)inputFieldFont {
    if (!_inputFieldFont) {
        _inputFieldFont = HZYFormViewCellInputFieldFont;
    }
    return _inputFieldFont;
}

- (UIColor *)inputFieldTextColor {
    if (!_inputFieldTextColor) {
        _inputFieldTextColor = HZYFormViewCellInputFieldTextColor;
    }
    return _inputFieldTextColor;
}

- (UIFont *)inputViewFont {
    if (!_inputViewFont) {
        _inputViewFont = HZYFormViewCellInputViewFont;
    }
    return _inputViewFont;
}

- (UIColor *)inputViewTextColor {
    if (!_inputViewTextColor) {
        _inputViewTextColor = HZYFormViewCellInputViewTextColor;
    }
    return _inputViewTextColor;
}

- (UIFont *)detailFont {
    if (!_detailFont) {
        _detailFont = HZYFormViewCellDetailFont;
    }
    return _detailFont;
}

- (UIColor *)detailTextColor {
    if (!_detailTextColor) {
        _detailTextColor = HZYFormViewCellDetailTextColor;
    }
    return _detailTextColor;
}

- (UIFont *)subDetailFont {
    if (!_subDetailFont) {
        _subDetailFont = HZYFormViewCellSubDetailFont;
    }
    return _subDetailFont;
}

- (UIColor *)subDetailTextColor {
    if (!_subDetailTextColor) {
        _subDetailTextColor = HZYFormViewCellSubDetailTextColor;
    }
    return _subDetailTextColor;
}


- (UIColor *)cellBackgroundColor {
    if (!_cellBackgroundColor) {
        _cellBackgroundColor = HZYFormViewCellBackgroundColor;
    }
    return _cellBackgroundColor;
}

- (UIColor *)cellSeperatorColor {
    if (!_cellSeperatorColor) {
        _cellSeperatorColor = HZYFormViewCellSeperatorColor;
    }
    return _cellSeperatorColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
}

- (void)setCellBackgroundColor:(UIColor *)color {
    _cellBackgroundColor = color;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        cell.backgroundColor = color;
    }];
}

- (void)setCellSeperatorColor:(UIColor *)color {
    _cellSeperatorColor = color;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        cell.seperator.backgroundColor = color;
    }];
}

- (void)setCellSeperatorInsets:(UIEdgeInsets)insets {
    _cellSeperatorInsets = insets;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        cell.seperator.frame = CGRectMake(insets.left, cell.frame.size.height - 0.5, cell.frame.size.width - insets.left, 0.5);
    }];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellTitleText]).font = titleFont;
    }];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellTitleText]).textColor = titleColor;
    }];
}

- (void)setInputFieldFont:(UIFont *)inputFieldFont {
    _inputFieldFont = inputFieldFont;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).font = inputFieldFont;
    }];
}

- (void)setInputFieldTextColor:(UIColor *)inputFieldTextColor {
    _inputFieldTextColor = inputFieldTextColor;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormInputField *)[cell subViewForType:HZYFormViewCellContentInputField]).textColor = inputFieldTextColor;
    }];
}

- (void)setInputViewFont:(UIFont *)inputViewFont {
    _inputViewFont = inputViewFont;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).font = inputViewFont;
    }];
}

- (void)setInputViewTextColor:(UIColor *)inputViewTextColor {
    _inputViewTextColor = inputViewTextColor;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormInputView *)[cell subViewForType:HZYFormViewCellContentInputView]).textColor = inputViewTextColor;
    }];
}

- (void)setDetailFont:(UIFont *)detailFont {
    _detailFont = detailFont;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentDetail]).font = detailFont;
    }];
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    _detailTextColor = detailTextColor;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentDetail]).textColor = detailTextColor;
    }];
}

- (void)setSubDetailFont:(UIFont *)subDetailFont {
    _subDetailFont = subDetailFont;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentSubDetail]).font = subDetailFont;
    }];
}

- (void)setSubDetailTextColor:(UIColor *)subDetailTextColor {
    _subDetailTextColor = subDetailTextColor;
    [self enumateAllCellsUsingIndexBlock:^(NSInteger section, NSUInteger row, HZYFormViewCell *cell) {
        ((HZYFormLabel *)[cell subViewForType:HZYFormViewCellContentSubDetail]).textColor = subDetailTextColor;
    }];
}

@end
