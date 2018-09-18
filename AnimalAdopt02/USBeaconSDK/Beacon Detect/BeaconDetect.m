//
//  BeaconDetect.m
//  iBeacons Demo
//
//  Created by wezger on 2014/5/20.
//  Copyright (c) 2014年 Mobient. All rights reserved.
//

#import "BeaconDetect.h"


@interface BeaconDetect ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (retain,nonatomic) NSMutableDictionary * beaconDic;



@end

@implementation BeaconDetect

+ (BeaconDetect *)detectBeaconWithUUID:(NSString*)uuid
{
    BeaconDetect * object = [[BeaconDetect alloc] initWithUUID:uuid];
    return object;
}

-(id)initWithUUID:(NSString*)uuid{
    
    self = [super init];
    
    if (self) {
        
        _targetUUIDs = [NSMutableArray arrayWithCapacity:5];
        
        [_targetUUIDs addObject:uuid];
        
        self.powerRegion = nil;
        
        self.powerUUID = @"";
        
        //[self startSearching];
    }
    return self;
    
}

+ (BeaconDetect *)detectBeaconWithUUIDs:(NSArray*)uuids
{
    BeaconDetect * object = [[BeaconDetect alloc] initWithUUIDs:uuids];
    return object;
}

-(id)initWithUUIDs:(NSArray*)uuids{
    
    self = [super init];
    
    if (self) {
        
        _targetUUIDs = [NSMutableArray arrayWithCapacity:5];
        
        [_targetUUIDs addObjectsFromArray:uuids];
        
        self.powerRegion = nil;
        
        self.powerUUID = @"";
        
        //[self startSearching];
    }
    return self;
}

/************
 
 ************/
-(void)setUUIDForDetectPowerVoltage:(NSString *)aPowerUUID
{
    if(![aPowerUUID isEqualToString:@""]){
        
        self.powerUUID = aPowerUUID;
    }
}

-(void)startSearching
{
    NSLog(@"startSearching");
    //init
    _beaconDic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    //beacon
    _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //NSLog(@"start searching %@",_targetUUIDs);
    
    int count = 1;
    
    for ( NSString * uuid in _targetUUIDs ) {
        //NSLog(@"go %@",uuid);
        
        NSUUID * nsuuid = [[NSUUID alloc] initWithUUIDString:uuid];
        
        CLBeaconRegion * beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nsuuid identifier:[NSString stringWithFormat:@"region%d",count]];
        
        [_locationManager startMonitoringForRegion:beaconRegion];
        
        count ++;
    }
    
    //set powerUUID to start monitor power advertise
    if(![self.powerUUID isEqualToString:@""]){
        
        NSUUID * puuid = [[NSUUID alloc] initWithUUIDString:self.powerUUID];
        
        self.powerRegion = [[CLBeaconRegion alloc] initWithProximityUUID:puuid identifier:@"power"];
        
        [_locationManager startMonitoringForRegion:self.powerRegion];
    }
}



#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"didStartMonitoringForRegion %@",region);
    
    CLBeaconRegion * beaconRegion  = (CLBeaconRegion * )region;
    
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count == 0)
        return;
    
    //NSLog(@"didRangeBeacons %@, %i in region %@, powerRegion %@",beacons, beacons.count, region, self.powerRegion);
    
    if([region isEqual:self.powerRegion]){ //if this is the power beacon data
        
        for(int i = 0; i < beacons.count; i++){
            
            CLBeacon *aBeacon = (CLBeacon *)[beacons objectAtIndex:i];
            
            uint32_t mjor = [aBeacon.major unsignedIntValue];
            
            uint32_t mnor = [aBeacon.minor unsignedIntValue];

            NSString *powerVol = [NSString stringWithFormat:@"%x.%x", mnor%4096%256/10 ,(mnor%4096)%256%10];
            
            NSString *beacon_mac = [NSString stringWithFormat:@"%x:%x%x:%x%x", mjor/4096, (mjor%4096)/256, (mjor%4096)%256/16, (mjor%4096)%256%16, mnor/4096];
            
            //NSLog(@"major %x, minor %x, %x:%x%x:%x%x, power %@", mjor, mnor, mjor/4096, (mjor%4096)/256, (mjor%4096)%256/16, (mjor%4096)%256%16, mnor/4096, powerVol);
            
            if([self.delegate respondsToSelector:@selector(didReceivedPowerVoltage:fromBeacon:)])
            {
                [self.delegate didReceivedPowerVoltage:[powerVol floatValue] fromBeacon:beacon_mac];
            }
        }
        
        NSLog(@"didRangeBeacons Power %@",beacons);

        
    } else { //normal beacon data
        [_beaconDic setObject:beacons forKey:region.proximityUUID.UUIDString];
        
        [self callBackToUpdateBeaconList];
        
        NSLog(@"didRangeBeacons Region %@",beacons);
    }
    

    
}

#pragma mark CallBack
-(void)callBackToUpdateBeaconList
{
    NSMutableArray * beaconsArray = [NSMutableArray arrayWithCapacity:5];
    
    for ( NSString * key in _beaconDic.allKeys ) {
        
        NSArray * beaconsFromSpecficUUID = _beaconDic[key];
        
        [beaconsArray addObjectsFromArray:beaconsFromSpecficUUID];
    }
    
    _beaconList = (NSArray *)beaconsArray;
    //NSLog(@"%@",_beaconList);
    
    if([self.delegate respondsToSelector:@selector(beaconListChangeTo:)])
    {
        [self.delegate beaconListChangeTo:_beaconList];
    }

    if([self.delegate respondsToSelector:@selector(nearestBeaconChangeTo:)])
    {
        NSArray * sorted = [self beaconsSortedByRSSI:_beaconList];
        
        if (sorted.count == 0) {
            
        }else{
            
            CLBeacon * nearist = sorted[0];
            
            if (_nearistBeacon == nil) {
                
                _nearistBeacon = nearist;
                
                [self.delegate nearestBeaconChangeTo:nearist];
                
            }else{
                if ([self beacon:_nearistBeacon isEqualToBeacon:nearist]) {
                    
                    
                   
                }else{
                    
                    _nearistBeacon = nearist;
                    
                    [self.delegate nearestBeaconChangeTo:nearist];
                }
            }

        }
    }
    
}

