//
//  DDUserSettingsViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDUserSettingsViewController.h"
#import "DDViewController.h"
#import "DDAppDelegate.h"

@implementation DDUserSettingsViewController


- (DDAppDelegate *) appdelegate {
    return (DDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) viewWillAppear:(BOOL)animated{
    _UIiAD = [[self appdelegate] UIiAD];
    _UIiAD.delegate = self;
    [_UIiAD setFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    [self.view addSubview:_UIiAD];
}


-(void) viewWillDisappear:(BOOL)animated{
    _UIiAD.delegate = nil;
    _UIiAD=nil;
    [_UIiAD removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"ads loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:1];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"ads not loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:0];
    [UIView commitAnimations];
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerview was selected");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return willLeave;
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
    
    [_userCurrentCity setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [self.userSMSContact1 resignFirstResponder];
    [self.userSMSContact2 resignFirstResponder];
    [self.userSMSContact3 resignFirstResponder];
    
    self.userSMSContact1.delegate = self;
    self.userSMSContact2.delegate = self;
    self.userSMSContact3.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userCurrentCity =(int)[defaults integerForKey:@"userCurrentCity"];
    [_userCurrentCity setSelectedSegmentIndex:userCurrentCity];
 
    NSMutableArray *userSMSNumbers = [NSMutableArray arrayWithArray:[defaults objectForKey:@"userSMSNumbers"]];
    
    NSUInteger arrCount = (unsigned long)[userSMSNumbers count] ;
    if(arrCount > 0)
    {
        NSString *userSMS1 = [userSMSNumbers objectAtIndex:0];
        if([userSMS1 length] > 0) {
            _userSMSContact1.text = userSMS1;
        }
    }
    if(arrCount > 1)
    {
        NSString *userSMS2 = [userSMSNumbers objectAtIndex:1];

        if([userSMS2 length] > 0) {
            _userSMSContact2.text = userSMS2;
        }
    }
    if(arrCount > 2)
    {
        NSString *userSMS3 = [userSMSNumbers objectAtIndex:2];
        if([userSMS3 length] > 0) {
            _userSMSContact3.text = userSMS3;
        }
    }
    
    //allow banner ads
    self.canDisplayBannerAds = YES;
}


- (IBAction)btnSaveUserSettings:(id)sender {
    
    int userCurrentCity = (int)_userCurrentCity.selectedSegmentIndex;
    NSString *userSMS1 = _userSMSContact1.text;
    NSString *userSMS2 = _userSMSContact2.text;
    NSString *userSMS3 = _userSMSContact3.text;
    
    NSMutableArray *smsNumbers = [[NSMutableArray alloc] init];
    
    if([userSMS1 length] > 0){
        [smsNumbers addObject:userSMS1];
    }
    if([userSMS2 length] > 0){
        [smsNumbers addObject:userSMS2];
    }
    if([userSMS3 length] > 0){
        [smsNumbers addObject:userSMS3];
    }
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:smsNumbers forKey:@"userSMSNumbers"];
    [defaults setInteger:userCurrentCity forKey:@"userCurrentCity"];
    [defaults synchronize];
    
}

-(IBAction) searchBtnUserClick
{
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 10 || returnKey;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userSMSContact1 resignFirstResponder];
    [self.userSMSContact2 resignFirstResponder];
    [self.userSMSContact3 resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.userSMSContact1 resignFirstResponder];
    [self.userSMSContact2 resignFirstResponder];
    [self.userSMSContact3 resignFirstResponder];
    return NO;
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


@end
