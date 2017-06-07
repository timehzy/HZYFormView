//
//  PicturePickerCell.h
//
//  Created by Michael on 15/12/14.
//

#import <UIKit/UIKit.h>

@class HZYPicturePickerCell;

@protocol HZYPicturePickerCellDelegate <NSObject>

- (void)deleteButtonTouchInPicturePickerCell:(HZYPicturePickerCell *)cell ;
@end

@interface HZYPicturePickerCell : UICollectionViewCell

/// 照片图像
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL editable;


@property (nonatomic, weak) id<HZYPicturePickerCellDelegate> delegate;

@end
