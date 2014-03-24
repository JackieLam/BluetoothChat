//
//  ContactCentralDelegate.m
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "ContactCentralDelegate.h"
#import "SERVICE.h"
#import "DV.h"

@interface ContactCentralDelegate()

@property (nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation ContactCentralDelegate

- (id)initWithCentralManager:(CBCentralManager *)aCentralManager
{
    self = [super init];
    if (self) {
        self.centralManager = aCentralManager;
    }
    return self;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UPDATE_DV_TABLE]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"CBCentralManager is On and scanning devices");
    }
}



@end
