//
//  CBCentralManagerViewController.m
//  CBTutorial
//
//  Created by Orlando Pereira on 10/8/13.
//  Copyright (c) 2013 Mobiletuts. All rights reserved.
//

#import "CBCentralManagerViewController.h"

@implementation CBCentralManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //	_data = [[NSMutableData alloc] init];
	_discoveredPeripherals = [[NSMutableArray alloc] init];
	_peripheralDatas = [[NSMutableDictionary alloc] init];
	_datasource = [[NSMutableArray alloc] init];
	_numberOfRow = 0;
	_textview.editable = YES;
	
	_peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[_centralManager stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
	
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        //        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
		[_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning started");
    }
}

#pragma mark- central

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	
    //    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    //
    //    if (_discoveredPeripheral != peripheral) {
    //        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
    //        _discoveredPeripheral = peripheral;
	
	for (CBPeripheral* per in _discoveredPeripherals) {
		if ([peripheral.identifier isEqual:per.identifier]) {
			return;
		}
	}
	[_discoveredPeripherals addObject:peripheral];
    // And connect
    NSLog(@"Connecting to peripheral %@", peripheral);
    [_centralManager connectPeripheral:peripheral options:nil];
    //	if (_discoveredPeripherals.count >= 2) {
    //		[_centralManager stopScan];
    //	}
    //    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect");
    [self cleanup:peripheral];
}

- (void)cleanup:(CBPeripheral*) per {
	[_discoveredPeripherals removeObject:per];
    if (per.services != nil) {
        for (CBService *service in per.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    //						if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                    if (characteristic.isNotifying) {
                        [per setNotifyValue:NO forCharacteristic:characteristic];
                        return;
                    }
                    //						}
                }
            }
        }
		
		
		// See if we are subscribed to a characteristic on the peripheral
		
		
		[_centralManager cancelPeripheralConnection:per];
	}
	
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected");
	
    //    [_centralManager stopScan];
    //    NSLog(@"Scanning stopped");
	NSMutableData* data = [[NSMutableData alloc] init];
    [data setLength:0];
	[_peripheralDatas setObject:data forKey:peripheral.identifier];
    peripheral.delegate = self;
	
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup:peripheral];
        return;
    }
	
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup:peripheral];
        return;
    }
	
    for (CBCharacteristic *characteristic in service.characteristics) {
        //        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        //        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
	
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
	
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
		
        //        [_textview setText:[[NSString alloc] initWithData:[self.peripheralDatas objectForKey:peripheral.identifier] encoding:NSUTF8StringEncoding]];
        
		self.numberOfRow += 1;
		NSString *message = [[NSString alloc] initWithData:[self.peripheralDatas objectForKey:peripheral.identifier] encoding:NSUTF8StringEncoding];
		NSString *temp = [NSString stringWithFormat:@"Message from: %@ is: %@",[peripheral.identifier UUIDString], message];
		[_datasource addObject:temp];
		NSArray *insert = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.numberOfRow-1 inSection:0], nil];
		[_tableview insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationBottom];
		[(NSMutableData *)[self.peripheralDatas objectForKey:peripheral.identifier] setLength:0];
		return;
        //        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        //
        //        [_centralManager cancelPeripheralConnection:peripheral];
    }
	
    [[self.peripheralDatas objectForKey:peripheral.identifier] appendData:characteristic.value];
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	
    //    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
    //        return;
    //    }
	
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //    _discoveredPeripheral = nil;
	[_discoveredPeripherals removeObject:peripheral];
	
    //    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
	
    if (central.state == CBCentralManagerStatePoweredOn) {
        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
	}
}

#pragma mark - peripheral

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
		return;
    }
	
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
		
        CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] primary:YES];
		
        transferService.characteristics = @[_transferCharacteristic];
		
        [_peripheralManager addService:transferService];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
	
    NSLog(@"Be subscribed!");
}

- (void)sendData {
	
    static BOOL sendingEOM = NO;
	
    // end of message?
    if (sendingEOM) {
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
		
        if (didSend) {
            // It did, so mark it as sent
            sendingEOM = NO;
        }
        // didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
	
    // We're sending data
    // Is there any left to send?
    if (self.sendDataIndex >= self.dataToSend.length) {
        // No data left.  Do nothing
        return;
    }
	
    // There's data left, so send until the callback fails, or we're done.
    BOOL didSend = YES;
	
    while (didSend) {
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
		
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
		
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
		
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
		
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
		
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
		
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
		
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
			
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
			
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
			
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
			
            return;
        }
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    [self sendData];
}



#pragma -mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return _numberOfRow;
	}
	return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
		cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		cell.textLabel.numberOfLines = 0;
	}
	
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:[_datasource objectAtIndex:indexPath.row]];
	
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (IBAction)btnSendClick:(id)sender
{
	_dataToSend = [_textview.text dataUsingEncoding:NSUTF8StringEncoding];
	
    _sendDataIndex = 0;
	
    [self sendData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[self view] endEditing:YES];
}

@end
