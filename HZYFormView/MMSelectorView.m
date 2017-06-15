//
//  MMSelectorView.m
//  CMM
//
//  Created by Melody_Zhy on 2016/12/19.
//  Copyright © 2016年 zuozheng. All rights reserved.
//

#import "MMSelectorView.h"
#import "Masonry.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MMSelectorMultipledCell : UITableViewCell
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *selectImg;
@property (nonatomic, strong) NSNumber *choose;
@end

@implementation MMSelectorMultipledCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *selectImg = [[UIImageView alloc] init];
        self.selectImg = selectImg;
        [selectImg sizeToFit];
        [self.contentView addSubview:selectImg];
        [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(selectImg.mas_right).offset(10);
        }];
        self.titleLabel = titleLabel;
        
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setChoose:(NSNumber *)choose {
    _choose = choose;
    if ([choose isEqualToNumber:@1]) {
        self.selectImg.image = [UIImage imageNamed:@"order_print_on"];
    } else {
        self.selectImg.image = [UIImage imageNamed:@"order_print_off"];
    }
}

@end


@interface MMSelectorView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) BOOL multipled;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITableView *sheetTableView;
@property (nonatomic, copy) SelectorBlock selectorBlock;
@property (nonatomic, weak) UIView *selectorView;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, strong) NSMutableArray *selectsList;
@end

@implementation MMSelectorView

