//
//  UploadViewController2.m
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "UploadViewController2.h"

@interface UploadViewController2 ()
{
    UIImageView *tempImg;
    
    NSIndexPath *selectedIndex;
    
    CheckListDetailRecord *detailChecklist;
}
@end

@implementation UploadViewController2
@synthesize arrImages,arrIndex,arrImageShow;
@synthesize aqua;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item{
    self = [super init];
    aqua = item;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initArr];
    [self initView];
    [self initCollectionView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.navigationBar.translucent = YES;
    if (_delegate) {
        [self.delegate changeView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCollectionView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:IMAGE_CELL
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:IMAGE_CELL];
    
}

#pragma mark InitArr
-(void)initArr{
    arrImages = [[NSMutableArray alloc]init];
    arrImageShow = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 3; ++i){
        [arrImages addObject:[NSNull null]];
    }
    for (NSInteger i = 0; i < 3; ++i){
        [arrImageShow addObject:[NSNull null]];
    }
    arrIndex = [[NSMutableArray alloc]init];
    
    //[self initArrIndex];
}


-(void)initView{
    self.lbl3.layer.cornerRadius = self.lbl3.frame.size.width/2.0;
    self.lbl4.layer.cornerRadius = self.lbl4.frame.size.width/2.0;
    self.lbl3.layer.masksToBounds = YES;
    self.lbl4.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(addPhoto:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(addPhoto:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(addPhoto:)];
    
    [self.imgView1 setUserInteractionEnabled:YES];
    [self.imgView2 setUserInteractionEnabled:YES];
    [self.imgView3 setUserInteractionEnabled:YES];
    
    [self.imgView1 addGestureRecognizer:tap1];
    [self.imgView2 addGestureRecognizer:tap2];
    [self.imgView3 addGestureRecognizer:tap3];
    
    self.imgView1.tag = 0;
    self.imgView2.tag = 1;
    self.imgView3.tag = 2;
    
    self.txtSoLuong.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtTrongLuong.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtSizeBinhQuan.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtTrongLuong.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtThongSoDO.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtThongSoNO2.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtThongSoPH.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.txtSoLuong.delegate = (id)self;
    self.txtTrongLuong.delegate = (id)self;
    self.txtSizeBinhQuan.delegate = (id)self;
    
    self.images = [[NSMutableArray alloc] init];
    [self.images addObject:self.imgView1];
    [self.images addObject:self.imgView2];
    [self.images addObject:self.imgView3];
    
    self.completedHandler = ^(id data){
        detailChecklist = data;
    };
}
-(void)addPhoto:(UITapGestureRecognizer *)tap{
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = (id)self;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.maximumNumberOfSelection = 1;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
    tempImg = (UIImageView *)tap.view;
}

#pragma mark QBImagePickerController Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    for(int i = 0; i < [assets count]; i++) {
        [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
        
        PHImageManager *imageManager = [PHImageManager new];
        [imageManager requestImageDataForAsset:[assets objectAtIndex:i]
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     
                                     UIImage *image = [UIImage imageWithData:imageData];
                                     NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
                                     NSString *imageName = [[url absoluteString] lastPathComponent];
                                     NSUInteger imageSize = imageData.length;
                                     
                                     NSString *formatName = StringFormat(@"%@_%@_%@",aqua.a_id,[ShareHelper getCurrentDate2],imageName);
                                     
                                     PhotoUpload *photoObj = [PhotoUpload new];
                                     photoObj.name = formatName;
                                     photoObj.size = imageSize;
                                     photoObj.url = url;
                                     photoObj.dataImage = imageData;
                                     photoObj.image = image;

                                     
                                     if (tempImg.image) {
                                         [arrImages replaceObjectAtIndex:tempImg.tag withObject:photoObj];
                                     }
                                     
                                     tempImg.image = image;
                                     
                                 }];
        
        
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(([self.txtSoLuong.text isEqualToString:@"0"] || [self.txtSoLuong.text isEqualToString:@"0.0"]) && ([self.txtTrongLuong.text isEqualToString:@"0"] || [self.txtTrongLuong.text isEqualToString:@"0.0"])){
        [self.txtSizeBinhQuan setUserInteractionEnabled:YES];
    }
    else if ((![self.txtTrongLuong.text isEqualToString:@"0"] || ![self.txtTrongLuong.text isEqualToString:@"0.0"]) && ![ShareHelper checkWhiteSpace:self.txtTrongLuong.text]) {
        if ([self.txtSoLuong.text isEqualToString:@"0"] || [self.txtSoLuong.text isEqualToString:@"0.0"]) {
            [self showAlertBox:ERROR message:@"Số lượng phải khác 0" tag:99];
            [self.txtSizeBinhQuan setUserInteractionEnabled:NO];
        }
        else if ([ShareHelper checkWhiteSpace:self.txtSoLuong.text]){
            [self showAlertBox:ERROR message:@"Vui lòng nhập Số lượng" tag:99];
        }
        else{
            float sizeBinhQuan = [self.txtTrongLuong.text floatValue]*1000/[self.txtSoLuong.text floatValue];
            self.txtSizeBinhQuan.text = StringFormat(@"%.2f",sizeBinhQuan);
        }
    }
    else if ((![self.txtSoLuong.text isEqualToString:@"0"] || ![self.txtSoLuong.text isEqualToString:@"0.0"]) && ((![self.txtTrongLuong.text isEqualToString:@"0"] || ![self.txtTrongLuong.text isEqualToString:@"0.0"]) && ![ShareHelper checkWhiteSpace:self.txtTrongLuong.text])){
        float sizeBinhQuan = [self.txtTrongLuong.text floatValue]*1000/[self.txtSoLuong.text floatValue];
        self.txtSizeBinhQuan.text = StringFormat(@"%f",sizeBinhQuan);
    }
    NSLog(@"--------------------------%@",self.txtTrongLuong.text);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return arrImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IMAGE_CELL forIndexPath:indexPath];
    
    if ([arrImageShow objectAtIndex:indexPath.row] != [NSNull null]) {
        UIImage *image = [arrImageShow objectAtIndex:indexPath.row];
        cell.imgView.image = [ShareHelper imageByScalingAndCroppingForSize: image targetSize:CGSizeMake(2*cell.frame.size.width,2*cell.frame.size.height)];
        cell.btnDelete.hidden = NO;
        cell.imgAdd.hidden = YES;
    }
    else{
        cell.btnDelete.hidden = YES;
        cell.imgAdd.hidden = NO;
        cell.imgView.image = nil;
        
    }
    
    cell.btnDelete.index = indexPath;
    [cell.btnDelete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.imgView.layer setBorderColor:[UIColor blackColor].CGColor];
    [cell.imgView.layer setBorderWidth:1.0];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath;
    
    if ([arrImages objectAtIndex:indexPath.row] !=[NSNull null]){
        UIImage *image = [arrImages objectAtIndex:indexPath.row];
//        ShowImageViewController *showImageViewController = [[ShowImageViewController alloc] initWithNibName:@"ShowImageViewController" bundle:nil Image:image];
//        showImageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
//        
//        __weak ShowImageViewController *weakSelf = showImageViewController;
//        showImageViewController.dismissHandler = ^(){
//            [self dismissPopupViewControllerWithanimationType:weakSelf animationType:MJPopupViewAnimationSlideBottomTop];
//        };
//        [self presentPopupViewController:showImageViewController animationType:MJPopupViewAnimationSlideBottomTop dismissed:^{
//            
//        }];
    }
    else{
        [self showCamera];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger numberOfColumns = 3;
    //float width = (screenSize.width-26)/numberOfColumns;
    float width = (self.collectionView.frame.size.width-15)/numberOfColumns;
    float hight = self.collectionView.frame.size.height;
    
    return CGSizeMake(width, hight);
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}

