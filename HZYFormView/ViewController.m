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
    HZYFormView *formView = [HZYFormView formViewWithFrame:self.view.bounds sectionRows:@[@1]];
    formView.titles = @[@"hhaha"];
    [self.view addSubview:formView];
}
@end
