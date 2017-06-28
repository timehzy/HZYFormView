//
//  HZYFormViewSetter.h
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"

@class HZYFormViewCell;

@interface HZYFormViewConfigurator : NSObject
- (instancetype)initWithCell:(HZYFormViewCell *)cell;
- (HZYFormViewCell *)configedCell;

/// indexPath传nil可以设置全部高度，indexpath.row传-1可以设置section每个cell的高度
- (void)height:(CGFloat)height;
/// 设置cell的样式
- (void)options:(HZYFormViewCellOption)options;
- (void)inputEnable:(BOOL)enable;
- (void)keyboardType:(UIKeyboardType)type;
- (void)inputFieldAlignment:(NSTextAlignment)alignment;
- (void)selectorRelatedView:(HZYFormViewCellOption)viewOption;

- (void)value:(id)value forOption:(HZYFormViewCellOption)option;
- (void)placeholder:(id)placeholder forOption:(HZYFormViewCellOption)option;

/// 设置section headerView。section传nil可以统一设置所有section
- (void)headerHeight:(CGFloat)height;
/// 设置默认header的title和content，默认的headerView具有左右两个label
- (void)headerTitle:(NSString *)title content:(NSString *)content;
/// 设置headerView，section传nil可以设置全部
@end
