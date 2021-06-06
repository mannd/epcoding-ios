//
//  EPSHelpViewController.h
//  epcoding-ios
//
//  Created by David Mann on 2/19/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WebKit/WKNavigationDelegate.h>

@interface EPSHelpViewController : UIViewController
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *forwardButton;

@end
