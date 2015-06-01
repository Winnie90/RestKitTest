//
//  AppDelegate.m
//  RestKitTest
//
//  Created by Christopher Winstanley on 28/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSURL *baseURL = [NSURL URLWithString:@"http://transportapi.com/v3/uk/train/station/LAN/2015-06-01/15:32/timetable.json?api_key=1c7544540e3f2324cd3f0b4eaeb485ba&app_id=42e503c6"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Initialize managed object model from bundle
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // Complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"TrainsDB.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    RKEntityMapping *departureListMapping = [RKEntityMapping mappingForEntityForName:@"Station" inManagedObjectStore:managedObjectStore];
    departureListMapping.identificationAttributes = @[@"name"];
    [departureListMapping addAttributeMappingsFromDictionary:@{ @"station_name" : @"name", @"station_code" : @"code"}];
    
    RKEntityMapping *trainListMapping = [RKEntityMapping mappingForEntityForName:@"Train" inManagedObjectStore:managedObjectStore];
    trainListMapping.identificationAttributes = @[@"service"];
    [trainListMapping addAttributeMappingsFromDictionary:@{ @"service" : @"service", @"platform" : @"platform" , @"operator" : @"operator", @"destination_name" : @"destination" , @"origin_name" : @"origin", @"aimed_departure_time" : @"departureTime"}];
    
    [departureListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"departures.all" toKeyPath:@"departures" withMapping:trainListMapping]];
    
    RKResponseDescriptor *stationResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:departureListMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:@""
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [objectManager addResponseDescriptor:stationResponseDescriptor];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
