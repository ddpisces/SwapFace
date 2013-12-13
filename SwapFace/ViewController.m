//
//  ViewController.m
//  SwapFace
//
//  Created by zz cienet on 12/2/13.
//  Copyright (c) 2013 zzyunying. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"

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
