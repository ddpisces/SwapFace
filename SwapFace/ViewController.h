//
//  ViewController.h
//  SwapFace
//
//  Created by zz cienet on 12/2/13.
//  Copyright (c) 2013 zzyunying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UINavigationItem *homeTitle;

@end
