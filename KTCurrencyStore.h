//
//  KTCurrencyStore.h
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
@interface KTCurrencyStore : NSObject
+(KTCurrencyStore*)sharedStore;
-(BOOL)saveChanges;
-(Currency*)updateCurrency;
-(NSString*)itemArchivePath;
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSManagedObjectContext *context;
-(NSNumber*)convertDollarAmount:(NSString*)amount ForDenom:(NSString*)denom;
@end
