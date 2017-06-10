//
//  PicturePickerCell.m
//
//  Created by Michael on 15/12/14.
//

#import "HZYPicturePickerCell.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"

@interface HZYPicturePickerCell()
/// 图像视图
@property (nonatomic, strong) UIImageView *imageView;
/// 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation HZYPicturePickerCell

#pragma mark - 设置属性
- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = (image == nil) ? [UIImage imageNamed:@"add_pic"] : image;
    
    if (self.editable) {
        self.deleteButton.hidden = (image == nil);
    }else{
        self.deleteButton.hidden = YES;
    }
}

- (void)setUrl:(NSString *)url{
    if (!self.imageView.image) {
        [self.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
}

#pragma mark - 监听方法
/// 点击删除按钮
- (void)clickDeleteButton {
    if ([self.delegate respondsToSelector:@selector(deleteButtonTouchInPicturePickerCell:)]) {
        [self.delegate deleteButtonTouchInPicturePickerCell:self];
    }
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // 1. 图像视图
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 2. 删除按钮
        _deleteButton = [[UIButton alloc] init];
//        [_deleteButton setImage:[UIImage imageNamed:@"prof_router_delete"] forState:UIControlStateNormal];
        
        [self addSubview:_deleteButton];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
        }];
        
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
