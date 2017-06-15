//
//  PicturePickerView.h
//
//  Created by Michael on 15/12/14.
//

#import <UIKit/UIKit.h>
#import "HZYFormViewDefine.h"

@class HZYPicturePickerView;
@protocol HZYPicturePickerViewDelegate <NSObject>
- (void)picturePicker:(HZYPicturePickerView *)picker imageAdded:(UIImage *)image atIndex:(NSUInteger)index;
- (void)picturePicker:(HZYPicturePickerView *)picker imageDeletedAtIndex:(NSUInteger)index;
- (void)picturePicker:(HZYPicturePickerView *)picker imageDidSelected:(UIImage *)image;
@end

@interface HZYPicturePickerView : UICollectionView<HZYFormCellSubViewProtocol>
@property (nonatomic, weak) id<HZYPicturePickerViewDelegate> pickerDelegate;

/// 照片数组
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, readonly) NSArray *values;//最终数组，新增图片返回UIImage，以url设置的图片仍然返回NSString

@property (nonatomic, assign) NSUInteger maxPicCount;//default is 5
@property (nonatomic, assign) BOOL editable;//default YES

@property (nonatomic, copy) NSString *stringTag;
@property (nonatomic, assign) HZYFormViewCellOption type;
@end
