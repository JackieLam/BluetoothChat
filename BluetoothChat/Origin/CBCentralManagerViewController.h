//
//  CBCentralManagerViewController.h
//  CBTutorial
//
//  Created by Orlando Pereira on 10/8/13.
//  Copyright (c) 2013 Mobiletuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "SERVICE.h"

@interface CBCentralManagerViewController : UIViewController< CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate,CBPeripheralManagerDelegate, UITextViewDelegate>


@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;

@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (assign, nonatomic) NSInteger numberOfRow;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *discoveredPeripherals;
//@property (strong, nonatomic) NSMutableData *data;

@property (strong, nonatomic) NSMutableDictionary *peripheralDatas;

-(IBAction)btnSendClick:(id)sender;

@end
