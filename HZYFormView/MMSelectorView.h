//
//  MMSelectorView.h
//  CMM
//
//  Created by Melody_Zhy on 2016/12/19.
//  Copyright © 2016年 zuozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectorBlock)(NSArray *indexList);
typedef void(^SelectorCancleDismissBlock)();

@interface MMSelectorView : UIView

/**
 进入时默认选择的行
 */
@property (nonatomic, copy) NSString *selectedRow;

/**
 dismiss时调用的block
 */
@property (nonatomic, copy) SelectorCancleDismissBlock SelectorCancleDismissBlock;

/**
 初始化选择弹框
 @param list 选择弹框里面的数据
 @param multipled 是否是 多选
 @return 选择弹框
 */
- (instancetype)initWithList:(NSArray *)list multipled:(BOOL)multipled;

/**
 *  显示选择弹框
 *
 *  @param animation  是否需要show和dismiss动画
 *  @param selectorBlock 按钮点击回调
 */
- (void)showSelectorViewWithAnimation:(BOOL)animation alertBlock:(SelectorBlock)selectorBlock;

@end
