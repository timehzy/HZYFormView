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
// 👇下面的属性可以一次性设置section中每个cell的值
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *placeholders;
@property (nonatomic, copy) NSArray *inputTexts;
@property (nonatomic, copy) NSArray *details;
@property (nonatomic, copy) NSArray *subDetails;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, copy) NSArray *checkmarks;//@0=normal,@1=selected，@2=disable
// 👆

#pragma mark - init
+ (instancetype)formViewWithFrame:(CGRect)frame sectionRows:(NSArray<NSNumber *> *)sectionRows;
/// 所有布局相关的参数设置完成后调用
- (void)configComplete;
- (void)refresh;
@property (nonatomic, weak) id<HZYFormViewDelegate> delegate;

#pragma mark - cell
/// row传-1可以设置整个section
- (void)setHeight:(CGFloat)height forRow:(NSUInteger)row inSection:(NSUInteger)section animate:(BOOL)animate;
/// 设置cell的样式
- (void)setCellOptions:(HZYFormViewCellOption)options forRowsAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths;
/// 设置view的附件属性
- (void)setCellAccessory:(NSDictionary *)dict forRow:(NSUInteger)row inSection:(NSUInteger)section;
/// 设置自定义的view作为一个cell
- (void)setCustomView:(HZYFormViewCell *)view forRow:(NSUInteger)row inSection:(NSUInteger)section;
// 这个方法实际上是通过KVC来赋值，有些属性这样做不好使，例如keyboardType，使用的时候注意一下
// 👆以上方法需在configComplete方法之前执行
- (void)setCellContent:(HZYFormViewCellOption)contentOption property:(NSString *)property value:(id)value InSectionsRow:(NSArray *)sectionRowArray;
//如果单独设置了cell的height则读取该属性无意义
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, assign) UIEdgeInsets seperatorInsets;
@property (nonatomic, strong) UIColor *seperatorColor;
/// 返回指定section的row个数
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (HZYFormViewCell *)cellForRow:(NSUInteger)row inSection:(NSUInteger)section;
/// 获取可见的cell
- (NSArray<HZYFormViewCell *> *)visibleCells;
// 必须传一个二维数组，例如要隐藏第1个section的第2、3个cell、第3个section的第1个cell、第4个section的全部cell，则传@[@[@1, @2], @[], @[@0], @[@-1]]
- (void)hide:(BOOL)hidden Cell:(NSArray *)sectionRowArray animate:(BOOL)animate;

#pragma mark - section
/// 设置section headerView。section传nil可以统一设置所有section
- (void)setHeaderHeight:(CGFloat)height forSection:(NSArray<NSNumber *> *)section;
/// 设置默认header的title和content，默认的headerView具有左右两个label
- (void)setHeaderTitle:(NSString *)title content:(NSString *)content forSection:(NSUInteger)section;
- (void)setHeaderView:(UIView *)view forSection:(NSArray<NSNumber *> *)section;
- (UIView *)headerViewForSection:(NSUInteger)section;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

#pragma mark - cell's value
/**
 该方法会根据cell的主要option进行赋值，例如optin为HZYFormViewCellContentDetail | HZYFormViewCellContentCitySelector
 那么传入一个字符串会成为detailLabel的text。
 */
- (void)setContentValue:(id)value forCellAtIndexPath:(NSIndexPath *)indexPath;
/// 为cell中指定的控件赋值
- (void)setContentValue:(id)value forCellOptions:(HZYFormViewCellOption)options atIndexPath:(NSIndexPath *)indexPath;
/// 返回指定cell上的值，根据cell的类型不同，会返回字符串，图片或图片数组
- (id)getValueFromCellAtIndex:(NSIndexPath *)index;
- (id)getValueFromCellOptions:(HZYFormViewCellOption)options atIndex:(NSIndexPath *)indexPath;


#pragma mark - cell's subviews
- (void)setInputViewEnable:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath;
- (void)setKeyboardType:(UIKeyboardType)type atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - check
/// 检测inputField和inputText是否为空，返回为空的cell的indexPath
- (NSArray<NSIndexPath *> *)checkIsEmpty:(NSArray<NSIndexPath *> *)indexPaths;
/// 将cell的输入框标红，用于提示输入
- (void)setCellInputEmptyAlert:(NSArray<NSIndexPath *> *)rows;

#pragma styles
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

#pragma mark - deprecated
/// 使用rows参数指定cell来设置options，如果想为整个section的cell赋值则rows传nil，如果想为整个表单的cell赋值则sections传nil
- (void)setCellOptions:(HZYFormViewCellOption)options forRows:(NSArray<NSNumber *> *)rows inSections:(NSArray<NSNumber *> *)sections NS_EXTENSION_UNAVAILABLE_IOS("use setCellOptions:forRowsAtIndexPath:");
@end

