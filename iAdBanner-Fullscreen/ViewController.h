//
//  ViewController.h
//  iAdBanner-Fullscreen
//
//  Created by dev on 1/7/16.
//  Copyright © 2016 com.appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface ViewController : UIViewController<ADInterstitialAdDelegate, ADBannerViewDelegate>

-(void)showFullScreenAd;
@property (weak, nonatomic) IBOutlet UIButton *fullScreen;
- (IBAction)fullScreenButton:(id)sender;

@end

