//
//  DDSearchResultsController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/20/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSearchResultsController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtSearchString;
- (IBAction)btnSearch:(id)sender;

@end
