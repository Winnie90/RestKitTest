//
//  Station.h
//  
//
//  Created by Christopher Winstanley on 28/05/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Train;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSSet *departures;
@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addDeparturesObject:(Train *)value;
- (void)removeDeparturesObject:(Train *)value;
- (void)addDepartures:(NSSet *)values;
- (void)removeDepartures:(NSSet *)values;

@end