#pragma mark EASY FILTER - beaconsSortedByMajorMinor


-(NSArray*)beaconsSortedByMajorMinor:(NSArray*)original
{
    NSMutableDictionary * beaconDicWithSortingKey = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int count = 1;
    
    
    for (int j = 0; j < original.count ; j++) {
        
        if ([original[j] isKindOfClass:[CLBeacon class]]) {
            
            CLBeacon * beacon = original[j];
            
            NSString * extendedMajor = [self string:[NSString stringWithFormat:@"%d",beacon.major.intValue] FilledWithZeroToLenth:5];
            
            NSString * extendedMinor = [self string:[NSString stringWithFormat:@"%d",beacon.minor.intValue] FilledWithZeroToLenth:5];
            
            NSString * sortingKey = [NSString stringWithFormat:@"%@_%@_%@_%d",beacon.proximityUUID.UUIDString,extendedMajor,extendedMinor,count];
            
            [beaconDicWithSortingKey setObject:beacon forKey:sortingKey];
            
            count ++;
            
        }else{
        
        }
    }
    
    
    if (count == 1) {
        
        return original;
        
    }else{
        
        NSArray * sortedKeys = [beaconDicWithSortingKey.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSMutableArray * arrayToReturn = [NSMutableArray arrayWithCapacity:5];
        
        for ( NSString * sortedKey in sortedKeys ) {
            
            [arrayToReturn addObject:beaconDicWithSortingKey[sortedKey]];
            
        }
        
        return arrayToReturn;
    }
    
}



#pragma mark EASY FILTER - beaconsSortedByRSSI


-(NSArray*)beaconsSortedByRSSI:(NSArray*)original
{
    NSMutableDictionary * beaconDicWithSortingKey = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int count = 1;
    
    for (int j = 0; j < original.count ; j++) {
        
        if ([original[j] isKindOfClass:[CLBeacon class]]) {
            
            CLBeacon * beacon = original[j];
            
            NSString * biasedRSSI;
            
            if (beacon.proximity == CLProximityUnknown ) {
                
                biasedRSSI = @"0";
                
            }else{
                
                biasedRSSI =  [NSString stringWithFormat:@"%d", (beacon.rssi + 1000) ];
            }
            
            NSString * sortingKey = [self string:biasedRSSI FilledWithZeroToLenth:5];
            
            [beaconDicWithSortingKey setObject:beacon forKey:sortingKey];
            
            count ++;
            
        }else{
            
        }
    }
    
    //NSLog(@"%@",beaconDicWithSortingKey.allKeys);
    //return @[@"1",@"2"];
    
    if (count == 1) {
        
        return original;
        
    }else{
        
        NSArray * sortedKeys = [beaconDicWithSortingKey.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSMutableArray * arrayToReturn = [NSMutableArray arrayWithCapacity:5];
        
        for ( NSString * sortedKey in sortedKeys ) {
            
            //[arrayToReturn addObject:beaconDicWithSortingKey[sortedKey]];
            
            [arrayToReturn insertObject:beaconDicWithSortingKey[sortedKey] atIndex:0];
        }
        return arrayToReturn;
    }
}

#pragma mark EASY FILTER - beaconsNoUnknownProximity


-(NSArray*)beaconsNoUnknownProximity:(NSArray*)original
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
    
    for (int j = 0; j < original.count ; j++) {
        
        if ([original[j] isKindOfClass:[CLBeacon class]]) {
            
            CLBeacon * beacon = original[j];
            
            if (beacon.proximity == CLProximityUnknown ) {
            
                
            }else{
                
                [array addObject:beacon];
                
            }
        }else{
            
        }
    }
    
    return array;
    
}


#pragma mark helper

-(NSString *)string:(NSString*)originalString  FilledWithZeroToLenth:(int)length
{
    NSMutableString * string = [NSMutableString stringWithCapacity:5];
    
    if (originalString.length < length) {
        
        for (int i = 0 ; i < (length - originalString.length ); i++ ) {
            
            [string appendString:@"0"];
        }
        
        [string appendString:originalString];
        
    }else{
        
        [string appendString:[originalString substringWithRange:NSMakeRange(0, length)]];
    }
    
    return string;
}


-(BOOL)beacon:(CLBeacon*)beacon1 isEqualToBeacon:(CLBeacon*)beacon2
{
    //NSLog(@"compare \n %@ %@ \n %@ %@ \n %@ %@",beacon1.major,beacon2.major ,beacon1.minor,beacon2.minor,beacon1.proximityUUID.UUIDString,beacon2.proximityUUID.UUIDString);
    
    if(beacon1.major == beacon2.major && beacon1.minor == beacon2.minor && [beacon1.proximityUUID.UUIDString isEqualToString:beacon2.proximityUUID.UUIDString]){
        
        //NSLog(@"YES");
        return YES;
        
    }else{
        
        return NO;
    }
}




@end
