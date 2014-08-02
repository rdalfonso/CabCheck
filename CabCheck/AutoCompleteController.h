//
//  AutoCompleteController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 8/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AutoCompleteController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UITextField *urlField;
    NSMutableArray *pastUrls;
    NSMutableArray *autocompleteUrls;
    UITableView *autocompleteTableView;
    UIButton *btnSearch;
}
@property (strong, nonatomic) IBOutlet UITextField *urlField;
@property (nonatomic, retain) NSMutableArray *pastUrls;
@property (nonatomic, retain) NSMutableArray *autocompleteUrls;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) PFObject *taxiObject;
@property (nonatomic, strong) NSString *taxiUniqueID;

- (IBAction)goPressed;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;




@end
