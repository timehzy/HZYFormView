//
//  HZYFormViewSetter.m
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormViewConfigurator.h"
#import "HZYFormViewCell.h"

@interface HZYFormViewConfigurator ()
@property (nonatomic, strong) HZYFormViewCell *cell;
@end

@implementation HZYFormViewConfigurator
#pragma mark - public
- (instancetype)initWithCell:(HZYFormViewCell *)cell {
    if (self = [super init]) {
        _cell = cell;
    }
    return self;
}

- (HZYFormViewCell *)configedCell {
    return self.cell;
}

- (void)height:(CGFloat)height {
    CGRect frame = self.cell.frame;
    frame.size.height = height;
    self.cell.frame = frame;
}

- (void)options:(HZYFormViewCellOption)options {
    self.cell.options = options;
}

- (void)inputEnable:(BOOL)enable {
    [self getInputView].userInteractionEnabled = enable;
}

- (void)keyboardType:(UIKeyboardType)type {
    [self getInputView].keyboardType = type;
}

- (void)inputFieldAlignment:(NSTextAlignment)alignment {
    [self getInputView].textAlignment = alignment;
}

- (void)selectorRelatedView:(HZYFormViewCellOption)viewOption {
    self.cell.selectorRelatedView = viewOption;
}

- (void)value:(id)value forOption:(HZYFormViewCellOption)option {
    [self.cell setContentValue:value forOptions:option];
}

- (void)placeholder:(id)placeholder forOption:(HZYFormViewCellOption)option {
    [self.cell setPlaceholder:placeholder forOptions:option];
}

- (void)headerHeight:(CGFloat)height {
    
}

- (void)headerTitle:(NSString *)title content:(NSString *)content {
    
}

#pragma mark - private
- (HZYFormInputView *)getInputView {
    HZYFormInputView *inputView = (HZYFormInputView *)[self.cell subViewForType:HZYFormViewCellContentInputView];
    if (!inputView) {
        inputView = (HZYFormInputView *)[self.cell subViewForType:HZYFormViewCellContentInputField];
    }
    return inputView;
}
@end
