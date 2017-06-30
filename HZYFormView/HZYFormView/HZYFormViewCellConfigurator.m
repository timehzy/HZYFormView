//
//  HZYFormViewSetter.m
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "HZYFormViewCellConfigurator.h"
#import "HZYFormViewCell.h"
#import "HZYFormViewDataModel.h"

@interface HZYFormViewCellConfigurator ()
@property (nonatomic, strong) HZYFormViewCell *cell;
@property (nonatomic, strong) HZYFormViewDataModel *dataModel;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger section;

@end

@implementation HZYFormViewCellConfigurator
#pragma mark - public
- (instancetype)initWithDataModel:(HZYFormViewDataModel *)dataModel forRow:(NSUInteger)row inSection:(NSUInteger)section {
    if (self = [super init]) {
        _dataModel = dataModel;
        _cell = [dataModel getCellForRow:row inSection:section];
        _row = row;
        _section = section;
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
    self.dataModel.inputUserInteractionEnableArray[self.section][self.row] = @(enable);
}

- (void)keyboardType:(UIKeyboardType)type {
    self.dataModel.inputKeyboardTypeArray[self.section][self.row] = @(type);
}

- (void)selectorRelatedView:(HZYFormViewCellOption)viewOption {
    self.cell.selectorRelatedView = viewOption;
}

- (void)title:(NSString *)title {
    self.dataModel.titles[self.section][self.row] = title;
}

- (void)icon:(UIImage *)icon {
    self.dataModel.icons[self.section][self.row] = icon;
}

- (void)placeholder:(id)placeholder {
    self.dataModel.placeholders[self.section][self.row] = placeholder;
}

- (void)inputText:(NSString *)text {
    self.dataModel.inputTexts[self.section][self.row] = text;
}

- (void)detail:(NSString *)detail {
    self.dataModel.details[self.section][self.row] = detail;
}

- (void)subDetail:(NSString *)subDetail {
    self.dataModel.subDetails[self.section][self.row] = subDetail;
}

- (void)picture:(UIImage *)picture {
    self.dataModel.pictures[self.section][self.row] = picture;
}

- (void)pictures:(NSArray *)pictures {
    self.dataModel.pictures[self.section][self.row] = pictures;
}

- (void)selectList:(NSArray *)selectList {
    self.dataModel.selectLists[self.section][self.row] = selectList;
}

- (void)checkmark:(HZYFormViewCheckmarkState)state {
    self.dataModel.checkmarks[self.section][self.row] = @(state);
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
