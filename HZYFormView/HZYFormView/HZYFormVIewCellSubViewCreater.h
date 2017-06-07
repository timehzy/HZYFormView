//
//  HZYFormVIewCellSubViewCreater.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/5/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"

@class HZYFormViewCell;
@class HZYFormViewDataModel;
@interface HZYFormVIewCellSubViewCreater : NSObject
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel;

- (HZYFormViewCell *)createCellSubviews:(HZYFormViewCell *)cell options:(HZYFormViewCellOption)options atSection:(NSUInteger)i row:(NSUInteger)j;
@end
