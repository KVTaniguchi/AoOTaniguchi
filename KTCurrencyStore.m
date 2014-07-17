//
//  KTCurrencyStore.m
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTCurrencyStore.h"

@implementation KTCurrencyStore
@synthesize context,model;

+(KTCurrencyStore*)sharedStore{
    static KTCurrencyStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedStore];
}

-(id)init{
    self = [super init];
    if (self) {
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSURL *documentsDirectory = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self.context = [[NSManagedObjectContext alloc]init];
        [self.context setPersistentStoreCoordinator:psc];
        [self.context setUndoManager:nil];
    }
    return self;
}

-(NSString*)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingString:@"storeRoute.data"];
}

-(BOOL)saveChanges{
    NSError *error = nil;
    BOOL success = [[KTCurrencyStore sharedStore].context save:&error];
    if (!success) {
        NSLog(@"error saving: %@", [error localizedDescription]);
    }
    return success;
}

-(Currency*)updateCurrency{
    Currency *c = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:self.context];
    return c;
}

-(NSNumber*)convertDollarAmount:(NSString*)amount ForDenom:(NSString*)denom{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Currency" inManagedObjectContext:[KTCurrencyStore sharedStore].context];
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"name = %@", denom];
    [request setPredicate:predicateName];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedCurrency = [[KTCurrencyStore sharedStore].context executeFetchRequest:request error:&error];
    Currency *currency  = [fetchedCurrency lastObject];
    double dollarAmount = [amount doubleValue];
    double currValue = [currency.value doubleValue];
    return [NSNumber numberWithDouble:dollarAmount * currValue];
}


@end
