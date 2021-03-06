//
//  HZYFormViewTypeDefine.h
//  CMM
//
//  Created by Michael-Nine on 2017/5/5.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#ifndef HZYFormViewTypeDefine_h
#define HZYFormViewTypeDefine_h

/**
 *可以搭配使用的控件的优先级，即同时出现时在cell中的位置如下：
 <TitleIcon><TitleText> <InputField><Detail><SubDetail><CheckMark><ActionButton><Indicator/Selector/Picker>
 */
typedef NS_OPTIONS(NSUInteger, HZYFormViewCellOption) {
    //👇这些可以搭配使用
    HZYFormViewCellContentInputField = 1 << 1,//右侧输入框，默认，单行输入。
    HZYFormViewCellContentDetail = 1 << 2,//右侧显示详情，字号颜色与title一样
    HZYFormViewCellContentSubDetail = 1 << 3,
    HZYFormViewCellContentCheckMark = 1 << 4,
    HZYFormViewCellContentActionButton = 1 << 5,
    HZYFormViewCellContentIndicator = 1 << 6,
    HZYFormViewCellContentSingleSelector = 1 << 7,
    HZYFormViewCellContentMultiSelector = 1 << 8,
    //👇这些最好单独使用
    HZYFormViewCellContentSinglePhotoPicker = 1 << 11,
    HZYFormViewCellContentMultiPhotoPicker = 1 << 12,
    HZYFormViewCellContentInputView = 1 << 13, //多行输入
    //👇这些是标题类型，可以混用
    HZYFormViewCellTitleText = 1 << 30,
    HZYFormViewCellTitleIcon = 1 << 40,
    
    /* 未实现 */
    HZYFormViewCellContentDatePickerDefault = 1 << 9,
    HZYFormViewCellContentDatePickerAtoB = 1 << 10,
    HZYFormViewCellContentCitySelector = 1 << 14,
};

typedef NS_ENUM(NSUInteger, HZYFormViewCheckmarkState) {
    HZYFormViewCheckmarkNormal,
    HZYFormViewCheckmarkSelected,
    HZYFormViewCheckmarkDisabled,
};

@protocol HZYFormCellSubViewProtocol <NSObject>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, strong) id value;
@optional;
@property (nonatomic, assign) CGFloat width;
@end

@protocol HZYFormCellSubViewPlaceholderProtocol <NSObject>
@property (nonatomic, strong) id placeholder;
@end

#define HZYFormViewDefaultBackgroundColor [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1/1.0]
#define HZYFormViewCellHeight 46
#define HZYFormViewSectionHeaderHeight 10
#define HZYFormViewCellOptions HZYFormViewCellTitleText | HZYFormViewCellContentInputField
#define HZYFormViewCellBackgroundColor [UIColor whiteColor]
#define HZYFormViewCellSeperatorInsets UIEdgeInsetsMake(0, 16, 0, 0)
#define HZYFormViewCellTitleFont [UIFont systemFontOfSize:16]
#define HZYFormViewCellTitleColor [UIColor blackColor]
#define HZYFormViewCellInputFieldFont [UIFont systemFontOfSize:16]
#define HZYFormViewCellInputFieldTextColor [UIColor blackColor]
#define HZYFormViewCellInputViewFont [UIFont systemFontOfSize:16]
#define HZYFormViewCellInputViewTextColor [UIColor blackColor]
#define HZYFormViewCellDetailTextColor [UIColor blackColor]
#define HZYFormViewCellDetailFont [UIFont systemFontOfSize:16]
#define HZYFormViewCellSubDetailTextColor [UIColor blueColor]
#define HZYFormViewCellSubDetailFont [UIFont systemFontOfSize:16]
#define HZYFormViewCellSeperatorInsets UIEdgeInsetsMake(0, 16, 0, 0)
#define HZYFormViewCellSeperatorColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1/1.0]
#define HZYFormViewCellAlertBorderColor [[UIColor redColor] colorWithAlphaComponent:.6]

/* cell accessory key */
extern NSString *const HZYFormCellAccessoryView;//用于为cell添加按钮，这个按钮将出现在cell末端，必须使用HZYFormButton, 设置width属性以保证布局正确

/* notifications */
/// image added in cell
extern NSNotificationName const HZYFormCellImageDidAddedNotification;
/// image deleted
extern NSNotificationName const HZYFormCellImageDidDeletedNotification;

/* notification userInfo key */
extern NSString *const HZYFormCellNewAddedImageKey;
extern NSString *const HZYFormCellNewAddedImageCellTitleKey;
extern NSString *const HZYFormCellNewAddedImageIndexKey;
extern NSString *const HZYFormCellDeletedImageIndexKey;
extern NSString *const HZYFormCellDeletedImageRemainCountKey;

/* value key */
extern NSString *const HZYFormViewCellValueBeginDateKey;
extern NSString *const HZYFormViewCellValueEndDateKey;
extern NSString *const HZYFormViewCellValueDistrictNameKey;
extern NSString *const HZYFormViewCellValueCityNameKey;
extern NSString *const HZYFormViewCellValueProvinceNameKey;

#endif /* HZYFormViewTypeDefine_h */
