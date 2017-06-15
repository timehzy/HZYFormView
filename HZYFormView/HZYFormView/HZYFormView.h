//
//  HZYFormView.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/4/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"
#import "HZYFormViewCell.h"

@class HZYFormViewCell;

@class HZYFormView;
@protocol HZYFormViewDelegate <NSObject, UIScrollViewDelegate>
- (void)formView:(HZYFormView *)formView cellDidSelected:(HZYFormViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end

@interface HZYFormView : UIScrollView
#pragma mark - dataSource
// 一次性设置每个cell的值
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *placeholders;
@property (nonatomic, copy) NSArray *inputTexts;
@property (nonatomic, copy) NSArray *details;
@property (nonatomic, copy) NSArray *subDetails;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, copy) NSArray *checkmarks;//@0=normal,@1=selected，@2=disable

#pragma mark - init
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows;
@property (nonatomic, weak) id<HZYFormViewDelegate> delegate;

#pragma mark - cell
/// indexPath传nil可以设置全部高度，indexpath.row传-1可以设置section每个cell的高度
- (void)setCellHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath animate:(BOOL)animate;
/// 设置cell的样式
- (void)setCellOptions:(HZYFormViewCellOption)options forRowsAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths;
/// 设置view的附件属性
- (void)setCellAccessory:(NSDictionary *)dict atIndexPath:(NSIndexPath *)indexPath;
/// 设置自定义的view作为一个cell
- (void)setCustomViewAsCell:(UIView *)view atIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (HZYFormViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray<HZYFormViewCell *> *)visibleCells;
// 必须传一个二维数组，例如要隐藏第1个section的第2、3个cell、第3个section的第1个cell、第4个section的全部cell，则传@[@[@1, @2], @[], @[@0], @[@-1]]
- (void)hide:(BOOL)hidden cellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animate:(BOOL)animate;

#pragma mark - section
/// 设置section headerView。section传nil可以统一设置所有section
- (void)setHeaderHeight:(CGFloat)height forSection:(NSArray<NSNumber *> *)section;
/// 设置默认header的title和content，默认的headerView具有左右两个label
- (void)setHeaderTitle:(NSString *)title content:(NSString *)content forSection:(NSUInteger)section;
/// 设置headerView，section传nil可以设置全部
- (void)setHeaderView:(UIView *)view forSection:(NSArray<NSNumber *> *)section;
- (UIView *)headerViewForSection:(NSUInteger)section;

/// 整个form的headerView
@property (nonatomic, strong) UIView *headerView;
/// 整个form的footerView
@property (nonatomic, strong) UIView *footerView;

#pragma mark - cell's value
/// 为cell中指定的控件赋值
- (void)setContentValue:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath;
- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath;
- (void)setPlaceholder:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - cell's subviews
- (void)setInputEnable:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath;
- (void)setKeyboardType:(UIKeyboardType)type atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - check
/// 检测inputField和inputText是否为空，返回为空的cell的indexPath
- (NSArray<NSIndexPath *> *)checkIsEmpty:(NSArray<NSIndexPath *> *)indexPaths;
/// 将cell的输入框标红，用于提示输入
- (void)setCellInputEmptyAlert:(NSArray<NSIndexPath *> *)rows;

#pragma styles
- (void)setCellBackgroundColor:(UIColor *)color;
- (void)setCellSeperatorInsets:(UIEdgeInsets)insets;
- (void)setCellSeperatorColor:(UIColor *)color;

- (void)setTitleFont:(UIFont *)titleFont;
- (void)setTitleColor:(UIColor *)titleColor;
- (void)setInputFieldFont:(UIFont *)inputFieldFont;
- (void)setInputFieldTextColor:(UIColor *)inputFieldTextColor;
- (void)setInputViewFont:(UIFont *)inputViewFont;
- (void)setInputViewTextColor:(UIColor *)inputViewTextColor;
- (void)setDetailFont:(UIFont *)detailFont;
- (void)setDetailTextColor:(UIColor *)detailTextColor;
- (void)setSubDetailFont:(UIFont *)subDetailFont;
- (void)setSubDetailTextColor:(UIColor *)subDetailTextColor;

#pragma mark - 试验性功能
/// 一个cell出现的动画
@property (nonatomic, assign) BOOL cellShowAnimation;
@end

