//
//  DDCabListingController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/21/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabListingController.h"

@implementation DDCabListingController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"driver"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
                                 [object objectForKey:@"licenseNumber"]];
    
    return cell;
}
@end
