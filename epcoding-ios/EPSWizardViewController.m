//
//  EPSWizardViewController.m
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSWizardViewController.h"
#import "EPSCodes.h"
#import "EPSCode.h"
#import "EPSCodeSummaryTableViewController.h"


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
 
    self.pageContent = @[
                         @"Step 1. Is this a new implant or simple generator replacement? If so select the appropriate code below and press Done. Otherwise go to next step.",
                         @"Step 2. Is this an upgrade from a single to a dual chamber pacemaker?  If so use code 33214 which covers this entire procedure and press Done. Otherwise go to the next step.",
                         @"Step 3. Is this a lead revision or repair or a pocket revision without adding or removing any hardware?  If so use one of the codes below and press Done. Otherwise go on to the next step",
                         @"Step 4. What's left are lead and generator removals/extractions, and device upgrades. Select what hardware (if any) was removed, and go to the next step.",
                         @"Step 5. Now code any added hardware. If you added a generator and leads, use the new or replacement system codes, otherwise code for the specific device(s) you added.  Then go to the next step.",
                         @"Step 6. Did you do anything else? If so select from the choices below. Select Done to see a summary of your codes."];
    self.codes = [EPSCodes allCodesSorted];
    
    self.codeNumbers = @[@[@"33206", @"33207", @"33208", @"33227", @"33228", @"33229", @"33249", @"33262", @"33263", @"33264", @"33225"], @[@"33214", @"33225"], @[@"33215", @"33226", @"33218", @"33220", @"33222", @"33223"], @[@"33233", @"33241", @"33234", @"33235", @"33244"],
                         @[@"33206", @"33207", @"33208", @"33249", @"33216", @"33217", @"33225", @"33212", @"33213", @"33240", @"33230", @"33231"],
                         @[@"93641", @"33210", @"33218", @"33220", @"92960", @"92961"]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.codeNumbers count]; ++i) {
        array[i] = [EPSCodes getCodesForCodeNumbers:self.codeNumbers[i]];
        for (EPSCode *code in array[i]) {
            code.selected = NO;
        }
    }
    self.codeArrays = array;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    EPSWizardContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
   // self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self setTitle:@"Device Wizard"];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(summarize)];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)summarize {
    // TODO
    NSMutableArray *codes = [[NSMutableArray alloc] init];
    for (NSArray *array in self.codeArrays) {
        for (EPSCode *code in array) {
            if ([code selected]) {
                code.codeStatus = GOOD;
                [codes addObject:code];
            }
        }
    }
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:codes];
    NSArray *orderedCodes = [set array];
    self.selectedCodes = [NSMutableArray arrayWithArray:orderedCodes];
    [self performSegueWithIdentifier:@"showWizardSummary" sender:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setToolbarHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWizardSummary"]) {
        [[segue destinationViewController] setSelectedPrimaryCodes:self.selectedCodes];
        [[segue destinationViewController] setSelectedSecondaryCodes:nil];
        [[segue destinationViewController] setIgnoreNoSecondaryCodesSelected:YES];
    }
}


- (EPSWizardContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
    EPSWizardContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EPSWizardContentViewController"];
    pageContentViewController.contentText = self.pageContent[index];
    pageContentViewController.pageIndex = index;
    
    pageContentViewController.codes = self.codeArrays[index];
    
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
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageContent count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
