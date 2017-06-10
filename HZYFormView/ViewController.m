//
//  ViewController.m
//  HZYFormView
//
//  Created by Michael-Nine on 2017/6/7.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "ViewController.h"
#import "HZYFormView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self formViewDemo];
}

- (void)formViewDemo {
    HZYFormView *formView = [HZYFormView formViewWithFrame:self.view.bounds sectionRows:@[@1, @2, @2]];
    formView.titles = @[@[@"姓名"], @[@"性别", @"爱好"], @[@"头像", @"自拍"]];
    formView.placeholders = @[@[@"填写姓名"], @[@"选择性别", @"选择爱好（多选）"], @[[UIImage imageNamed:@"lss"]]];
    [formView setCellOptions:HZYFormViewCellContentSingleSelector | HZYFormViewCellContentInputField | HZYFormViewCellTitleText forRowsAtIndexPath:@[[NSIndexPath indexPathForRow:0 inSection:1]]];
    [formView setCellOptions:HZYFormViewCellContentMultiSelector | HZYFormViewCellContentInputField | HZYFormViewCellTitleText forRowsAtIndexPath:@[[NSIndexPath indexPathForRow:1 inSection:1]]];
    [formView setCellOptions:HZYFormViewCellContentSinglePhotoPicker | HZYFormViewCellTitleText forRowsAtIndexPath:@[[NSIndexPath indexPathForRow:0 inSection:2]]];
    [formView setCellOptions:HZYFormViewCellContentMultiPhotoPicker forRowsAtIndexPath:@[[NSIndexPath indexPathForRow:1 inSection:2]]];
    [self.view addSubview:formView];
}
@end
