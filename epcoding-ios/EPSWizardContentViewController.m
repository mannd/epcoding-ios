//
//  EPSWizardContentViewController.m
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSWizardContentViewController.h"
#import "EPSCodes.h"

@interface EPSWizardContentViewController ()

@end

@implementation EPSWizardContentViewController

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.codes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchCellIdentifier = @"wizardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    
    if (cell == nil) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:searchCellIdentifier];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellIdentifier];
        }
    }
    
    NSUInteger row = [indexPath row];
    EPSCode *code = nil;
    

    code = [self.codes objectAtIndex:row];

    cell.detailTextLabel.text = [code unformattedCodeDescription];
    cell.textLabel.text = [code unformattedCodeNumber];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    // default gray color looks bad when background color is red or orange
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    return cell;
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


@end
