//
//  HZYFormVIewCellSubViewCreater.m
//  HZYCodeCollections
//
//  Created by Michael-Nine on 2017/5/29.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormVIewCellSubViewCreater.h"
#import "HZYFormViewCell.h"
#import "HZYFormViewDataModel.h"
#import "HZYFormViewDefine.h"

@interface HZYFormVIewCellSubViewCreater ()
@property (nonatomic, strong) HZYFormViewDataModel *dataModel;

@end
@implementation HZYFormVIewCellSubViewCreater

#pragma mark - Life Cycle
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel {
    if (self = [super init]) {
        _dataModel = dataModel;
    }
    return self;
}

#pragma mark - Private Method
- (HZYFormViewCell *)createCellSubviews:(HZYFormViewCell *)cell accessory:(NSDictionary *)accessory {
    HZYFormViewCellOption options = cell.options;
    if (cell.subviews.count > 0) {
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    //添加title
    if (options & HZYFormViewCellTitleIcon) {
        HZYFormImageView *icon = [HZYFormImageView new];
        icon.contentMode = UIViewContentModeCenter;
        icon.type = HZYFormViewCellTitleIcon;
        [cell addSubview:icon];
    }
    if (options & HZYFormViewCellTitleText) {
        HZYFormLabel *titleLabel = [self createTitleLabel];
        [cell addSubview:titleLabel];
    }
    
    //以优先级倒序添加
    if (options & HZYFormViewCellContentIndicator) {
        HZYFormImageView *indicator = [[HZYFormImageView alloc]initWithImage:[UIImage imageNamed:@"mm_right_indicator"]];
        indicator.contentMode = UIViewContentModeCenter;
        indicator.type = HZYFormViewCellContentIndicator;
        [cell addSubview:indicator];
    }
    if (options & HZYFormViewCellContentCheckMark) {
        
    }
    if (options & HZYFormViewCellContentSingleSelector ||
        options & HZYFormViewCellContentMultiSelector ||
        options & HZYFormViewCellContentDatePickerDefault ||
        options & HZYFormViewCellContentDatePickerAtoB ||
        options & HZYFormViewCellContentCitySelector) {
        HZYFormImageView *indicator = [[HZYFormImageView alloc]initWithImage:[UIImage imageNamed:@"down_indicator"]];
        indicator.highlightedImage = [UIImage imageNamed:@"up_indicator"];
        indicator.contentMode = UIViewContentModeCenter;
        if (options & HZYFormViewCellContentSingleSelector) {
            indicator.type = HZYFormViewCellContentSingleSelector;
        }else if (options & HZYFormViewCellContentMultiSelector) {
            indicator.type = HZYFormViewCellContentMultiSelector;
        }else if (options & HZYFormViewCellContentDatePickerDefault) {
            indicator.type = HZYFormViewCellContentDatePickerDefault;
        }else if (options & HZYFormViewCellContentDatePickerAtoB) {
            indicator.type = HZYFormViewCellContentDatePickerAtoB;
        }else if (options & HZYFormViewCellContentCitySelector) {
            indicator.type = HZYFormViewCellContentCitySelector;
        }
        [cell addSubview:indicator];
    }
    if (options & HZYFormViewCellContentMultiPhotoPicker) {
        HZYPicturePickerView *picPicker = [HZYPicturePickerView new];
        picPicker.pickerDelegate = cell;
        [cell addSubview:picPicker];
    }
    if (options & HZYFormViewCellContentSinglePhotoPicker) {
        HZYFormImageView *imageView = [HZYFormImageView new];
        imageView.type = HZYFormViewCellContentSinglePhotoPicker;
        [cell addSubview:imageView];
    }
    if (options & HZYFormViewCellContentSubDetail) {
        HZYFormLabel *subDetail = [self createSubDetailLabel];
        [cell addSubview:subDetail];
    }
    if (options & HZYFormViewCellContentDetail) {
        HZYFormLabel *detail = [self createDetailLabel];
        [cell addSubview:detail];
    }
    if (options & HZYFormViewCellContentInputField) {
        HZYFormInputField *inputField = [self createInputField];
        inputField.textAlignment = self.dataModel.textAlignment;
        [cell addSubview:inputField];
    }
    if (options & HZYFormViewCellContentInputView) {
        HZYFormInputView *inputView = [HZYFormInputView new];
        inputView.textColor = self.dataModel.inputViewTextColor;
        inputView.font = self.dataModel.inputViewFont;
        inputView.type = HZYFormViewCellContentInputView;
        [cell addSubview:inputView];
    }
    
    [cell layoutFormViews];
    return cell;
}


- (HZYFormLabel *)createTitleLabel {
    HZYFormLabel *titleLabel = [HZYFormLabel labelWithType:HZYFormViewCellTitleText];
    titleLabel.font = self.dataModel.titleFont;
    titleLabel.tag = 10001;
    titleLabel.textColor = self.dataModel.titleColor;
    return titleLabel;
}

- (HZYFormLabel *)createDetailLabel {
    HZYFormLabel *label = [self createTitleLabel];
    label.type = HZYFormViewCellContentDetail;
    label.textColor = self.dataModel.detailTextColor;
    label.textAlignment = NSTextAlignmentRight;
    label.font = self.dataModel.detailFont;
    return label;
}

- (HZYFormLabel *)createSubDetailLabel {
    HZYFormLabel *label = [self createTitleLabel];
    label.textColor = self.dataModel.subDetailTextColor;
    label.type = HZYFormViewCellContentSubDetail;
    label.font = self.dataModel.subDetailFont;
    return label;
}

- (HZYFormInputField *)createInputField {
    HZYFormInputField *inputField = [HZYFormInputField new];
    inputField.font = self.dataModel.inputFieldFont;
    inputField.textColor = self.dataModel.inputFieldTextColor;
    inputField.textAlignment = NSTextAlignmentRight;
    inputField.tag = 10002;
    inputField.type = HZYFormViewCellContentInputField;
    return inputField;
}
@end
