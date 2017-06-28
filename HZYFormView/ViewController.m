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
@property (nonatomic, weak) HZYFormView *formView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self formViewDemo];
}

- (void)formViewDemo {
    HZYFormView *formView = [HZYFormView formViewWithFrame:CGRectOffset(self.view.bounds, 0, 20) sectionRows:@[@1, @2, @1, @1]];
    formView.titles = @[@[@"姓名"], @[@"性别", @"爱好"], @[@"头像"], @[@"自拍"]];
    formView.placeholders = @[@[@"填写姓名"], @[@"选择性别", @"选择爱好（多选）"], @[[UIImage imageNamed:@"lss"]]];
    [formView configCellForRow:0 inSection:1 settings:^(HZYFormViewConfigurator *set) {
        [set options:HZYFormViewCellContentSingleSelector | HZYFormViewCellContentInputField | HZYFormViewCellTitleText];
    } values:^(HZYFormViewConfigurator *set) {
        [set value:@[@"男", @"女", @"其他"] forOption:HZYFormViewCellContentMultiSelector];
    }];

    [formView configCellForRow:1 inSection:1 settings:^(HZYFormViewConfigurator *set) {
        [set options:HZYFormViewCellContentMultiSelector | HZYFormViewCellContentInputField | HZYFormViewCellTitleText];
    } values:^(HZYFormViewConfigurator *set) {
        [set value:@[@"吃饭", @"睡觉", @"玩游戏", @"写代码"] forOption:HZYFormViewCellContentMultiSelector];
    }];
    [formView configCellForRow:0 inSection:2 settings:^(HZYFormViewConfigurator *set) {
        [set options:HZYFormViewCellContentSinglePhotoPicker | HZYFormViewCellTitleText];
    }];
    [formView configCellForRow:0 inSection:3 settings:^(HZYFormViewConfigurator *set) {
        [set options:HZYFormViewCellContentMultiPhotoPicker | HZYFormViewCellTitleText];
    }];
    
    [self.view addSubview:formView];
    self.formView = formView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 44)];
    [btn setTitle:@"get all values" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnTouched {
    NSLog(@"%@", [self.formView getAllValues]);
}
@end
