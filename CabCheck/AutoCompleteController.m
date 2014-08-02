//
//  AutoCompleteController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 8/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "AutoCompleteController.h"
#import "DDSearchResultDetailController.h"
#import <Parse/Parse.h>

@interface AutoCompleteController ()

@end

@implementation AutoCompleteController
@synthesize urlField = urlField;
@synthesize pastUrls;
@synthesize autocompleteUrls;
@synthesize autocompleteTableView;
@synthesize btnSearch;

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
    
    self.pastUrls = [[NSMutableArray alloc] initWithObjects:@"www.google.com", @"www.grogle.com", @"www.gpogle.com", nil];
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    
    self.urlField.delegate = self;
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
}

- (IBAction)goPressed {
    
    // Clean up UI
    [urlField resignFirstResponder];
    autocompleteTableView.hidden = YES;
    
    // Add the URL to the list of entered URLS as long as it isn't already there
    if (![pastUrls containsObject:urlField.text]) {
        [pastUrls addObject:urlField.text];
    }
    
    self.taxiUniqueID = urlField.text;
    NSLog(@"SELECTED");
    
    [self performSegueWithIdentifier:@"pushAutoResultsToDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushAutoResultsToDetail"]) {
        DDSearchResultDetailController *destViewController = segue.destinationViewController;
        
        if([self.taxiObject.objectId length] > 0) {
            destViewController.taxiUniqueID = self.taxiUniqueID;
        }
    }
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteUrls removeAllObjects];
    
    
    //PARSE SEARCH
    PFQuery *searchByMedallion = [PFQuery queryWithClassName:@"DriverObjectComplete"];
    [searchByMedallion whereKey:@"driverMedallion" containsString:substring];
    
    PFQuery *searchByDMVLicense = [PFQuery queryWithClassName:@"DriverObjectComplete"];
    [searchByDMVLicense whereKey:@"driverDMVLicense" containsString:substring];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[searchByMedallion,searchByDMVLicense]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
    {
        if (!error)
        {
            for (PFObject *object in results)
            {
                NSString *driverName = [object objectForKey:@"driverName"];
                NSString *driverMedallion = [object objectForKey:@"driverMedallion"];
                
                if ( [driverMedallion length] > 0) {
                    NSLog(@"Adding...");
                    [autocompleteUrls addObject:driverMedallion];
                }
                
            }
            [autocompleteTableView reloadData];
        }
        
    }];

    
   /*
    for(NSString *curString in pastUrls)
    {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            NSLog(@"curString...%@", curString);
            [autocompleteUrls addObject:curString];
        }
    }
    */
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"substring...%@", substring);
    
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompleteUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    cell.textLabel.text = [autocompleteUrls objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    urlField.text = selectedCell.textLabel.text;
    
    [self goPressed];
    
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

- (IBAction)urlField:(id)sender {
}
@end
