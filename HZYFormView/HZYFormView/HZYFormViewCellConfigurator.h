//
//  HZYFormViewSetter.h
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"

@class HZYFormViewDataModel;
@class HZYFormViewCell;
@interface HZYFormViewCellConfigurator : NSObject
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel forRow:(NSUInteger)row inSection:(NSUInteger)section;
- (HZYFormViewCell *)configedCell;

/// indexPath传nil可以设置全部高度，indexpath.row传-1可以设置section每个cell的高度
- (void)height:(CGFloat)height;
/// 设置cell的样式
- (void)options:(HZYFormViewCellOption)options;
- (void)inputEnable:(BOOL)enable;
- (void)keyboardType:(UIKeyboardType)type;
- (void)inputFieldAlignment:(NSTextAlignment)alignment;
- (void)selectorRelatedView:(HZYFormViewCellOption)viewOption;
- (void)title:(NSString *)title;
- (void)icon:(UIImage *)icon;
- (void)placeholder:(id)placeholder;
- (void)inputText:(NSString *)text;
- (void)detail:(NSString *)detail;
- (void)subDetail:(NSString *)subDetail;
- (void)picture:(UIImage *)picture;
- (void)pictures:(NSArray *)pictures;
- (void)selectList:(NSArray *)selectList;
- (void)checkmark:(HZYFormViewCheckmarkState)state;

@end
