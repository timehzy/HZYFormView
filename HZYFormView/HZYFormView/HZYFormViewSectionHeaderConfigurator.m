//
//  HZYFormViewSectionConfigurator.m
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormViewSectionHeaderConfigurator.h"
#import "HZYFormViewDataModel.h"
#import "HZYFormSectionHeaderView.h"

@interface HZYFormViewSectionHeaderConfigurator ()
@property (nonatomic, strong) HZYFormSectionHeaderView *headerView;
@property (nonatomic, strong) HZYFormViewDataModel *dataModel;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger section;
@end

@implementation HZYFormViewSectionHeaderConfigurator
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel forSection:(NSUInteger)section {
    if (self = [super init]) {
        _dataModel = dataModel;
        _headerView = [dataModel getSectionHeaderViewForSection:section];
        _section = section;
    }
    return self;
}

- (HZYFormSectionHeaderView *)configedHeader {
    return self.headerView;
}

- (void)height:(CGFloat)height {
    CGRect frame = self.headerView.frame;
    frame.size.height = height;
    self.headerView.frame = frame;
}

- (void)title:(NSString *)title {
    self.headerView.titleLabel.text = title;
}

- (void)content:(NSString *)content {
    self.headerView.contentLable.text = content;
}
@end
