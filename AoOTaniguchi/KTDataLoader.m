//
//  KTDataLoader.m
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 6/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTDataLoader.h"
#import "Currency.h"
#import "KTCurrencyStore.h"
@interface KTDataLoader ()
{
    NSURLSession *session;
    NSURLSessionConfiguration *sessionConfiguration;
}
@end

@implementation KTDataLoader
-(void)setUpDataLoader{
    sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
}

-(void)grabRateData{
    NSString *api = [NSString stringWithFormat:@"http://openexchangerates.org/api/latest.json?app_id=22b73fef34ef4082b0c93441e7205e0a"];
    NSURL *url = [NSURL URLWithString:api];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSDictionary *rates = jsonData[@"rates"];
                for (id key in rates) {
                    Currency *updatedCurrency = [[KTCurrencyStore sharedStore]updateCurrency];
                    updatedCurrency.name = key;
                    updatedCurrency.value = [rates objectForKey:key];
                }
            }else{
                NSLog(@"bad response");
            }
        }else{
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

@end
