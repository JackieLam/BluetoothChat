//
//  ContactPeripheralDelegate.h
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ContactPeripheralDelegate : NSObject< CBPeripheralManagerDelegate>

- (id)initWithPeripheralManager:(CBPeripheralManager *)aPeripheralManager;

@end
