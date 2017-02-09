//
//  EPSModifierTableViewController.m
//  EP Coding
//
//  Created by David Mann on 2/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSModifierTableViewController.h"
#import "EPSModifiers.h"

#define HIGHLIGHT_COLOR cyanColor

@interface EPSModifierTableViewController ()
{
    BOOL cancel;
    BOOL reset;
    NSInteger cellHeight;
}

@end

@implementation EPSModifierTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    cellHeight = 65;
    NSArray *array = [EPSModifiers allModifiersSorted];
    [EPSModifiers clearSelectedAllModifiers];
    cancel = YES;
    reset = NO;
    self.modifiers = array;
    self.title = [NSString stringWithFormat:@"%@ Modifiers",self.code.number];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle: @"Add" style: UIBarButtonItemStyleDone target: self action: @selector(addAction)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetAction)];
    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, saveButton, resetButton, addButton, nil];
    for (EPSModifier *modifier in self.modifiers) {
        for (EPSModifier *codeModifier in self.code.modifiers) {
            if ([modifier.number isEqualToString:codeModifier.number]) {
                modifier.selected = YES;
            }
        }
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate sendModifierDataBack:cancel reset:reset selectedModifiers:[self selectedModifiers]];
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

- (void)saveAction {
    cancel = NO;
    [self saveModifiers];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetAction {
    // ignore choices, return and have caller reestablish programmed defaults
    cancel = NO;
    reset = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveModifiers {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *selectedModifiers = [self selectedModifiers];
    NSMutableArray *selectedModifierNumbers = [[NSMutableArray alloc] init];
    for (EPSModifier *modifier in selectedModifiers) {
        [selectedModifierNumbers addObject:modifier.number];
    }
    [defaults setValue:selectedModifierNumbers forKey:self.code.number];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modifiers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return cellHeight;
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
