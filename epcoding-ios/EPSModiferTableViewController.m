//
//  EPSModiferTableViewController.m
//  EP Coding
//
//  Created by David Mann on 2/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSModiferTableViewController.h"
#import "EPSModifiers.h"

#define HIGHLIGHT_COLOR cyanColor

@interface EPSModiferTableViewController ()
{
    BOOL cancel;
}

@end

@implementation EPSModiferTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *array = [EPSModifiers allModifiersSorted];
    [EPSModifiers clearSelectedAllModifiers];
    cancel = YES;
    self.modifiers = array;
    self.title = [NSString stringWithFormat:@"%@ Modifiers",self.code.number];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    UIBarButtonItem *addButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Add Modifiers" style: UIBarButtonItemStyleDone target: self action: @selector(addAction)];
    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, addButton, nil];
    for (EPSModifier *modifier in self.modifiers) {
        for (EPSModifier *codeModifier in self.code.modifiers) {
            if ([modifier.number isEqualToString:codeModifier.number]) {
                modifier.selected = YES;
            }
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate sendModifierDataBack:cancel selectedModifiers:[self selectedModifiers]];
}

- (NSArray *)selectedModifiers {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (EPSModifier *modifier in self.modifiers) {
        if (modifier.selected) {
            [array addObject:modifier];
        }
    }
    return [NSArray arrayWithArray:array];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelAction {
    cancel = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAction {
    cancel = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modifiers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *modifierCellIdentifier = @"ModifierCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modifierCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:modifierCellIdentifier];
    
    NSUInteger row = [indexPath row];
    EPSModifier *modifier;
    modifier = [self.modifiers objectAtIndex:row];
    cell.textLabel.text = [modifier number];
    cell.detailTextLabel.text = [modifier fullDescription];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    // default gray color looks bad when background color is red or orange
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.accessoryType = ([modifier selected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        // must specifically set this, or will be set randomly
    cell.backgroundColor = ([modifier selected] ? [UIColor HIGHLIGHT_COLOR] : [UIColor whiteColor]);
        //[cell setBackgroundColor:[UIColor whiteColor]];
    [cell setUserInteractionEnabled:YES];
    
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
        [[self.modifiers objectAtIndex:row] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor HIGHLIGHT_COLOR];
        [[self.modifiers objectAtIndex:row] setSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