#pragma mark Delete Image

-(void)deleteImage:(id)sender{
    
    NSIndexPath *indexPath = ((CustomButton *)sender).index;
    
    [self.collectionView performBatchUpdates:^{
        
        if (arrIndex.count > 0) {
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSString *index in arrIndex) {
                [temp addObject:index];
            }
            for (NSString *index in temp) {
                if ([index isEqualToString:StringFormat(@"%ld",(long)indexPath.row)]) {
                    [detailChecklist.c_detailFishDeadRecord.dF_images removeObjectAtIndex:[arrIndex indexOfObject:index]];
                    [arrIndex removeObject:index];
                }
            }
        }
        [arrImages replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
        [arrImageShow replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
        
        NSLog(@"-----Arr Images---------:%@",arrImages);
        NSLog(@"-----Arr Upload---------:%@",arrImageShow);
        NSLog(@"-----Arr Index---------:%@",arrIndex);
    } completion:^(BOOL finished) {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
    }];
}

-(void)showCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(chosenImage, self,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [SVProgressHUD show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    [SVProgressHUD dismiss];
    if (error) {
        [self showAlertBox:TITLE_ALERT message:[error localizedDescription] tag:1];
    } else {
        PHAsset *asset = nil;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        if (fetchResult != nil && fetchResult.count > 0) {
            // get last photo from Photos
            asset = [fetchResult lastObject];
        }
        
        if (asset) {
            // get photo info from this asset
            PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
            imageRequestOptions.synchronous = YES;
            [[PHImageManager defaultManager]
             requestImageDataForAsset:asset
             options:imageRequestOptions
             resultHandler:^(NSData *imageData, NSString *dataUTI,
                             UIImageOrientation orientation,
                             NSDictionary *info)
             {
                 NSLog(@"info = %@", info);
                 if ([info objectForKey:@"PHImageFileURLKey"]) {
                     // path looks like this -
                     // file:///var/mobile/Media/DCIM/###APPLE/IMG_####.JPG
                     UIImage *image = [UIImage imageWithData:imageData];
                     NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
                     NSString *imageName = [[url absoluteString] lastPathComponent];
                     NSUInteger imageSize = imageData.length;
                     
                     NSString *formatName = StringFormat(@"%@_%@_%@",aqua.a_id,[ShareHelper getCurrentDate2],imageName);
                     
                     PhotoUpload *photoObj = [PhotoUpload new];
                     photoObj.name = formatName;
                     photoObj.size = imageSize;
                     photoObj.url = url;
                     photoObj.dataImage = imageData;
                     photoObj.image = image;
                     
                     if (arrIndex.count > 0) {
                         NSMutableArray *temp = [[NSMutableArray alloc] init];
                         for (NSString *index in arrIndex) {
                             [temp addObject:index];
                         }
                         for (NSString *index in temp) {
                             if ([index isEqualToString:StringFormat(@"%ld",(long)selectedIndex.row)]) {
                                 [detailChecklist.c_detailFishDeadRecord.dF_images removeObjectAtIndex:[arrIndex indexOfObject:index]];
                                 [arrIndex removeObject:index];
                             }
                         }
                     }
                     
                     [arrImages replaceObjectAtIndex:selectedIndex.row withObject:photoObj];
                     [arrImageShow replaceObjectAtIndex:selectedIndex.row withObject:image];
                     
                     [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex.row inSection:0]]];
                     NSLog(@"-----Arr Image---------:%@",arrImages);
                     
                     for (int i = 0; i < arrImages.count; i++) {
                         if ([arrImages objectAtIndex:i]==[NSNull null]) {
                         }
                     }
                     
                 }
             }];
        }
        
    }
}

@end
