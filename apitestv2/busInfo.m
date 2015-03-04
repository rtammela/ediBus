//
//  busInfo.m
//  apitestv2
//
//  Created by TAMMELA Roosa on 2/18/15.
//  Copyright (c) 2015 TAMMELA Roosa. All rights reserved.
//

#import "busInfo.h"
//#import "SBJson4.h"

@interface busInfo ()

//@property (strong) SBJson4Writer *writer;

@end

@implementation busInfo

// Get service information for EVERY bus:
// {last_updated, services: [ {name, destination, service_type, routes:[{destination, points:[{lat,long},...],
//                              stops:[stop_id,...,...,{...}]}]}]}
-(void)getServices
{
    
    NSString *urlString = [NSString stringWithFormat:@"https://tfe-opendata.com/api/v1/services/"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSLog(@"%@",request);
    [request setHTTPMethod: @"GET"];
    [request addValue: @"￼0c627af5849e23b0b030bc7352550884" forHTTPHeaderField: @"API-Key"] ;
    NSLog(@"%@",urlString);
    NSLog(@"%@",[request allHTTPHeaderFields]);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate: self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    printf("connection method called");
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSDictionary *results = [jsonString ];
    NSLog(@"%@",jsonString);
}

// Get stop information for ALL stops:
// {last_updated, stops: [stop_id,atco_code,name,identifier,locality,orientation,direction,lat,long,destinations:[],services:[]]}
-(void)getStops
{
    
    NSString *urlString = [NSString stringWithFormat:@"https://tfe-opendata.com/api/v1/stops/"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSLog(@"%@",request);
    [request setHTTPMethod: @"GET"];
    [request addValue: @"￼0c627af5849e23b0b030bc7352550884" forHTTPHeaderField: @"API-Key"] ;
    NSLog(@"%@",urlString);
    NSLog(@"%@",[request allHTTPHeaderFields]);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate: self];
}


//-(NSArray *)makeServiceMap
-(void)makeServiceMap:(NSMutableArray *)busStopMap;
{
    // by bus numbers: [ bus , [ direction , [ stopID, stopname, lat, long] ] , [ direction , [ stopID, stopname, lat, long ] ] ]
    NSMutableArray *serviceMap = [NSMutableArray array];
    
    // Fetch data from file
    NSString *servicesPath = [[NSBundle mainBundle] pathForResource:@"services" ofType:@"json"];
    NSString *servicesJSON = [[NSString alloc] initWithContentsOfFile:servicesPath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *servicesContent = [NSJSONSerialization JSONObjectWithData:[servicesJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSArray *serviceNumbers = [servicesContent valueForKeyPath:@"services"];
    for (NSDictionary *service in serviceNumbers){
        if (service != nil){
            NSMutableArray *serviceInfo = [NSMutableArray array];
            [serviceInfo addObject:[service objectForKey:@"name"]]; // [ bus
            
            NSArray *routes = (NSArray *) [service objectForKey:@"routes"];
            // Retrieves stop IDs of this service (for BOTH directions separately!!)
            for (NSDictionary *r in routes){
                NSMutableArray *direction = [NSMutableArray array];
                [direction addObject:[r valueForKey:@"destination"]]; // [ bus , [ direction ,
                
                NSArray *directionStops = (NSArray *) [r objectForKey:@"stops"];
                for (NSObject *s in directionStops){
                    for (id busStops in busStopMap){
                        if ([s isEqual:busStops[0]]){
                            // Corresponding bus stop has been found
                            //NSLog(@"%@",busStops[1]);
                            NSMutableArray *directionDetails = [NSMutableArray array];
                            [directionDetails addObject:busStops[0]]; // [bus,[direction,[stopID,
                            [directionDetails addObject:busStops[1][0]]; // stopname,
                            [directionDetails addObject:busStops[1][1]]; // lat,
                            [directionDetails addObject:busStops[1][2]]; // long]
                            [direction addObject:directionDetails];
                        }
                    }
                    [serviceInfo addObject:direction];
                }
                
                
            }
            
            //NSArray *stopIDs = [routes valueForKeyPath:@"stops"];

            [serviceMap addObject:serviceInfo];
        }
        
    }
    //NSLog(@"%@",serviceMap[0][2]);
    //return serviceMap;
}
-(NSMutableArray *)makeBusStopMap
{
    // by bus stops: [ stop_id: stopname , lat, long, direction, [ services ] ]
    NSMutableArray *busStopMap= [NSMutableArray array];
    
    // Fetch data from file
    NSString *stopsPath = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"json"];
    NSString *stopsJSON = [[NSString alloc] initWithContentsOfFile:stopsPath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *stopsContent = [NSJSONSerialization JSONObjectWithData:[stopsJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSArray *stops = [stopsContent valueForKeyPath:@"stops"];
    for (NSDictionary *stop in stops){
        if (stop != nil){
            NSMutableArray *stopInfo = [NSMutableArray array];
            [stopInfo addObject:[stop objectForKey:@"name"]];
            [stopInfo addObject:[stop objectForKey:@"latitude"]];
            [stopInfo addObject:[stop objectForKey:@"longitude"]];
            [stopInfo addObject:[stop objectForKey:@"direction"]];
            
            NSMutableArray *services = [stop objectForKey:@"services"];
            [stopInfo addObject:services];
            
            NSArray *indexedStops = @[[stop objectForKey:@"stop_id"],stopInfo];
            //NSDictionary *indexedStops = @{@[[stop objectForKey:@"stop_id"]]:stopInfo};
            [busStopMap addObject:indexedStops];
        }
    }
    return busStopMap;
}
@end

