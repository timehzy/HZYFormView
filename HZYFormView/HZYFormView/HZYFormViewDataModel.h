//
//  HZYFormViewDataModel.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/5/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"

@class HZYFormViewCell;
@class HZYFormSectionHeaderView;
@interface HZYFormViewDataModel : NSObject

- (void)setCell:(HZYFormViewCell *)cell forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (HZYFormViewCell *)getCellForRow:(NSUInteger)row inSection:(NSUInteger)section;
- (NSIndexPath *)indexPathOfCell:(HZYFormViewCell *)cell;

- (void)setSectionRowCount:(NSArray *)array;
- (NSUInteger)getRowCountInSection:(NSUInteger)section;
- (NSUInteger)getSectionCount;

- (void)setSectionHeaderView:(UIView *)view forSection:(NSUInteger)section;
- (HZYFormSectionHeaderView *)getSectionHeaderViewForSection:(NSUInteger)section;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *icons;
@property (nonatomic, copy) NSArray *placeholders;
@property (nonatomic, copy) NSArray *inputTexts;
@property (nonatomic, copy) NSArray *details;
@property (nonatomic, copy) NSArray *subDetails;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, copy) NSArray *checkmarks;//@0=normal,@1=selected，@2=disable

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *inputFieldFont;
@property (nonatomic, strong) UIColor *inputFieldTextColor;
@property (nonatomic, strong) UIFont *inputViewFont;
@property (nonatomic, strong) UIColor *inputViewTextColor;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIFont *subDetailFont;
@property (nonatomic, strong) UIColor *subDetailTextColor;

@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, assign) UIEdgeInsets cellSeperatorInsets;
@property (nonatomic, strong) UIColor *cellSeperatorColor;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@end
