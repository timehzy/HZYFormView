//
//  HZYFormViewCell.m
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/4/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormViewCell.h"
#import "Masonry.h"
#import "MMSelectorView.h"
#import "HZYDatePicker.h"

NSString *const HZYFormCellNewAddedImageKey = @"HZYFormCellNewAddedImageKey";
NSString *const HZYFormCellNewAddedImageCellTitleKey = @"HZYFomeCellNewAddedImageCellTitleKey";
NSString *const HZYFormCellNewAddedImageIndexKey = @"HZYFormCellNewAddedImageIndexKey";
NSString *const HZYFormCellDeletedImageIndexKey = @"HZYFormCellDeletedImageIndexKey";
NSString *const HZYFormCellDeletedImageRemainCountKey = @"HZYFormCellDeletedImageRemainCountKey";
NSInteger const HZYFormCellSeperatorTag = 3313;
NSString *const HZYFormViewCellValueDistrictNameKey = @"HZYFormViewCellValueDistrictNameKey";
NSString *const HZYFormViewCellValueCityNameKey = @"HZYFormViewCellValueCityNameKey";
NSString *const HZYFormViewCellValueProvinceNameKey = @"HZYFormViewCellValueProvinceNameKey";

NSNotificationName const HZYFormCellImageDidAddedNotification = @"HZYFormCellImageDidAddedNotification";
NSNotificationName const HZYFormCellImageDidDeletedNotification = @"HZYFormCellImageDidDeletedNotification";
@interface HZYFormViewCell ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) UIView *dateBgView;
@end
@implementation HZYFormViewCell{
    NSMutableDictionary *_subViewStringTagDict;
    NSMutableDictionary *_subViewTypeDict;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _subViewTypeDict = [NSMutableDictionary dictionary];
        _subViewStringTagDict = [NSMutableDictionary dictionary];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        _options = HZYFormViewCellOptions;
        _selectorRelatedView = HZYFormViewCellContentInputField;
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

#pragma mark - public
- (void)layoutFormViews {
    if (self.subviews.count == 1) {
        [self layoutSingleSubView];
    }else{
        [self layoutMultiSubViews];
    }
    [self layoutSeperator];
    [self disableInputFieldInSelector];
}

- (UIView<HZYFormCellSubViewProtocol> *)subviewForStringTag:(NSString *)tag {
    return [_subViewStringTagDict objectForKey:tag];
}

- (UIView<HZYFormCellSubViewProtocol> *)subViewForType:(HZYFormViewCellOption)type {
    return [_subViewTypeDict objectForKey:[NSNumber numberWithInteger:type]];
}

- (void)setContentValue:(id)value forOptions:(HZYFormViewCellOption)option {
    UIView *subView = [self subViewForType:option];
    if (!subView) {
        return;
    }
    switch (option) {
        case HZYFormViewCellTitleIcon:
        case HZYFormViewCellContentIndicator:
            NSAssert([value isKindOfClass:[UIImage class]], @"value must be a UIImage object");
            ((HZYFormImageView *)subView).image = value;
            break;
        case HZYFormViewCellContentCheckMark:
            ((HZYFormButton *)subView).selected = [value boolValue];
            break;
        case HZYFormViewCellContentDatePickerAtoB:
            self.startDate = value[HZYFormViewCellValueBeginDateKey];
            self.endDate = value[HZYFormViewCellValueEndDateKey];
            break;
        case HZYFormViewCellContentDatePickerDefault:
            self.startDate = value;
            break;
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
            self.selectList = value;
            break;
        case HZYFormViewCellContentSinglePhotoPicker:
            if ([value isKindOfClass:[UIImage class]]) {
                ((HZYFormImageView *)subView).image = value;
            } else {
                ((HZYFormImageView *)subView).url = value;
            }
            break;
        case HZYFormViewCellTitleText:
        case HZYFormViewCellContentDetail:
        case HZYFormViewCellContentSubDetail:
            NSAssert([value isKindOfClass:[NSString class]], @"value must be a NSString object");
            ((HZYFormLabel*)subView).text = value;
            break;
        case HZYFormViewCellContentInputView:
            NSAssert([value isKindOfClass:[NSString class]], @"value must be a NSString object");
            ((HZYFormInputView*)subView).text = value;
            break;
        case HZYFormViewCellContentInputField:
            NSAssert([value isKindOfClass:[NSString class]], @"value must be a NSString object");
            ((HZYFormInputField*)subView).text = value;
            break;
        case HZYFormViewCellContentMultiPhotoPicker:
            if ([[value firstObject]isKindOfClass:[UIImage class]]) {
                ((HZYPicturePickerView *)subView).pictures = value;
            }else{
                ((HZYPicturePickerView *)subView).urls = value;
            }
            break;
        case HZYFormViewCellContentActionButton:
        case HZYFormViewCellContentCitySelector:
            NSAssert(0, @"not support for set value in such view");
            break;
    }
}

- (id)getContentValueForOptions:(HZYFormViewCellOption)options {
    UIView *subView = [self subViewForType:options];
    if (!subView) {
        return [NSNull null];
    }
    switch (options) {
        case HZYFormViewCellTitleIcon:
        case HZYFormViewCellContentIndicator:
            return ((HZYFormImageView *)subView).image;
        case HZYFormViewCellContentCheckMark:
            return @(((HZYFormButton *)subView).isSelected);
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
            return self.selectedArray;
        case HZYFormViewCellContentSinglePhotoPicker:
            return ((HZYFormImageView *)subView).value;
        case HZYFormViewCellContentMultiPhotoPicker:
            return ((HZYPicturePickerView *)subView).values;
        case HZYFormViewCellContentDatePickerDefault:
            return self.startDate;
        case HZYFormViewCellContentDatePickerAtoB:
            return @{HZYFormViewCellValueBeginDateKey : self.startDate,
                     HZYFormViewCellValueEndDateKey : self.endDate};
        case HZYFormViewCellTitleText:
        case HZYFormViewCellContentDetail:
        case HZYFormViewCellContentSubDetail:
            return ((HZYFormLabel*)subView).text;
        case HZYFormViewCellContentInputView:
            return ((HZYFormInputView*)subView).value;
        case HZYFormViewCellContentInputField:
            return ((HZYFormInputField*)subView).text;
        case HZYFormViewCellContentCitySelector:
            return cell.cityDict;
        case HZYFormViewCellContentActionButton:
            NSAssert(0, @"not support for get value in such view");
            return nil;
    }
}

- (void)setPlaceholder:(id)value forOptions:(HZYFormViewCellOption)options {
    UIView *subView = [self subViewForType:options];
    if (!subView) {
        return;
    }
    switch (options) {
        case HZYFormViewCellContentDatePickerAtoB:
            self.startDate = value[HZYFormViewCellValueBeginDateKey];
            self.endDate = value[HZYFormViewCellValueEndDateKey];
            break;
        case HZYFormViewCellContentDatePickerDefault:
            self.startDate = value;
            break;
        case HZYFormViewCellContentSingleSelector:
        case HZYFormViewCellContentMultiSelector:
            self.selectList = value;
            break;
        case HZYFormViewCellContentSinglePhotoPicker:
            ((HZYFormImageView *)subView).placeholder = value;
            break;
        case HZYFormViewCellContentInputView:
            NSAssert([value isKindOfClass:[NSString class]], @"value must be a NSString object");
            ((HZYFormInputView*)subView).placeholder = value;
            break;
        case HZYFormViewCellContentInputField:
            NSAssert([value isKindOfClass:[NSString class]], @"value must be a NSString object");
            ((HZYFormInputField*)subView).placeholder = value;
            break;
        case HZYFormViewCellContentMultiPhotoPicker:
            ((HZYPicturePickerView *)subView).pictures = value;
            break;
        case HZYFormViewCellTitleText:
        case HZYFormViewCellContentDetail:
        case HZYFormViewCellContentSubDetail:
        case HZYFormViewCellContentActionButton:
        case HZYFormViewCellContentCitySelector:
        case HZYFormViewCellTitleIcon:
        case HZYFormViewCellContentIndicator:
        case HZYFormViewCellContentCheckMark:
            NSAssert(0, @"not support for set value in such view");
            break;
    }
}

#pragma mark - action
- (void)tapAction{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self cancleAlertStyle];
    [self photoPickerAction];
    [self selectorAction];
    [self citySelectorAction];
    [self datePickerDefalutAction];
    [self datePickerAtoBAction];
    if (self.tapHandler) {
        self.tapHandler();
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentSinglePhotoPicker]).image = image;
    ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentSinglePhotoPicker]).didSetImage = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:HZYFormCellImageDidAddedNotification object:nil userInfo:@{HZYFormCellNewAddedImageKey : image, HZYFormCellNewAddedImageCellTitleKey : ((HZYFormLabel *)[self subViewForType:HZYFormViewCellTitleText]).text}];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HZYPicturePickerViewDelegate
