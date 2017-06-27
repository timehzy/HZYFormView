//
//  HZYFomViewCellSubViews.m
//  CMM
//
//  Created by Michael-Nine on 2017/5/5.
//  Copyright © 2017年 zuozheng. All rights reserved.
//

#import "HZYFormViewCellSubViews.h"
#import "UIImageView+WebCache.h"


@implementation HZYFormLabel
+ (instancetype)labelWithType:(HZYFormViewCellOption)type {
    HZYFormLabel *label = [HZYFormLabel new];
    label.type = type;
    return label;
}
@end

@implementation HZYFormInputField
- (instancetype)init {
    if (self = [super init]) {
        _type = HZYFormViewCellContentInputField;
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.returnKeyType = UIReturnKeyNext;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)beginEdit:(NSNotification *)noty {
    if (noty.object == self) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.layer.borderColor = [UIColor clearColor].CGColor;
}
@end

@implementation HZYFormButton
+ (instancetype)buttonWithOption:(HZYFormViewCellOption)type {
    HZYFormButton *btn = [HZYFormButton new];
    btn.type = type;
    return btn;
}

@end

@implementation HZYFormImageView{
    BOOL _didSetImage;
}
- (instancetype)init {
    if (self = [super init]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPlaceholder:(UIImage *)placeholder {
    if ([placeholder isKindOfClass:[UIImage class]]) {
        _placeholder = placeholder;
        if (!self.image) {
            self.image = placeholder;
        }
    }
}

- (void)setImage:(UIImage *)image {
    if (image == nil) {
        _didSetImage = NO;
        self.url = nil;
        [super setImage:self.placeholder];
    }else{
        self.url = nil;
        _didSetImage = YES;
        [super setImage:image];
    }
}

- (UIImage *)image {
    if (_didSetImage) {
        return [super image];
    }else{
        return nil;
    }
}

- (void)setUrl:(NSString *)url {
    if (!url) {
        _url = nil;
        return;
    }
    _url = url;
    [self sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (id)value {
    if ([self.image isEqual:self.placeholder]) {
        return [NSNull null];
    }else if (_didSetImage) {
        return self.image;
    }else{
        return self.url;
    }
}
@end

@implementation HZYFormInputView{
    BOOL _isPlaceholder;
}
- (instancetype)init {
    if (self = [super init]) {
        _type = HZYFormViewCellContentInputView;
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.textContainerInset = UIEdgeInsetsMake(8, 0, 0, 0);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginEdit:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endEdit:) name:UITextViewTextDidEndEditingNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)becomeFirstResponder {
    if (_isPlaceholder) {
        self.textColor = [UIColor blackColor];
        self.text = nil;
    }
    self.layer.borderColor = [UIColor clearColor].CGColor;
    return [super becomeFirstResponder];
}

- (void)beginEdit:(NSNotification *)noty {
    if (noty.object == self) {
        if (_isPlaceholder) {
            self.textColor = [UIColor blackColor];
            self.text = nil;
        }
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)endEdit:(NSNotification *)noty {
    if (noty.object == self) {
        if (self.text.length == 0) {
            self.text = self.placeholder;
            self.textColor = [UIColor lightGrayColor];
            _isPlaceholder = YES;
        }else{
            _isPlaceholder = NO;
        }
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if ([text isEqualToString:@""] && self.placeholder.length > 0) {
        self.text = self.placeholder;
        self.textColor = [UIColor lightGrayColor];
        _isPlaceholder = YES;
    }else{
        self.textColor = [UIColor blackColor];
        _isPlaceholder = NO;
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (self.text.length == 0) {
        self.text = placeholder;
        self.textColor = [UIColor lightGrayColor];
        _isPlaceholder = YES;
    }
}

- (NSString *)value {
    if (_isPlaceholder) {
        return @"";
    }else{
        return self.text;
    }
}
@end
