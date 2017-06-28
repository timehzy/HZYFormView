//
//  PicturePickerView.m
//
//  Created by Michael on 15/12/14.
//

#import "HZYPicturePickerView.h"
#import "HZYPicturePickerCell.h"
#import "HZYImageScanView.h"
#define kItemSizeW ([UIScreen mainScreen].bounds.size.width - 16*2 -3*8) / 4
#define kMaxPicConut 5
#pragma mark - 照片选择视图
@interface HZYPicturePickerView() <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HZYImageScanViewDelegate>
@property (nonatomic, strong) NSMutableArray *realValues;

@end

@implementation HZYPicturePickerView
@synthesize pictures = _pictures;
/// 添加一张照片
- (void)addImage:(UIImage *)image {
    if (image == nil) {
        return;
    }

    [self.realValues addObject:image];
    [self reloadData];
}


#pragma mark - 构造函数
- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 8;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - 16*2 -3*8) / 4;
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        _type = HZYFormViewCellContentMultiPhotoPicker;
        _maxPicCount = kMaxPicConut;
        _addable = YES;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[HZYPicturePickerCell class] forCellWithReuseIdentifier:@"item"];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self addImage:image];
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(picturePicker:imageAdded:atIndex:)]) {
        [self.pickerDelegate picturePicker:self imageAdded:image atIndex:self.realValues.count - 1];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.addable) {
        return self.realValues.count == self.maxPicCount ? self.realValues.count : self.realValues.count + 1;
    }else{
        return self.realValues.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HZYPicturePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    if (self.realValues.count > indexPath.item) {
        if ([self.realValues[indexPath.item] isKindOfClass:[NSString class]]) {
            cell.url = self.realValues[indexPath.item];
        }else{
            cell.image = self.realValues[indexPath.item];
        }
    }else{
        cell.url = nil;
        cell.image = nil;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != self.realValues.count && ![self.pickerDelegate respondsToSelector:@selector(picturePicker:imageDidSelected:)]) {
        HZYPicturePickerCell *cell = (HZYPicturePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CGRect rect = [self convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
        [self scanImage:rect beginIndex:indexPath.item];
    }else{
        [self showActionSheetForAndNewImage];
    }
}

#pragma mark - HZYImageScanViewDelegate
- (void)scanView:(HZYImageScanView *)scanView imageDidDelete:(NSInteger)index {
    [self.realValues removeObjectAtIndex:index];
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(picturePicker:imageDeletedAtIndex:)]) {
        [self.pickerDelegate picturePicker:self imageDeletedAtIndex:index];
    }
    [self reloadData];
}

- (CGRect)imageViewFrameAtIndex:(NSUInteger)index forScanView:(HZYImageScanView *)scanView {
    HZYPicturePickerCell *cell = (HZYPicturePickerCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return [self convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
}

- (void)scanImage:(CGRect)rect beginIndex:(NSUInteger)index {
    HZYPicturePickerCell *cell = (HZYPicturePickerCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    cell.imageView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.imageView.hidden = NO;
    });
    if (self.addable) {
        [HZYImageScanView showWithImages:self.realValues beginIndex:index deletable:self.addable delegate:self];
    }else{
        HZYImageScanView *scanView = [HZYImageScanView scanViewWithImageArray:self.realValues];
        scanView.enableNavigationBar = NO;
        scanView.tapToDismiss = YES;
        scanView.delegate = self;
        scanView.beginIndex = index;
        [scanView showWithAnimation];
    }
    
}

#pragma mark - getter & setter
- (void)setUrls:(NSMutableArray *)urls{
    _urls = [urls mutableCopy];
    self.realValues = urls;
    [self reloadData];
}

- (void)setPictures:(NSMutableArray *)pictures {
    _pictures = pictures;
    self.realValues = pictures;
    [self reloadData];
}

- (NSMutableArray *)pictures{
    if (!_pictures) {
        _pictures = [NSMutableArray array];
    }
    return _pictures;
}

- (NSMutableArray *)realValues {
    if (!_realValues) {
        _realValues = [NSMutableArray array];
    }
    return _realValues;
}

- (NSArray *)values {
    return self.realValues.copy;
}

- (void)setItemSize:(CGSize)itemSize {
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = itemSize;
}

- (void)setMargin:(CGFloat)margin {
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing = margin;
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumInteritemSpacing = margin;

}
#pragma mark - private
- (void)showActionSheetForAndNewImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc]init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc]init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
