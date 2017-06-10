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
- (HZYFormViewCell *)createCellSubviews:(HZYFormViewCell *)cell accessory:(NSDictionary *)accessory atSection:(NSUInteger)i row:(NSUInteger)j {
    HZYFormViewCellOption options = cell.options;
    //添加title
    if (options & HZYFormViewCellTitleText) {
        NSString *title;
        if (self.dataModel.titles.count > i && [self.dataModel.titles[i] count] > j) {
            title = self.dataModel.titles[i][j];
        }
        HZYFormLabel *titleLabel = [self createTitleLabel:title];
        [cell addSubview:titleLabel];
    }
    
    //以优先级倒序添加
    if (options & HZYFormViewCellContentIndicator) {
        HZYFormImageView *indicator = [[HZYFormImageView alloc]initWithImage:[UIImage imageNamed:@"mm_right_indicator"]];
        indicator.contentMode = UIViewContentModeCenter;
        indicator.type = HZYFormViewCellContentIndicator;
        [cell addSubview:indicator];
    }
    if ([accessory objectForKey:HZYFormCellAccessoryActionButton]) {
        HZYFormButton *actionBtn = [accessory objectForKey:HZYFormCellAccessoryActionButton];
        [cell addSubview:actionBtn];
    }
    if (options & HZYFormViewCellContentCheckMark) {
        
    }
    if (options & HZYFormViewCellContentSingleSelector ||
        options & HZYFormViewCellContentMultiSelector ||
        options & HZYFormViewCellContentDatePickerDefault ||
        options & HZYFormViewCellContentDatePickerAtoB ||
        options & HZYFormViewCellContentCitySelector) {
        HZYFormImageView *indicator = [[HZYFormImageView alloc]initWithImage:[UIImage imageNamed:@"mm_bottom_indicator"]];
        indicator.highlightedImage = [UIImage imageNamed:@"mm_top_indicator"];
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
        picPicker.type = HZYFormViewCellContentMultiPhotoPicker;
        if (self.dataModel.pictures.count > i && [self.dataModel.pictures[i] count] > j) {
            if ([[self.dataModel.pictures[i][j] firstObject] isKindOfClass:[UIImage class]]) {
                picPicker.pictures = self.dataModel.pictures[i][j];
            }else{
                picPicker.urls = self.dataModel.pictures[i][j];
            }
        }
        [cell addSubview:picPicker];
    }
    if (options & HZYFormViewCellContentSinglePhotoPicker) {
        HZYFormImageView *imageView = [HZYFormImageView new];
        imageView.type = HZYFormViewCellContentSinglePhotoPicker;
        if (self.dataModel.pictures.count > i && [self.dataModel.pictures[i] count] > j) {
            if ([self.dataModel.pictures[i][j] isKindOfClass:[UIImage class]]) {
                imageView.image = self.dataModel.pictures[i][j];
            }else{
                imageView.url = self.dataModel.pictures[i][j];
            }
            if (self.dataModel.placeholders.count > i && [self.dataModel.placeholders[i] count] > j) {
                imageView.placeholder = self.dataModel.placeholders[i][j];
            }
        }
        [cell addSubview:imageView];
    }
    if (options & HZYFormViewCellContentSubDetail) {
        HZYFormLabel *subDetail = [self createSubDetailLabel:self.dataModel.subDetails[i][j]];
        [cell addSubview:subDetail];
    }
    if (options & HZYFormViewCellContentDetail) {
        HZYFormLabel *detail = [self createDetailLabel:self.dataModel.details[i][j]];
        [cell addSubview:detail];
    }
    if (options & HZYFormViewCellContentInputField) {
        NSString *inputText;
        NSString *placeholder;
        if (self.dataModel.inputTexts.count > 0) {
            inputText = self.dataModel.inputTexts[i][j];
        }
        if (self.dataModel.placeholders.count > i && [self.dataModel.placeholders[i] count] > j) {
            placeholder = self.dataModel.placeholders[i][j];
        }
        HZYFormInputField *inputField = [self createInputField:placeholder text:inputText];
        [cell addSubview:inputField];
    }
    if (options & HZYFormViewCellContentInputView) {
        HZYFormInputView *inputView = [HZYFormInputView new];
        inputView.textColor = self.dataModel.inputViewTextColor;
        inputView.font = self.dataModel.inputViewFont;
        inputView.type = HZYFormViewCellContentInputView;
        if (self.dataModel.placeholders.count > i && [self.dataModel.placeholders[i] count] > j) {
            inputView.placeholder = self.dataModel.placeholders[i][j];
        }else{
            inputView.placeholder = [NSString stringWithFormat:@"%@", self.dataModel.titles[i][j]];
        }
        if (self.dataModel.inputTexts.count > 0) {
            inputView.text = self.dataModel.inputTexts[i][j];
        }
        [cell addSubview:inputView];
    }
    
    [cell layoutFormViews];
    return cell;
}


- (HZYFormLabel *)createTitleLabel:(NSString *)title {
    HZYFormLabel *titleLabel = [HZYFormLabel labelWithType:HZYFormViewCellTitleText];
    titleLabel.font = self.dataModel.titleFont;
    titleLabel.tag = 10001;
    titleLabel.text = title;
    titleLabel.textColor = self.dataModel.titleColor;
    return titleLabel;
}

- (HZYFormLabel *)createDetailLabel:(NSString *)content {
    HZYFormLabel *label = [self createTitleLabel:content];
    label.type = HZYFormViewCellContentDetail;
    label.textColor = self.dataModel.detailTextColor;
    label.textAlignment = NSTextAlignmentRight;
    label.font = self.dataModel.detailFont;
    return label;
}

- (HZYFormLabel *)createSubDetailLabel:(NSString *)content {
    HZYFormLabel *label = [self createTitleLabel:content];
    label.textColor = self.dataModel.subDetailTextColor;
    label.type = HZYFormViewCellContentSubDetail;
    label.font = self.dataModel.subDetailFont;
    return label;
}

- (HZYFormInputField *)createInputField:(NSString *)placeholder text:(NSString *)text {
    HZYFormInputField *inputField = [HZYFormInputField new];
    inputField.font = self.dataModel.inputFieldFont;
    inputField.textColor = self.dataModel.inputFieldTextColor;
    inputField.textAlignment = NSTextAlignmentRight;
    inputField.tag = 10002;
    inputField.placeholder = placeholder;
    inputField.text = text;
    inputField.type = HZYFormViewCellContentInputField;
    return inputField;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

#pragma mark - Action



#pragma mark - Getter & Setter


@end
