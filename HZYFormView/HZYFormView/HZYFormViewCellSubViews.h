//
//  HZYFomViewCellSubViews.h
//  CMM
//
//  Created by Michael-Nine on 2017/5/5.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"


@interface HZYFormLabel : UILabel<HZYFormCellSubViewProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, strong) NSString *value;
+ (instancetype)labelWithType:(HZYFormViewCellOption)type;
@end

@interface HZYFormInputField : UITextField<HZYFormCellSubViewProtocol, HZYFormCellSubViewPlaceholderProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, strong) NSString *value;
@end

@interface HZYFormButton : UIButton<HZYFormCellSubViewProtocol>
+ (instancetype)buttonWithOption:(HZYFormViewCellOption)type;
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) id value;
@end

@interface HZYFormImageView : UIImageView<HZYFormCellSubViewProtocol, HZYFormCellSubViewPlaceholderProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL didSetImage;
@property (nonatomic, strong) id value;
@end

@interface HZYFormInputView : UITextView<HZYFormCellSubViewProtocol, HZYFormCellSubViewPlaceholderProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *value;
@end
