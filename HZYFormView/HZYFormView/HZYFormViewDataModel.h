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
- (void)replaceCell:(HZYFormViewCell *)cell forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (NSIndexPath *)indexPathOfCell:(HZYFormViewCell *)cell;
- (void)enumateAllCellsUsingIndexBlock:(void(^)(NSInteger section, NSUInteger row, HZYFormViewCell *cell))indexBlock;

- (void)setSectionRowCount:(NSArray *)array;
- (NSUInteger)getRowCountInSection:(NSUInteger)section;
- (NSUInteger)getSectionCount;

- (void)setSectionHeaderView:(UIView *)view forSection:(NSUInteger)section;
- (HZYFormSectionHeaderView *)getSectionHeaderViewForSection:(NSUInteger)section;
- (void)replaceHeaderView:(HZYFormSectionHeaderView *)headerView forSection:(NSUInteger)section;

- (void)setTitle:(NSString *)title forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setIcon:(UIImage *)icon forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setPlaceholder:(id)placeholder forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setInputText:(NSString *)inputText forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setDetail:(NSString *)detail forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setSubDetail:(NSString *)subDetail forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setPicture:(id)pictures forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setSelectList:(NSArray *)list forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (void)setCheckMark:(HZYFormViewCheckmarkState)state forRow:(NSUInteger)row inSection:(NSUInteger)section;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *icons;
@property (nonatomic, strong) NSMutableArray *placeholders;
@property (nonatomic, strong) NSMutableArray *inputTexts;
@property (nonatomic, strong) NSMutableArray *details;
@property (nonatomic, strong) NSMutableArray *subDetails;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSMutableArray *selectLists;
@property (nonatomic, strong) NSMutableArray *checkmarks;//@0=normal,@1=selected，@2=disabled

- (void)setupAllCellValue;
- (void)setupCellValueForRow:(NSUInteger)row inSection:(NSUInteger)section;


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
