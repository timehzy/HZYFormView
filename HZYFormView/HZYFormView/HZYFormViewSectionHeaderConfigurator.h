//
//  HZYFormViewSectionConfigurator.h
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZYFormViewDataModel;
@class HZYFormSectionHeaderView;

@interface HZYFormViewSectionHeaderConfigurator : NSObject
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel forSection:(NSUInteger)section;
- (HZYFormSectionHeaderView *)configedHeader;



/// 设置section headerView。section传nil可以统一设置所有section
- (void)height:(CGFloat)height;
/// 设置默认header的title和content，默认的headerView具有左右两个label
- (void)title:(NSString *)title;
/// 设置headerView，section传nil可以设置全部
- (void)content:(NSString *)content;
@end
