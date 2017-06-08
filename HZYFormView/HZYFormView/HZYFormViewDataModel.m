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

@implementation HZYFormViewDataModel
- (instancetype)init {
    if (self = [super init]) {
        _cellSeperatorInsets = HZYFormViewCellSeperatorInsets;
    }
    return self;
}

- (NSMutableArray *)sectionRowHeightArray {
    if (!_sectionRowHeightArray) {
        _sectionRowHeightArray = [NSMutableArray array];
        [self enumateAllCellUsingSingleSectionBlock:^(NSInteger i) {
            [_sectionRowHeightArray addObject:[NSNumber numberWithFloat:HZYFormCellHeight]];
        } multiSectionBlock:^(NSInteger i) {
            [_sectionRowHeightArray addObject:[NSMutableArray array]];
        } multiRowBlock:^(NSInteger i, NSInteger j) {
            [_sectionRowHeightArray[i] addObject:[NSNumber numberWithFloat:HZYFormCellHeight]];
        }];
    }
    return _sectionRowHeightArray;
}

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

- (NSMutableArray *)sectionHeaderHeightArray {
    if (!_sectionHeaderHeightArray) {
        _sectionHeaderHeightArray = [NSMutableArray array];
        for (NSInteger i=0; i<_sectionRowCountArray.count; i++) {
            [_sectionHeaderHeightArray addObject:[NSNumber numberWithFloat:10]];
        }
    }
    return _sectionHeaderHeightArray;
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

- (NSMutableArray *)optionsArray {
    if (!_optionsArray) {
        _optionsArray = [NSMutableArray array];
        [self enumateAllCellUsingSingleSectionBlock:^(NSInteger i) {
            [_optionsArray addObject:[NSNumber numberWithInteger:HZYFormViewCellTitleText | HZYFormViewCellContentInputField]];
        } multiSectionBlock:^(NSInteger i) {
            [_optionsArray addObject:[NSMutableArray array]];
        } multiRowBlock:^(NSInteger i, NSInteger j) {
            [_optionsArray[i] addObject:[NSNumber numberWithInteger:HZYFormViewCellTitleText | HZYFormViewCellContentInputField]];
        }];
    }
    return _optionsArray;
}

- (NSMutableArray *)allCellTypeArray {
    if (!_allCellTypeArray) {
        _allCellTypeArray = [NSMutableArray array];
        [self enumateAllCellUsingSingleSectionBlock:^(NSInteger i) {
            [_allCellTypeArray addObject:@"d"];
        } multiSectionBlock:^(NSInteger i) {
            [_allCellTypeArray addObject:[NSMutableArray array]];
        } multiRowBlock:^(NSInteger i, NSInteger j) {
            [_allCellTypeArray[i] addObject:@"d"];
        }];
    }
    return _allCellTypeArray;
}

- (NSMutableDictionary *)customCellDictionary {
    if (!_customCellDictionary) {
        _customCellDictionary = [NSMutableDictionary dictionary];
    }
    return _customCellDictionary;
}

- (NSMutableArray *)cellAccessoryArray {
    if (!_cellAccessoryArray) {
        _cellAccessoryArray = [NSMutableArray array];
        for (NSInteger i=0; i<_sectionRowCountArray.count; i++) {
            [_cellAccessoryArray addObject:[NSMutableArray array]];
            for (NSInteger j=0; j<_sectionRowCountArray[i].integerValue; j++) {
                [_cellAccessoryArray[i] addObject:[NSMutableDictionary dictionary]];
            }
        }
    }
    return _cellAccessoryArray;
}

- (NSMutableArray *)cellHideArray {
    if (!_cellHideArray) {
        _cellHideArray = [NSMutableArray array];
        for (NSInteger i=0; i<_sectionRowCountArray.count; i++) {
            [_cellHideArray addObject:[NSMutableArray array]];
            for (NSInteger j=0; j<_sectionRowCountArray[i].integerValue; j++) {
                [_cellHideArray[i] addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    return _cellHideArray;
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



@end
