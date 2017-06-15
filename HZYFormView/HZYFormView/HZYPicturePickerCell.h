//
//  PicturePickerCell.h
//
//  Created by Michael on 15/12/14.
//

#import <UIKit/UIKit.h>

@interface HZYPicturePickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *url;
@end
