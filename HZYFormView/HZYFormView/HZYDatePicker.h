//
//  HZYDatePicker.h
//  CMM
//
//  Created by Michael-Nine on 2017/4/26.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZYDatePicker : UIView
+ (void)datePicker:(UIDatePickerMode)mode selectedHandler:(void(^)(NSDate *date))handler;
@end
