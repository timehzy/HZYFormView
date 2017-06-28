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
#import "HZYFormViewConfigurator.h"
@class HZYFormViewCell;
@class HZYFormViewConfigurator;
@class HZYFormView;
@protocol HZYFormViewDelegate <NSObject, UIScrollViewDelegate>
- (void)formView:(HZYFormView *)formView cellDidSelected:(HZYFormViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end

@interface HZYFormView : UIScrollView

#pragma mark - init
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows;
@property (nonatomic, weak) id<HZYFormViewDelegate> delegate;

#pragma mark - cell
/// 设置自定义的view作为一个cell
- (void)setCustomViewAsCell:(UIView *)view atIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (HZYFormViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray<HZYFormViewCell *> *)visibleCells;

// 必须传一个二维数组，例如要隐藏第1个section的第2、3个cell、第3个section的第1个cell、第4个section的全部cell，则传@[@[@1, @2], @[], @[@0], @[@-1]]
- (void)hide:(BOOL)hidden cellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animate:(BOOL)animate;

#pragma mark - section
- (void)setHeaderView:(UIView *)view forSection:(NSArray<NSNumber *> *)section;
- (UIView *)headerViewForSection:(NSUInteger)section;

/// 整个form的headerView
@property (nonatomic, strong) UIView *headerView;
/// 整个form的footerView
@property (nonatomic, strong) UIView *footerView;

#pragma mark - cell's value
// 一次性设置每个cell的值
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *icons;
@property (nonatomic, copy) NSArray *placeholders;
@property (nonatomic, copy) NSArray *inputTexts;
@property (nonatomic, copy) NSArray *details;
@property (nonatomic, copy) NSArray *subDetails;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, copy) NSArray *checkmarks;//@0=normal,@1=selected，@2=disable
/// 为cell中指定的控件赋值
- (void)setContentValue:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath;
- (void)setPlaceholder:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath;

- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath;
- (NSArray *)getAllValues;

#pragma mark - check
/// 检测inputField和inputText是否为空，返回为空的cell的indexPath
- (NSArray<NSIndexPath *> *)checkIsEmpty:(NSArray<NSIndexPath *> *)indexPaths;
/// 将cell的输入框标红，用于提示输入
- (void)setCellInputEmptyAlert:(NSArray<NSIndexPath *> *)rows;

#pragma mark - 试验性功能
/// 一个cell出现的动画
@property (nonatomic, assign) BOOL cellShowAnimation;
/// 点击return自动输入下一个cell
@property (nonatomic, assign) BOOL autoNext;

#pragma mark - new
- (void)configCellForRow:(NSUInteger)row inSection:(NSUInteger)section settings:(void(^)(HZYFormViewConfigurator *set))setting;
- (void)configCellForRow:(NSUInteger)row inSection:(NSUInteger)section settings:(void(^)(HZYFormViewConfigurator *set))setting values:(void(^)(HZYFormViewConfigurator *set))values;

- (void)configSection:(NSUInteger)section settings:(void(^)(HZYFormViewConfigurator *set))setting;
@end

@interface HZYFormView (HZYFormViewStyleSetting)
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
@end





