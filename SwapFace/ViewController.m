//
//  ViewController.m
//  SwapFace
//
//  Created by zz cienet on 12/2/13.
//  Copyright (c) 2013 zzyunying. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"

#define FITHEITHT   300
#define FITWIDTH    200

@interface ViewController ()

@end

@implementation ViewController{
    
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
    
    self.carousel.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
    
    self.carousel.type = iCarouselTypeCoverFlow2;
    
    [self getAllPictures];
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
            [self.carousel reloadData];
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


#pragma mark - iCarousel Data Source
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [imageAsset count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        ALAsset *photoAsset = imageAsset[index];
        ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                       scale:[assetRepresentation scale]
                                                 orientation:UIImageOrientationUp];
        
        view = [[UIImageView alloc] initWithImage:fullScreenImage];
        NSLog(@"image x:%f, y:%f", view.frame.size.height, view.frame.size.width);

        view.frame = [self adjustImageSize:view.frame.size];
        NSLog(@"image x:%f, y:%f", view.frame.size.height, view.frame.size.width);
    }
    
    return view;
}

- (CGRect)adjustImageSize:(CGSize)size
{
    float height, width;
    CGRect rect = CGRectMake(0.0, 0.0, 0.0, 0.0);
    
    height = size.height;
    width  = size.width;
    
    if (width/height >= FITWIDTH/FITHEITHT) {
        if (width > FITWIDTH) {
            rect.size.width  = FITWIDTH;
            rect.size.height = (height * FITWIDTH)/width;
        } else {
            rect.size.width  = width;
            rect.size.height = height;
        }
    } else {
        if (height >= FITHEITHT) {
            rect.size.height = FITHEITHT;
            rect.size.width  = (width * FITHEITHT)/height;
        } else {
            rect.size.height = height;
            rect.size.width  = width;
        }
    }
    
    return rect;
}

@end
