//
//  PicturePickerView.m
//
//  Created by Michael on 15/12/14.
//

#import "HZYPicturePickerView.h"
#import "HZYPicturePickerCell.h"

#pragma mark - 自定义照片选择视图布局
@interface HZYPicturePickerLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) BOOL imageUpdateComplete;
@end


@implementation HZYPicturePickerLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat margin = 8;
    CGFloat w = 75;
    
    self.itemSize = CGSizeMake(w, w);
    self.minimumInteritemSpacing = margin;
    self.minimumLineSpacing = margin;
}
@end

#pragma mark - 照片选择视图
@interface HZYPicturePickerView() <UICollectionViewDataSource, UICollectionViewDelegate, HZYPicturePickerCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *realValues;

@end

@implementation HZYPicturePickerView
@synthesize pictures = _pictures;
/// 添加一张照片
- (void)addImage:(UIImage *)image {
    if (image == nil) {
        return;
    }

    [self.pictures addObject:image];
    [self.realValues addObject:image];
    [self reloadData];
}

- (void)addUrl:(NSString *)url{
    if (url == nil) {
        return;
    }
    [self.urls addObject:url];
    [self reloadData];
}

#pragma mark - 构造函数
- (instancetype)init {
    HZYPicturePickerLayout *layout = [[HZYPicturePickerLayout alloc] init];    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:layout]) {
        _type = HZYFormViewCellContentMultiPhotoPicker;
        _pictures = [NSMutableArray array];
        _urls = [NSMutableArray array];
        _maxPicCount = 5;
        _editable = YES;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[HZYPicturePickerCell class] forCellWithReuseIdentifier:@"item"];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - PicturePickerCellDelegate
- (void)deleteButtonTouchInPicturePickerCell:(HZYPicturePickerCell *)cell {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    [self.pictures removeObjectAtIndex:indexPath.item];
    if (self.urls && self.urls.count > indexPath.item) {
        [self.urls removeObjectAtIndex:indexPath.item];
    }
    [self reloadData];
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(picturePicker:imageDeletedAtIndex:)]) {
        [self.pickerDelegate picturePicker:self imageDeletedAtIndex:indexPath.item];
    }
    [self.realValues removeObjectAtIndex:indexPath.item];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.editable) {
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
        cell.image = nil;
        cell.url = nil;
    }
    cell.editable = self.editable;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != self.realValues.count && self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(picturePicker:imageDidSelected:)]) {
        [self.pickerDelegate picturePicker:self imageDidSelected:self.pictures[indexPath.item]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.pictures removeObjectAtIndex:indexPath.item];
            if (self.urls && self.urls.count > indexPath.item) {
                [self.urls removeObjectAtIndex:indexPath.item];
            }
            [self reloadData];
            if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(picturePicker:imageDeletedAtIndex:)]) {
                [self.pickerDelegate picturePicker:self imageDeletedAtIndex:indexPath.item];
            }
            [self.realValues removeObjectAtIndex:indexPath.item];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:delete];
        [alert addAction:cancel];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
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
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self addImage:image];
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(picturePicker:imageAdded:atIndex:)]) {
        [self.pickerDelegate picturePicker:self imageAdded:image atIndex:self.pictures.count - 1];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter & setter
- (void)setUrls:(NSMutableArray *)urls{
    _urls = [urls mutableCopy];
    [self reloadData];
    [self.realValues addObjectsFromArray:urls];
}

- (void)setPictures:(NSMutableArray *)pictures {
    _pictures = pictures;
    [self reloadData];
    [self.realValues addObjectsFromArray:pictures];
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

#pragma mark - private
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
