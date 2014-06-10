//
//  Currency.h
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Currency : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * name;

@end