- (instancetype)initWithList:(NSArray *)list multipled:(BOOL)multipled {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleDismissSelector)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.list = list;
        self.multipled = multipled;
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.list.count];
        for (NSInteger i = 0; i<self.list.count; i++) {
            [arrM addObject:@0];
        }
        self.selectsList = arrM;
        
        CGFloat height = 0;
        if (list.count >= 8) {
            height = 405;
        } else {
            height = 45 * (list.count + 1);
        }
        if (multipled && list.count <= 5) {
            height = 225;
        }
        
        if (multipled == NO && list.count <= 5) {
            height += 5;
        }
        
        self.height = height;
        
        UIView *selectorView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
        selectorView.backgroundColor = [UIColor whiteColor];
        [self addSubview:selectorView];
        self.selectorView = selectorView;
        
        if (multipled == NO && list.count <= 5) {
            UITableView *sheetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) style:UITableViewStyleGrouped];
            sheetTableView.delegate = self;
            sheetTableView.dataSource = self;
            sheetTableView.rowHeight = 45;
            sheetTableView.scrollEnabled = NO;
            sheetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [selectorView addSubview:sheetTableView];
            self.sheetTableView = sheetTableView;
        } else {
            // 头部视图
            UIView *headerView = [[UIView alloc] init];
            headerView.backgroundColor = [UIColor whiteColor];
            headerView.frame = CGRectMake(0, 0, kScreenWidth, 45);
            [selectorView addSubview:headerView];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
            bottomLine.backgroundColor = [UIColor lightGrayColor];
            [headerView addSubview:bottomLine];
            
            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 14.5, 16, 16)];
            [closeBtn setImage:[UIImage imageNamed:@"cancal_icon"] forState:UIControlStateNormal];
            [closeBtn setImage:[UIImage imageNamed:@"cancal_icon"] forState:UIControlStateHighlighted];
            [headerView addSubview:closeBtn];
            [closeBtn addTarget:self action:@selector(cancleDismissSelector) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 47, 14.5, 40, 16)];
            [saveBtn setTitle:@"选择" forState:UIControlStateNormal];
            [saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [headerView addSubview:saveBtn];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            // tableView
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, height - 45) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.rowHeight = 45;
            tableView.tableFooterView = [[UIView alloc] init];
            if (multipled) {
                tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
            }
            tableView.delegate = self;
            tableView.dataSource = self;
            [selectorView addSubview:tableView];
        }
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.sheetTableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.sheetTableView) {
        return section == 1 ? 1 : self.list.count;
    } else {
        return self.list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.sheetTableView) {
        return section == 1 ? CGFLOAT_MIN : 5;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.sheetTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.text = indexPath.section == 1 ? @"取消" : [NSString stringWithFormat:@"%@", self.list[indexPath.row]];
        titlelabel.font = [UIFont systemFontOfSize:18];
        titlelabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titlelabel];
        
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
        }];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:bottomLine];
        
        if (indexPath.section == 1) {
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            bottomLine.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:bottomLine];
        }
        return cell;
    } else {
        if (self.multipled) {
            MMSelectorMultipledCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[MMSelectorMultipledCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.titleText = [NSString stringWithFormat:@"%@", self.list[indexPath.row]];
            cell.choose = self.selectsList[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.list[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self.selectsList[indexPath.row] isEqualToNumber:@1]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.sheetTableView) {
        if (self.selectorBlock) {
            if (indexPath.section == 1) {
                [self cancleDismissSelector];
            } else {
                self.selectorBlock(@[@(indexPath.row)]);
                [self dismissSelector];
            }
        }
    } else {
        if (self.multipled) {
            if ([self.selectsList[indexPath.row] isEqualToNumber:@1]) {
                [self.selectsList replaceObjectAtIndex:indexPath.row withObject:@0];
            } else {
                [self.selectsList replaceObjectAtIndex:indexPath.row withObject:@1];
            }
            [tableView reloadData];
        } else {
            for (NSInteger i = 0; i<self.selectsList.count; i++) {
                if (i == indexPath.row) {
                    [self.selectsList replaceObjectAtIndex:indexPath.row withObject:@1];
                } else {
                    [self.selectsList replaceObjectAtIndex:i withObject:@0];
                }
            }
            [tableView reloadData];
        }
    }
    
}

- (void)showSelectorViewWithAnimation:(BOOL)animation alertBlock:(SelectorBlock)selectorBlock {
    
    _selectorBlock = selectorBlock;
    _animation = animation;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow endEditing:YES];
    [keyWindow addSubview:self];
    [keyWindow endEditing:YES];
    
    if (animation) {
        self.selectorView.transform = CGAffineTransformMakeTranslation(0, self.height);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            self.selectorView.transform = CGAffineTransformIdentity;
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)saveBtnClick {
    if (self.multipled) {
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.list.count];
        for (NSInteger i = 0; i<self.selectsList.count; i++) {
            if ([self.selectsList[i] isEqualToNumber:@1]) {
                [arrM addObject:@(i)];
            }
        }
        if (self.selectorBlock) {
            self.selectorBlock(arrM.copy);
        }
    } else {
        if (self.selectorBlock) {
            NSInteger selectRow = 0;
            for (NSInteger i = 0; i<self.selectsList.count; i++) {
                if ([self.selectsList[i] isEqualToNumber:@1]) {
                    selectRow = i;
                }
            }
            self.selectorBlock(@[@(selectRow)]);
        }
    }
    [self dismissSelector];
}

- (void)dismissSelector {
    if (self.animation) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            self.selectorView.transform = CGAffineTransformMakeTranslation(0, self.height);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)cancleDismissSelector {
    if (self.SelectorCancleDismissBlock) {
        self.SelectorCancleDismissBlock();
    }
    [self dismissSelector];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self]) {
        return YES;
    }
    return NO;
}

- (void)setSelectedRow:(NSString *)selectedRow {
    _selectedRow = selectedRow;
    // 默认选择第一个
    if (selectedRow == nil) {
        selectedRow = @"0";
    }
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.list.count];
    for (NSInteger i = 0; i<self.list.count; i++) {
        if (i == [selectedRow integerValue]) {
            [arrM addObject:@1];
        } else {
            [arrM addObject:@0];
        }
    }
    self.selectsList = arrM;
}

- (NSMutableArray *)selectsList {
    return _selectsList ? : [NSMutableArray array];
}

@end
