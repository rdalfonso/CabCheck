//
//  DDCabListingController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/21/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabListingController.h"
#import "TaxiTableViewCell.h"
#import "Parse/Parse.h"
@implementation DDCabListingController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Title
    self.title = @"Search Results";
    
    PFQuery *broadCast = [PFQuery queryWithClassName:@"DriverObject"];
    [broadCast setLimit:10];
    [broadCast orderByDescending:@"createdAt"];
    [broadCast findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            long qCount = (unsigned long)objects.count;
            NSString* countString = [NSString stringWithFormat:@"%li", qCount];
            NSLog(@"countString %@", countString);
            
            self.taxis =  objects;
            
            for (PFObject *object in objects){
                
                NSString *driver = [NSString stringWithFormat:@"%@", [object objectForKey:@"driver"]];
                NSString *licenseNumber = [NSString stringWithFormat:@"%@", [object objectForKey:@"licenseNumber"]];
                NSString *dmvLicensePlate = [NSString stringWithFormat:@"%@", [object objectForKey:@"dmvLicensePlate"]];
                
                NSLog(@"driver %@", driver);
                NSLog(@"licenseNumber %@", licenseNumber);
                NSLog(@"dmvLicensePlate %@", dmvLicensePlate);
            }
            
            //NSLog(@"taxis > %@", self.taxis);
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.taxis.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taxiTableCell";
    TaxiTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    // Configure the cell...
    
    long row = [indexPath row];
    
    cell.lblTaxiDriver.text = self.taxis[row];

    
    return cell;
}@end
