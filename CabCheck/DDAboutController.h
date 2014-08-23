//
//  DDAboutController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/20/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface DDAboutController : UIViewController<ADBannerViewDelegate>
@property (strong, nonatomic) ADBannerView *UIiAD;
@end
