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

@interface HZYFormViewDataModel ()
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *sectionRowCountArray;
@property (nonatomic, strong) NSMutableArray *sectionHeaderViewArray;

@property (nonatomic, assign) BOOL isSingleSection;

@end

@implementation HZYFormViewDataModel
- (instancetype)init {
    if (self = [super init]) {
        _cellSeperatorInsets = HZYFormViewCellSeperatorInsets;
    }
    return self;
}

- (void)setSectionRowCount:(NSMutableArray *)array {
    _sectionRowCountArray = array;
    if (array.count > 0 && ![array.firstObject isKindOfClass:[NSArray class]]) {
        self.isSingleSection = YES;
    }
}
- (NSUInteger)getRowCountInSection:(NSUInteger)section {
    NSAssert(section < self.sectionRowCountArray.count - 1, @"【HZYFormView Warning】: section index should not greater than section count");
    return self.sectionRowCountArray[section].integerValue;
}

- (NSUInteger)getSectionCount {
    return self.sectionRowCountArray.count;
}

- (void)setCell:(HZYFormViewCell *)cell forRow:(NSUInteger)row inSection:(NSUInteger)section {
    if (self.isSingleSection) {
        self.cellArray[row] = cell;
    }else{
        self.cellArray[section][row] = cell;
    }
}

- (HZYFormViewCell *)getCellForRow:(NSUInteger)row inSection:(NSUInteger)section {
    if (self.isSingleSection) {
        return self.cellArray[row];
    }else{
        return self.cellArray[section][row];
    }
}

- (void)setSectionHeaderView:(UIView *)view forSection:(NSUInteger)section {
    self.sectionHeaderViewArray[section] = view;
}

- (HZYFormSectionHeaderView *)getSectionHeaderViewForSection:(NSUInteger)section {
    return self.sectionHeaderViewArray[section];
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

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = HZYFormCellTitleFont;
    }
    return _titleFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = HZYFormCellTitleColor;
    }
    return _titleColor;
}

- (UIFont *)inputFieldFont {
    if (!_inputFieldFont) {
        _inputFieldFont = HZYFormCellInputFieldFont;
    }
    return _inputFieldFont;
}

- (UIColor *)inputFieldTextColor {
    if (!_inputFieldTextColor) {
        _inputFieldTextColor = HZYFormCellInputFieldTextColor;
    }
    return _inputFieldTextColor;
}

- (UIFont *)inputViewFont {
    if (!_inputViewFont) {
        _inputViewFont = HZYFormCellInputViewFont;
    }
    return _inputViewFont;
}

- (UIColor *)inputViewTextColor {
    if (!_inputViewTextColor) {
        _inputViewTextColor = HZYFormCellInputViewTextColor;
    }
    return _inputViewTextColor;
}

- (UIFont *)detailFont {
    if (!_detailFont) {
        _detailFont = HZYFormCellDetailFont;
    }
    return _detailFont;
}

- (UIColor *)detailTextColor {
    if (!_detailTextColor) {
        _detailTextColor = HZYFormCellDetailTextColor;
    }
    return _detailTextColor;
}

- (UIFont *)subDetailFont {
    if (!_subDetailFont) {
        _subDetailFont = HZYFormCellSubDetailFont;
    }
    return _subDetailFont;
}

- (UIColor *)subDetailTextColor {
    if (!_subDetailTextColor) {
        _subDetailTextColor = HZYFormCellSubDetailTextColor;
    }
    return _subDetailTextColor;
}

#pragma mark - private

- (void)enumateAllCellUsingSingleSectionBlock:(void(^)(NSInteger i))sblock multiSectionBlock:(void(^)(NSInteger i))mblock multiRowBlock:(void(^)(NSInteger i, NSInteger j))rblock{
    if (self.sectionRowCountArray.count == 1) {
        for (NSInteger i=0; i<self.sectionRowCountArray[0].integerValue; i++) {
            if (sblock) sblock(i);
        }
    }else{
        for (NSInteger i=0; i<_sectionRowCountArray.count; i++) {
            if (mblock) mblock(i);
            for (NSInteger j=0; j<_sectionRowCountArray[i].integerValue; j++) {
                if (rblock) rblock(i, j);
            }
        }
    }
}

@end
