//
//  HZYFormViewCell.h
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/4/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYPicturePickerView.h"
#import "HZYFormViewCellSubViews.h"
#import "HZYFormViewDefine.h"

extern NSInteger const HZYFormCellSeperatorTag;
@class HZYFormViewDataModel;
@interface HZYFormViewCell : UIView<HZYPicturePickerViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame;

- (void)layoutFormViews;
- (UIView<HZYFormCellSubViewProtocol> *)subviewForStringTag:(NSString *)tag;
- (UIView<HZYFormCellSubViewProtocol> *)subViewForType:(HZYFormViewCellOption)type;

- (void)setContentValue:(id)value forOptions:(HZYFormViewCellOption)option;
- (void)setPlaceholder:(id)value forOptions:(HZYFormViewCellOption)options;
- (id)getContentValueForOptions:(HZYFormViewCellOption)options;

@property (nonatomic, copy) void(^tapHandler)();
@property (nonatomic, copy) void(^nextEditAction)();
@property (nonatomic, copy) NSString *stringTag;

/// 当通过HZYFormView- (void)setContentValue: forCellAtIndexPath:方法设置selector类型的cell时，会为此属性赋值
@property (nonatomic, copy) NSArray *selectList;
/// 选择器选中的index数组
@property (nonatomic, copy) NSArray *selectedArray;
/// 如果使用AtoB日期选择器，则这两个参数有效，使用single日期选择器，则startDate有效
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
/// 返回选中的省市区字典
@property (nonatomic, copy) NSDictionary *cityDict;


@property (nonatomic, assign, getter=isVisible) BOOL visible;
@property (nonatomic, assign) BOOL shouldShowAnimation;
@property (nonatomic, assign) BOOL inputUserInteractionEnable;
@property (nonatomic, assign) UIKeyboardType inputKeyboardType;
@property (nonatomic, assign) NSTextAlignment inputTextAlignment;


@property (nonatomic, assign) HZYFormViewCellOption options;
@property (nonatomic, assign) HZYFormViewCellOption selectorRelatedView;

@property (nonatomic, weak) UIView *seperator;
@end

