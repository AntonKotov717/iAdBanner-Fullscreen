//
//  ViewController.m
//  iAdBanner-Fullscreen
//
//  Created by dev on 1/7/16.
//  Copyright © 2016 com.appcoda. All rights reserved.
//

#import "ViewController.h"
#import <iAd/iAd.h>

@interface ViewController (){
    ADInterstitialAd* _interstitial;
    BOOL _requestingAd;
    UIView *_adView;
    
    BOOL _bannerIsVisible;
    ADBannerView *_adBanner;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AdBannerView Ad
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    _adBanner.delegate = self;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBanner.superview == nil)
        {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
}

#pragma mark Interstitial Ad

-(void)showFullScreenAd {
    if (_requestingAd == NO) {
        _interstitial = [[ADInterstitialAd alloc] init];
        _interstitial.delegate = self;
        NSLog(@"Ad Request");
        _requestingAd = YES;
    }
    
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    _requestingAd = NO;
    NSLog(@"Ad didFailWithERROR");
    NSLog(@"%@", error);
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"Ad DidLOAD");
    if (interstitialAd.loaded) {
        
        CGRect interstitialFrame = self.view.bounds;
        interstitialFrame.origin = CGPointMake(0, 0);
        _adView = [[UIView alloc] initWithFrame:interstitialFrame];
        [self.view addSubview:_adView];
        
        [_interstitial presentInView:_adView];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"close1.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 10, 30, 30);
        [_adView addSubview:button];
        
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        [UIView setAnimationDuration:1];
        [_adView setAlpha:1];
        [UIView commitAnimations];
        
    }
}

-(void)closeAd:(id)sender {
    [UIView beginAnimations:@"animateAdBannerOff" context:nil];
    [UIView setAnimationDuration:1];
    [_adView setAlpha:0];
    [UIView commitAnimations];
    
    _adView=nil;
    _requestingAd = NO;
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    _requestingAd = NO;
    NSLog(@"Ad DidUNLOAD");
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
    _requestingAd = NO;
    NSLog(@"Ad DidFINISH");
}
- (IBAction)fullScreenButton:(id)sender {
    [self showFullScreenAd];
}
@end