- (void)picturePicker:(HZYPicturePickerView *)picker imageAdded:(UIImage *)image atIndex:(NSUInteger)index {
    [[NSNotificationCenter defaultCenter]postNotificationName:HZYFormCellImageDidAddedNotification
                                                       object:self
                                                     userInfo:@{HZYFormCellNewAddedImageKey : image,
                                                                HZYFormCellNewAddedImageCellTitleKey : ((HZYFormLabel *)[self subViewForType:HZYFormViewCellTitleText]).text ? : @"",
                                                                HZYFormCellNewAddedImageIndexKey : [NSNumber numberWithInteger:index]}];
}

- (void)picturePicker:(HZYPicturePickerView *)picker imageDeletedAtIndex:(NSUInteger)index {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:HZYFormCellImageDidDeletedNotification
                                                       object:self
                                                     userInfo:@{HZYFormCellDeletedImageIndexKey : [NSNumber numberWithInteger:index],
                                                                HZYFormCellDeletedImageRemainCountKey : [NSNumber numberWithInteger:picker.pictures.count]}];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (self.nextEditAction) {
            self.nextEditAction();
        }
    }
    return YES;
}

#pragma mark - override
- (void)addSubview:(UIView<HZYFormCellSubViewProtocol> *)view {
    NSAssert(view.tag == 3313 || [view conformsToProtocol:@protocol(HZYFormCellSubViewProtocol)], @"【HZYFormView Warning】: form cell's subview must conforms protocol : \"HZYFormCellSubViewProtocol\"");
    [super addSubview:view];
    if (view.tag == HZYFormCellSeperatorTag) {
        return;
    }
    [_subViewTypeDict setObject:view forKey:[NSNumber numberWithInteger:view.type]];
    if (view.type & HZYFormViewCellContentMultiPhotoPicker) {
        self.tapGesture.enabled = NO;
    }
    if (view.type & HZYFormViewCellContentInputField) {
        ((HZYFormInputField *)view).delegate = self;
    }
}

