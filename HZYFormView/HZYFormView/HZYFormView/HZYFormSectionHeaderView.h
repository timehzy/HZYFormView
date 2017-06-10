//
//  HZYFormSectionHeaderView.h
//  CMM
//
//  Created by Michael-Nine on 2017/5/4.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZYFormSectionHeaderView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLable;

- (void)customLayout;
@end
