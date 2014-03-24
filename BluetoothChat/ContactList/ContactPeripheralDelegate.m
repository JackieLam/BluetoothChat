//
//  ContactPeripheralDelegate.m
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "ContactPeripheralDelegate.h"

@interface ContactPeripheralDelegate()

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@end

@implementation ContactPeripheralDelegate

- (id)initWithPeripheralManager:(CBPeripheralManager *)aPeripheralManager
{
    self = [super init];
    if (self) {
        self.peripheralManager = aPeripheralManager;
        
    }
    return self
}

#pragma mark - Peripheral Manager Delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID1] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
        
        CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID1] primary:YES];
        
        transferService.characteristics = @[_transferCharacteristic];
        
        [_peripheralManager addService:transferService];
    }
}


@end
