//
//  EPSModifierTableViewController.h
//  EP Coding
//
//  Created by David Mann on 2/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPSCode.h"

@protocol sendModifiersProtocol <NSObject>

-(void)sendModifierDataBack:(BOOL)cancel selectedModifiers:(NSArray *)modifiers;

@end

@interface EPSModifierTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *modifiers;
@property (weak, nonatomic) EPSCode *code;

@property(nonatomic,assign)id delegate;

@end