#pragma mark - layout
- (void)layoutSingleSubView {
    if (self.options & HZYFormViewCellContentMultiPhotoPicker) {
        [self layoutMultiPhotoPicker:self.subviews.firstObject];
    }else{
        [self.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(6);
            make.leading.equalTo(self).offset([self.subviews.firstObject isKindOfClass:[HZYFormInputView class]] ? 10 : 16);
            make.bottom.equalTo(self).offset(-6);
            make.trailing.equalTo(self).offset(-16);
        }];
    }
}

- (void)layoutMultiSubViews {
    for (NSInteger i=0; i<self.subviews.count; i++) {
        UIView<HZYFormCellSubViewProtocol> *view = self.subviews[i];
        if (![view conformsToProtocol:@protocol(HZYFormCellSubViewProtocol)]) {
            continue;
        }
        if (view.type & HZYFormViewCellTitleIcon) {
            [self layoutTitleIcon:view];
        }else if (view.type & HZYFormViewCellTitleText) {
            [self layoutTitleText:view];
        }else if (view.type & HZYFormViewCellContentSinglePhotoPicker) {
            [self layoutSinglgPhotoPicker:view];
        }else if (view.type & HZYFormViewCellContentMultiPhotoPicker) {
            [self layoutMultiPhotoPicker:view];
        }else{
            [self layoutOthersView:view atIndex:i];
        }
    }
}

- (void)layoutTitleIcon:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.height.width.equalTo(@20);
    }];
}

- (void)layoutTitleText:(UIView *)view {
    if (self.options & HZYFormViewCellContentSinglePhotoPicker || self.options & HZYFormViewCellContentMultiPhotoPicker) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(16);
            make.top.equalTo(self).offset(12);
        }];
        [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }else{
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.options & HZYFormViewCellTitleIcon) {
                make.leading.equalTo([self subViewForType:HZYFormViewCellTitleIcon].mas_trailing).offset(8);
            }else{
                make.leading.equalTo(self).offset(16);
            }
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (void)layoutSinglgPhotoPicker:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.subviews.count > 1) {
            make.top.equalTo(self.subviews.firstObject.mas_bottom).offset(4);
        }else{
            make.top.equalTo(self).offset(6);
        }
        make.leading.equalTo(self).offset(16);
        make.width.equalTo(@164.5);
        make.bottom.equalTo(self).offset(-12);
    }];
}

