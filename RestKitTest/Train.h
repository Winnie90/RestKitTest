//
//  Train.h
//  
//
//  Created by Christopher Winstanley on 28/05/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station;

@interface Train : NSManagedObject

@property (nonatomic, retain) NSString * service;
@property (nonatomic, retain) NSString * platform;
@property (nonatomic, retain) NSString * operator;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSString * departureTime;
@property (nonatomic, retain) Station *station;

@end
