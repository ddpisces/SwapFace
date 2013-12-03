//
//  ViewController.m
//  SwapFace
//
//  Created by zz cienet on 12/2/13.
//  Copyright (c) 2013 zzyunying. All rights reserved.
//

#import "ViewController.h"
#import "SlideImageView.h"

@interface ViewController ()

@end

@implementation ViewController{
    SlideImageView *imageSelectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
    
    CGRect rect = {{20.0,100.0},{250.0,350.0}};
    imageSelectionView = [[SlideImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.3 Alpha:1000];
    imageSelectionView.borderColor = [UIColor grayColor];
    //    imageSelectionView.delegate = self;

    UIImage* image = [UIImage imageNamed:@"girl"];
    UIImage* image2 = [UIImage imageNamed:@"landscape"];
    [imageSelectionView addImage:image];
    
    [imageSelectionView addImage:image2];
    [imageSelectionView setImageShadowsWtihDirectionX:5 Y:5 Alpha:0.7];
    [imageSelectionView reLoadUIview];
    [self.view addSubview:imageSelectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