- (void)layoutMultiPhotoPicker:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.subviews.count > 1) {
            make.top.equalTo(self.subviews.firstObject.mas_bottom).offset(4);
        }else{
            make.top.equalTo(self).offset(12);
        }
        make.leading.equalTo(self).offset(16);
        make.trailing.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
    }];
}

- (void)layoutOthersView:(UIView<HZYFormCellSubViewProtocol> *)view atIndex:(NSInteger)i {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-6);
        if (i == 1) {
            make.trailing.equalTo(self).offset(-16);
        }else{
            make.trailing.equalTo((self.subviews[i-1]).mas_leading).offset(-10);
        }
        if (view.type & HZYFormViewCellContentCheckMark ||
            view.type & HZYFormViewCellContentSingleSelector ||
            view.type & HZYFormViewCellContentSingleSelector ||
            view.type & HZYFormViewCellContentMultiSelector ||
            view.type & HZYFormViewCellContentCitySelector ||
            view.type & HZYFormViewCellContentDatePickerAtoB ||
            view.type & HZYFormViewCellContentDatePickerDefault) {
            make.width.equalTo(@12);
        }else if (view.type & HZYFormViewCellContentIndicator) {
            make.width.equalTo(@12);
        }else if (view == self.subviews[self.subviews.count - 1]) {
            make.leading.equalTo(self.subviews.firstObject.mas_trailing).offset(10);
        }else if ([view isKindOfClass:[HZYFormLabel class]]) {
            CGFloat width = [self sizeWithText:((HZYFormLabel *)view).text font:((HZYFormLabel *)view).font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
            make.width.equalTo([NSNumber numberWithFloat:width]);
        }else if (view.type &  HZYFormViewCellContentActionButton) {
            make.width.equalTo([NSNumber numberWithFloat:view.width]);
        }
    }];
    
}

- (void)layoutSeperator {
    UIView *sep = [UIView new];
    sep.tag = HZYFormCellSeperatorTag;
    sep.backgroundColor = HZYFormViewCellSeperatorColor;
    [self addSubview:sep];
    self.seperator = sep;
    UIEdgeInsets insets = HZYFormViewCellSeperatorInsets;
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(insets.left);
        make.trailing.equalTo(self).offset(insets.right);
        make.bottom.equalTo(self);
        make.height.equalTo(@.5);
    }];
}

- (void)disableInputFieldInSelector {
    if ([self subViewForType:HZYFormViewCellContentCitySelector] ||
        [self subViewForType:HZYFormViewCellContentSingleSelector] ||
        [self subViewForType:HZYFormViewCellContentMultiSelector] ||
        [self subViewForType:HZYFormViewCellContentDatePickerDefault] ||
        [self subViewForType:HZYFormViewCellContentDatePickerAtoB]) {
        HZYFormInputField *inputField = (HZYFormInputField *)[self subViewForType:HZYFormViewCellContentInputField];
        if (inputField) {
            inputField.userInteractionEnabled = NO;
        }
    }
}
#pragma mark - private
- (void)cancleAlertStyle {
    //取消警告状态
    if ([self subViewForType:HZYFormViewCellContentInputField] && [self subViewForType:HZYFormViewCellContentInputField].userInteractionEnabled) {
        ((HZYFormInputField *) [self subViewForType:HZYFormViewCellContentInputField]).layer.borderColor = [UIColor clearColor].CGColor;
    }
    if ([self subViewForType:HZYFormViewCellContentInputView] && [self subViewForType:HZYFormViewCellContentInputView].userInteractionEnabled) {
        ((HZYFormInputField *) [self subViewForType:HZYFormViewCellContentInputView]).layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)photoPickerAction {
    if ([self subViewForType:HZYFormViewCellContentSinglePhotoPicker]) {
        MMSelectorView *select;
        if (!((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentSinglePhotoPicker]).value) {
            select = [[MMSelectorView alloc]initWithList:@[@"相机", @"图库"] multipled:NO];
        }else{
            select = [[MMSelectorView alloc]initWithList:@[@"相机", @"图库", @"删除"] multipled:NO];
        }
        [select showSelectorViewWithAnimation:YES alertBlock:^(NSArray *indexList) {
            if ([indexList.firstObject integerValue] == 0) {
                UIImagePickerController *vc = [[UIImagePickerController alloc]init];
                vc.delegate = self;
                vc.sourceType = UIImagePickerControllerSourceTypeCamera;
                [[self viewController] presentViewController:vc animated:YES completion:nil];
            }else if ([indexList.firstObject integerValue] == 1) {
                UIImagePickerController *vc = [[UIImagePickerController alloc]init];
                vc.delegate = self;
                vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [[self viewController] presentViewController:vc animated:YES completion:nil];
            }else{
                ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentSinglePhotoPicker]).image = nil;
            }
        }];
    }
}

