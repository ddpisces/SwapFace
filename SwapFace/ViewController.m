//
//  ViewController.m
//  SwapFace
//
//  Created by zz cienet on 12/2/13.
//  Copyright (c) 2013 zzyunying. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"
#import "SlideImageView.h"

@interface ViewController ()

-(void)initPhotosCollected;

@end

@implementation ViewController{
    SlideImageView *imageSelectionView;
    
    ALAssetsLibrary *library;
    NSMutableArray *imageAsset;
    
    NSInteger imageCount;
    
    ALAssetsGroup *assetsGroup;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (!imageAsset) {
        imageAsset = [[NSMutableArray alloc]init];
    }
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
    
    CGRect rect = {{20.0,100.0},{250.0,350.0}};
    imageSelectionView = [[SlideImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.3 Alpha:1000];
//    imageSelectionView.borderColor = [UIColor grayColor];
//    imageSelectionView.delegate = self;
//
//    UIImage* image = [UIImage imageNamed:@"girl"];
//    UIImage* image2 = [UIImage imageNamed:@"landscape"];
//    [imageSelectionView addImage:image];
//    
//    [imageSelectionView addImage:image2];
//    [imageSelectionView setImageShadowsWtihDirectionX:5 Y:5 Alpha:0.7];
//    [imageSelectionView reLoadUIview];
//    [self.view addSubview:imageSelectionView];
    
//    [self getAllPictures];
    
    self.carousel.type = iCarouselTypeCoverFlow2;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllPictures
{
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];

    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                [imageAsset addObject:result];
            }
        } else {
            NSLog(@"Image Number:%d", [imageAsset count]);
            [self initPhotosCollected];
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            imageCount = [group numberOfAssets];
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}


-(void)initPhotosCollected
{
    [imageAsset enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        // load the asset for this cell
        if (obj) {
            ALAsset *asset = imageAsset[idx];
            UIImage *thumbnail = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [imageSelectionView addImage:thumbnail];
        }
        
        // loat at most 4 images when start up
        if ((idx >= [imageAsset count] - 1) || (idx > 4)) {
            [imageSelectionView reLoadUIview];
            *stop = YES;
        }
        
    }];
    
}

#pragma mark - SlideImageView Delegate

- (void)SlideImageViewDidScrollWithIndex:(int)index
{
}

- (void)SlideImageViewDidEndScorllWithIndex:(int)index
{
    NSLog(@"which image:%d", index);
}

#pragma mark - iCarousel Data Source
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 20;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    float height, width;
    
    if (view == nil) {
        view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"girl" ]];
        NSLog(@"image x:%f, y:%f", view.frame.size.height, view.frame.size.width);

        height = 300.0;
        width  = height * view.frame.size.width / view.frame.size.height;
        view.frame = CGRectMake(0, 0, width, height);
        
    }
    
    return view;
}


@end
