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

- (void)title:(NSString *)title {
    [self.dataModel setTitle:title forRow:self.row inSection:self.section];
}

- (void)icon:(UIImage *)icon {
    [self.dataModel setIcon:icon forRow:self.row inSection:self.section];
}

- (void)placeholder:(id)placeholder {
    [self.dataModel setPlaceholder:placeholder forRow:self.row inSection:self.section];
}

- (void)inputText:(NSString *)text {
    [self.dataModel setInputText:text forRow:self.row inSection:self.section];
}

- (void)detail:(NSString *)detail {
    [self.dataModel setDetail:detail forRow:self.row inSection:self.section];
}

- (void)subDetail:(NSString *)subDetail {
    [self.dataModel setSubDetail:subDetail forRow:self.row inSection:self.section];
}

- (void)picture:(UIImage *)picture {
    [self.dataModel setPicture:picture forRow:self.row inSection:self.section];
}

- (void)pictures:(NSArray *)pictures {
    [self.dataModel setPicture:pictures forRow:self.row inSection:self.section];
}

- (void)selectList:(NSArray *)selectList {
    [self.dataModel setSelectList:selectList forRow:self.row inSection:self.section];
}

- (void)checkmark:(HZYFormViewCheckmarkState)state {
    [self.dataModel setCheckMark:state forRow:self.row inSection:self.section];
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
