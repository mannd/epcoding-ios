//
//  EPSWizardContentViewController.m
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSWizardContentViewController.h"
#import "EPSCodes.h"
#import "EPSModifierTableViewController.h"

@interface EPSWizardContentViewController ()

@end

@implementation EPSWizardContentViewController
{
    NSInteger cellHeight;
    EPSCode *selectedCode;
}

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
    self.contentLabel.text = self.contentText;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    cellHeight = 65;
    [self.contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    // add long press handler
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0; //seconds
    longPress.delegate = self;
    [self.codeTableView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendModifierDataBack:(BOOL)cancel reset:(BOOL)reset selectedModifiers:(NSArray *)modifiers {
    if (cancel) {
        return;
    }
    if (reset) {
        NSLog(@"Reset modifiers");
        // TODO: are we resetting just modified code, or all codes in module?
        // this:        [selectedCode clearModifiers];
        // or this:
        [EPSCodes clearModifiers:self.codes];
//        [self resetSavedModifiers];
//        [self loadDefaultModifiers];
    }
    else {
        [selectedCode clearModifiers];
        [selectedCode addModifiers:modifiers];
    }
    [self.codeTableView reloadData];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showModifiersFromWizard"]) {
        EPSModifierTableViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.code = selectedCode;
    }

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.codes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *wizardCellIdentifier = @"wizardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:wizardCellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:wizardCellIdentifier];
    
    
    NSUInteger row = [indexPath row];
    EPSCode *code = nil;
    

    code = [self.codes objectAtIndex:row];

    cell.detailTextLabel.text = [code unformattedCodeDescription];
    cell.textLabel.text = [code unformattedCodeNumber];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    // default gray color looks bad when background color is red or orange
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    cell.accessoryType = ([code selected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    // must specifically set this, or will be set randomly
    cell.backgroundColor = ([code selected] ? [UIColor yellowColor] : [UIColor whiteColor]);
    //[cell setBackgroundColor:[UIColor whiteColor]];
    [cell setUserInteractionEnabled:YES];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = indexPath.row;
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            [[self.codes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = [UIColor yellowColor];
            [[self.codes objectAtIndex:row] setSelected:YES];
        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Gesture recognizer delegate

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.codeTableView];
    
    NSIndexPath *indexPath = [self.codeTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        selectedCode = nil;
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        NSUInteger row = indexPath.row;
        selectedCode = [self.codes objectAtIndex:row];
        NSLog(@"selected code = %@", [selectedCode unformattedCodeNumber]);
        [self performSegueWithIdentifier:@"showModifiersFromWizard" sender:nil];
        
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}




@end
