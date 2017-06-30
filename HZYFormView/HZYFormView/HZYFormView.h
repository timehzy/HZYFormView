//
//  HZYFormView.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/4/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"
#import "HZYFormViewCellConfigurator.h"
#import "HZYFormViewSectionHeaderConfigurator.h"

@class HZYFormViewCell;
@class HZYFormView;
@protocol HZYFormViewDelegate <NSObject, UIScrollViewDelegate>
- (void)formView:(HZYFormView *)formView cellDidSelected:(HZYFormViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end

@interface HZYFormView : UIScrollView
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows;

@property (nonatomic, weak) id<HZYFormViewDelegate> delegate;
/// 点击return自动输入下一个cell
@property (nonatomic, assign) BOOL autoNext;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

/// 单独配置一个cell的样式和值
- (void)configCellForRow:(NSUInteger)row inSection:(NSUInteger)section settings:(void(^)(HZYFormViewCellConfigurator *set))setting;
/// 单独配置一个section header的样式和值
- (void)configSection:(NSUInteger)section settings:(void(^)(HZYFormViewSectionHeaderConfigurator *set))setting;

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (HZYFormViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (void)setCustomViewAsCell:(UIView *)view atIndexPath:(NSIndexPath *)indexPath;
- (UIView *)headerViewForSection:(NSUInteger)section;
- (void)setHeaderView:(UIView *)view forSection:(NSUInteger)section;
// 必须传一个二维数组，例如要隐藏第1个section的第2、3个cell、第3个section的第1个cell、第4个section的全部cell，则传@[@[@1, @2], @[], @[@0], @[@-1]]
- (void)hide:(BOOL)hidden cellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animate:(BOOL)animate;
@end


/**
 与表单中的值有关的操作都在该分类中
 */
@interface HZYFormView (HZYFormViewValue)
// 一次性设置每个cell的值
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *icons;
@property (nonatomic, copy) NSArray *placeholders;
@property (nonatomic, copy) NSArray *inputTexts;
@property (nonatomic, copy) NSArray *details;
@property (nonatomic, copy) NSArray *subDetails;
@property (nonatomic, copy) NSArray *pictures;//针对单张图片选择器，数组元素应该为图片，针对多张图片，数组元素应该为图片数组
@property (nonatomic, copy) NSArray *checkmarks;//@0=normal,@1=selected，@2=disable
- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath;
- (NSArray *)getAllValues;
/// 检测inputField和inputText是否为空，返回为空的cell的indexPath
- (NSArray<NSIndexPath *> *)checkIsEmpty:(NSArray<NSIndexPath *> *)indexPaths;
/// 将cell的输入框标红，用于提示输入
- (void)setCellInputEmptyAlert:(NSArray<NSIndexPath *> *)rows;
@end


/**
 表单整体UI设置
 */
@interface HZYFormView (HZYFormViewStyleSetting)
- (void)setInputTextAlignment:(NSTextAlignment)alignment;
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
