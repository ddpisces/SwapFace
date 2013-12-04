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

-(void)allPhotosCollected;

@end

@implementation ViewController{
    SlideImageView *imageSelectionView;
    
    ALAssetsLibrary *library;
    NSMutableArray *imageUrlArray;
    
    NSInteger imageCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
    
    CGRect rect = {{20.0,100.0},{250.0,350.0}};
    imageSelectionView = [[SlideImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.3 Alpha:1000];
//    imageSelectionView.borderColor = [UIColor grayColor];
    //    imageSelectionView.delegate = self;

    UIImage* image = [UIImage imageNamed:@"girl"];
    UIImage* image2 = [UIImage imageNamed:@"landscape"];
    [imageSelectionView addImage:image];
    
    [imageSelectionView addImage:image2];
    [imageSelectionView setImageShadowsWtihDirectionX:5 Y:5 Alpha:0.7];
    [imageSelectionView reLoadUIview];
    [self.view addSubview:imageSelectionView];
    
    [self getAllPictures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllPictures
{
    imageUrlArray = [[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                [imageUrlArray addObject:[[result defaultRepresentation]url]];
                
                if ([imageUrlArray count] == imageCount)
                {
                    [self allPhotosCollected];
                }
                
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
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


-(void)allPhotosCollected
{
    [imageUrlArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSURL *url= (NSURL*)obj;
        
        [library assetForURL:url
                 resultBlock:^(ALAsset *asset) {
                     UIImage *tempImgage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                     [imageSelectionView addImage:tempImgage];
                     [imageSelectionView reLoadUIview];
                 }
                failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
    }];
    
}

@end
