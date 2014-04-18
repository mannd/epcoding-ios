//
//  EPSWizardViewController.m
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSWizardViewController.h"
#import "EPSCodes.h"

@interface EPSWizardViewController ()

@end

@implementation EPSWizardViewController

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
    int numPages = 6;
    // Do any additional setup after loading the view.
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < numPages; ++i) {
        array[i] = [NSString stringWithFormat:@"Step %d", i + 1];
    }
    self.pageTitles = array;
    self.pageContent = @[
                         @"Is this a new implant or simple generator replacement? If so select the appropriate code below. Otherwise go to next step.",
                         @"Is this an upgrade from a single to a dual chamber pacemaker?  If so use code 33244 which covers this entire procedure. If you are also adding an LV cardiac vein lead add code +33225. Otherwise go to the next step.",
                         @"Is this a lead revision or repair or a pocket revision without adding or removing any hardware?  If so use one of the codes below. Otherwise go on to the next step", @"OK. We have addressed the simple scenarios. What's left are lead and generator removals/extractions, and device upgrades. Start off by selecting what hardware (if any) was removed, and then go to the next step.",
                         @"Now if you added any hardware, code what you added.vIf you added a generator and leads, use the new or replacement system codes (e.g. new single chamber PPM).  If you just added a lead or a generator, code for the specific device(s) you added.  Then go to the next step.",
                         @"Did you do anything else? If so select from the choices below. Select Done to see a summary of your codes."];
    self.codes = [EPSCodes allCodesSorted];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    EPSWizardContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self setTitle:@"Wizard"];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(summarize)];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)summarize {
    // TODO
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (EPSWizardContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    EPSWizardContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EPSWizardContentViewController"];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.contentText = self.pageContent[index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.codes = self.codes;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((EPSWizardContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((EPSWizardContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