- (void)selectorAction {
    if (![self subViewForType:HZYFormViewCellContentMultiSelector] && ![self subViewForType:HZYFormViewCellContentSingleSelector]) {
        return;
    }
    HZYFormImageView *indicator;
    if ([self subViewForType:HZYFormViewCellContentMultiSelector]) {
        indicator = (HZYFormImageView *)[self subViewForType:HZYFormViewCellContentMultiSelector];
    }else{
        indicator = (HZYFormImageView *)[self subViewForType:HZYFormViewCellContentSingleSelector];
    }
    indicator.highlighted = !indicator.isHighlighted;
    MMSelectorView *select = [[MMSelectorView alloc]initWithList:self.selectList multipled:[self subViewForType:HZYFormViewCellContentMultiSelector]];
    select.SelectorCancleDismissBlock = ^ {
        indicator.highlighted = !indicator.isHighlighted;
    };
    [select showSelectorViewWithAnimation:YES alertBlock:^(NSArray *indexList) {
        if ([self subViewForType:HZYFormViewCellContentSingleSelector]) {
            NSString *str = self.selectList[[indexList.firstObject integerValue]];
            [self setTextForLabelOrInputView:str];
        }else{
            NSMutableString *str = [NSMutableString string];
//            select.selectedRow = 
            for (NSNumber *index in indexList) {
                [str appendString:self.selectList[index.integerValue]];
                [str appendString:@" "];
            }
            [self setTextForLabelOrInputView:str];
        }
        self.selectedArray = indexList;
        indicator.highlighted = !indicator.isHighlighted;
    }];
}

- (void)citySelectorAction {
    if (![self subViewForType:HZYFormViewCellContentCitySelector]) {
        return;
    }
    ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentCitySelector]).highlighted = !((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentCitySelector]).highlighted;
}

- (void)datePickerDefalutAction {
    if (![self subViewForType:HZYFormViewCellContentDatePickerDefault]) {
        return;
    }
    ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentDatePickerDefault]).highlighted = !((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentDatePickerDefault]).isHighlighted;
    [HZYDatePicker datePicker:UIDatePickerModeDate selectedHandler:^(NSDate *date, BOOL isCanceled) {
        if (!isCanceled) {
            self.startDate = date;
            NSDateFormatter *f = [NSDateFormatter new];
            f.dateFormat = @"yyyy-MM-dd";
            [self setTextForLabelOrInputView:[f stringFromDate:date]];
        }
        ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentDatePickerDefault]).highlighted = !((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentDatePickerDefault]).isHighlighted;
    }];
}

- (void)datePickerAtoBAction {
    if (![self subViewForType:HZYFormViewCellContentDatePickerAtoB]) {
        return;
    }
    ((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentDatePickerAtoB]).highlighted = !((HZYFormImageView *)[self subViewForType:HZYFormViewCellContentDatePickerAtoB]).isHighlighted;
   
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)showAnimation {
    if (!self.shouldShowAnimation) {
        return;
    }
    self.transform = CGAffineTransformMakeTranslation(self.bounds.size.width, 0);
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)setTextForLabelOrInputView:(NSString *)text {
    ((HZYFormLabel *)[self subViewForType:self.selectorRelatedView]).text = text;
}

#pragma mark - getter & setter
- (void)setVisible:(BOOL)visible {
    if (visible == _visible) {
        return;
    }
    _visible = visible;
    if (visible) {
        [self showAnimation];
    }
}

- (void)setSelectorRelatedView:(HZYFormViewCellOption)selectorRelatedView {
    _selectorRelatedView = selectorRelatedView;
    HZYFormInputField *inputField = (HZYFormInputField *)[self subViewForType:HZYFormViewCellContentInputField];
    if (inputField) {
        inputField.userInteractionEnabled = YES;
    }
}
@end

