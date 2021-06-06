//
//  EPSHelpViewController.m
//  epcoding-ios
//
//  Created by David Mann on 2/19/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSHelpViewController.h"
#import "EPSAbout.h"

@interface EPSHelpViewController ()

@end

@implementation EPSHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"] isDirectory:NO];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    // centers view with navigationbar in place
    self.edgesForExtendedLayout = UIRectEdgeNone;


    if (@available(iOS 13.0, *)) {
        self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target: self action:@selector(goBack:)];
        self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"] style:UIBarButtonItemStylePlain target: self action:@selector(goForward:)];
        [self.navigationItem setRightBarButtonItems:@[self.forwardButton, self.backButton] animated:YES];

        [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
        [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:NULL];
        [self updateButtons];

    } else {
        // Do any additional setup after loading the view.
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAbout {
    [EPSAbout show:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath  isEqual: @"canGoBack"] || [keyPath  isEqual: @"canGoForward"]) {
        [self updateButtons];
    }
}

-(void)updateButtons {
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}


-(void)goBack:(UIBarButtonItem *) sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

-(void)goForward:(UIBarButtonItem *) sender {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

@end
