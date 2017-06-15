//
//  HZYDatePicker.m
//  CMM
//
//  Created by Michael-Nine on 2017/4/26.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#import "HZYDatePicker.h"

static NSInteger kHeight = 200;
@interface HZYDatePicker ()
@property (nonatomic, copy) void(^selectedHandler)(NSDate *date, BOOL isCanceled);
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, assign) UIDatePickerMode mode;

@end
@implementation HZYDatePicker

+ (void)datePicker:(UIDatePickerMode)mode selectedHandler:(void(^)(NSDate *date, BOOL isCanceled))handler {
    HZYDatePicker *picker = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds mode:mode];
    picker.selectedHandler = handler;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(UIDatePickerMode)mode {
    if (self = [super initWithFrame:frame]) {
        [self configUI:mode];
    }
    return self;
}

- (void)configUI:(UIDatePickerMode)mode {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, kHeight)];
    _datePicker.datePickerMode = mode;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [self addSubview:_datePicker];
    
    _titleContainer = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 49, self.bounds.size.width, 49)];
    _titleContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleContainer];
    
    _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, 49)];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [_titleContainer addSubview:_confirmBtn];
    
    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2, 49)];
    [_cancelBtn addTarget:self action:@selector(cancelBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_titleContainer addSubview:_cancelBtn];
    
    CALayer *sep1 = [CALayer layer];
    sep1.frame = CGRectMake(self.bounds.size.width / 2, 0, 0.5, 49);
    sep1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [_titleContainer.layer addSublayer:sep1];
    
    CALayer *sep2 = [CALayer layer];
    sep2.frame = CGRectMake(0, 48, self.bounds.size.width, 0.5);
    sep2.backgroundColor = [UIColor lightGrayColor].CGColor;
    [_titleContainer.layer addSublayer:sep2];
    [self show];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:.5];
        _titleContainer.transform = CGAffineTransformMakeTranslation(0, -kHeight);
        _datePicker.transform = CGAffineTransformMakeTranslation(0, -kHeight);
    }];
}

- (void)confirmBtnTouched{
    if (self.selectedHandler) {
        self.selectedHandler(self.datePicker.date, NO);
    }
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        _datePicker.transform = CGAffineTransformIdentity;
        _titleContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelBtnTouched{
    if (self.selectedHandler) {
        self.selectedHandler(self.datePicker.date, YES);
    }
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        _datePicker.transform = CGAffineTransformIdentity;
        _titleContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
