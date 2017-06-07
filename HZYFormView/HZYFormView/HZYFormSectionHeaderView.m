//
//  HZYFormSectionHeaderView.m
//  CMM
//
//  Created by Michael-Nine on 2017/5/4.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#import "HZYFormSectionHeaderView.h"
#import "Masonry.h"

@interface HZYFormSectionHeaderView ()


@end
@implementation HZYFormSectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [self createLabel];
        _contentLable = [self createLabel];
    }
    return self;
}

- (void)customLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-4);
        make.leading.equalTo(self).offset(16);
    }];
    
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-4);
        make.trailing.equalTo(self).offset(-16);
    }];
}

- (UILabel *)createLabel {
    UILabel *label =  [UILabel new];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    return label;
}
@end
