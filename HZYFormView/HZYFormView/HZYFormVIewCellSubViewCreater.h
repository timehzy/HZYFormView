//
//  HZYFormVIewCellSubViewCreater.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/5/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZYFormViewDataModel;
@interface HZYFormVIewCellSubViewCreater : NSObject
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel;

- (void)createCellSubviewsForRow:(NSUInteger)row inSection:(NSUInteger)section accessory:(NSDictionary *)accessory;
@end
