//
//  busInfo.h
//  apitestv2
//
//  Created by TAMMELA Roosa on 2/18/15.
//  Copyright (c) 2015 TAMMELA Roosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface busInfo : NSObject
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)getServices;
- (void)getStops;
- (void)makeServiceMap:(NSArray *)busStopMap;
- (NSArray*)makeBusStopMap;
@end
