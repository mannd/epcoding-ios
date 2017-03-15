//
//  EPSHelpViewController.m
//  epcoding-ios
//
//  Created by David Mann on 2/19/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSHelpViewController.h"

#define VERSION @"1.6.2"

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
	// Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"] isDirectory:NO];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    // centers view with navigationbar in place
    self.edgesForExtendedLayout = UIRectEdgeNone;

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

- (void)showAbout
{
    NSString *details = [[NSString alloc] initWithFormat: @"Copyright \u00a9 2014-2017 EP Studios, Inc.\nAll rights reserved.\nVersion %@" , VERSION];
    NSString *title = @"EP Coding";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:details preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
