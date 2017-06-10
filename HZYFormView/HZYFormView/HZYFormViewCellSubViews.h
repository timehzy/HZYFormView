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
+ (instancetype)labelWithType:(HZYFormViewCellOption)type;
@end

@interface HZYFormInputField : UITextField<HZYFormCellSubViewProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@end

@interface HZYFormButton : UIButton<HZYFormCellSubViewProtocol>
+ (instancetype)buttonWithOption:(HZYFormViewCellOption)type;
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, assign) CGFloat width;

@end

@interface HZYFormImageView : UIImageView<HZYFormCellSubViewProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL didSetImage;
@property (nonatomic, readonly) id value;
@end

@interface HZYFormInputView : UITextView<HZYFormCellSubViewProtocol>
@property (nonatomic, assign) HZYFormViewCellOption type;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, readonly) NSString *value;
@end
