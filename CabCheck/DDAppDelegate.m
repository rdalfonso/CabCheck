//
//  DDAppDelegate.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDAppDelegate.h"
#import <Parse/Parse.h>
#import <sys/xattr.h>

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"oQqCntjOzHfCBB7q7Udy575SciiMRZoAWotnz9Mn"
                  clientKey:@"SGDYQaGgVbDXHpPIKXwR505RJL0plP8D3zYOFwWW"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        _UIiAD = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        _UIiAD = [[ADBannerView alloc] init];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:.62 blue:.984 alpha:1]];
    
    //Requirement to remove sqlite database from iCloud backup
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbDocumentPath = [docPaths objectAtIndex:0];
    
    NSString *dbName = @"CabCheck.sqlite";
    NSString *dbFullDocumentPath = [NSString stringWithFormat:@"%@/%@", dbDocumentPath, dbName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbFullDocumentPath]) {
        
        NSLog(@"SQLite file does not exist in documents. New install. Need to copy and prevent iCloud backup");
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:dbFullDocumentPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } else {
        NSLog(@"SQLite already exists in : %@", dbDocumentPath);
    }
    
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dbFullDocumentPath]];
    
    return YES;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error Excluding %@ from backup %@", [URL lastPathComponent], error);
    } else {
        NSLog(@"Success excluding %@ from backup", [URL lastPathComponent]);
    }
    
    return success;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
