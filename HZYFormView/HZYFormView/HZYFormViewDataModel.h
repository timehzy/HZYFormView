//
//  HZYFormViewDataModel.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/5/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZYFormViewDataModel : NSObject
@property (nonatomic, copy) NSArray *cellArray;
@property (nonatomic, copy) NSArray<NSNumber *> *sectionRowCountArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *sectionHeaderHeightArray;
@property (nonatomic, strong) NSMutableArray *sectionHeaderViewArray;
@property (nonatomic, strong) NSMutableArray *sectionRowHeightArray;
@property (nonatomic, strong) NSMutableArray *cellAccessoryArray;
@property (nonatomic, strong) NSMutableArray *cellHideArray;
@property (nonatomic, strong) NSMutableDictionary *customCellDictionary;
@property (nonatomic, strong) NSMutableArray *allCellTypeArray;//d:默认 c:自定义
@property (nonatomic, strong) NSMutableArray *optionsArray;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *placeholders;
@property (nonatomic, copy) NSArray *inputTexts;
@property (nonatomic, copy) NSArray *details;
@property (nonatomic, copy) NSArray *subDetails;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, copy) NSArray *checkmarks;//@0=normal,@1=selected，@2=disable


@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *inputFieldFont;
@property (nonatomic, strong) UIColor *inputFieldTextColor;
@property (nonatomic, strong) UIFont *inputViewFont;
@property (nonatomic, strong) UIColor *inputViewTextColor;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIFont *subDetailFont;
@property (nonatomic, strong) UIColor *subDetailTextColor;
@end
