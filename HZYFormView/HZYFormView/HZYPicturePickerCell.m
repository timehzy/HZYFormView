//
//  PicturePickerCell.m
//
//  Created by Michael on 15/12/14.
//

#import "HZYPicturePickerCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface HZYPicturePickerCell()
@end

@implementation HZYPicturePickerCell

#pragma mark - 设置属性
- (void)setImage:(UIImage *)image {
    if (!image) {
        self.imageView.image = [UIImage imageNamed:@"add_pic"];
    }else{
        self.imageView.image = image;
    }
}

- (void)setUrl:(NSString *)url{
    if (!url) {
        self.imageView.image = [UIImage imageNamed:@"add_pic"];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
}

- (UIImage *)image {
    return self.imageView.image;
}

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
    }
    return self;
}

@end
