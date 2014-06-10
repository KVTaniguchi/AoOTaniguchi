//
//  KTDataLoader.h
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KTDataLoader : NSObject
-(void)setUpDataLoader;
-(void)grabRateData;
@property (nonatomic,strong) NSNumber *pounds;
@property (nonatomic,strong) NSNumber *yen;
@property (nonatomic,strong) NSNumber *euros;
@property (nonatomic,strong) NSNumber *reais;
@end
