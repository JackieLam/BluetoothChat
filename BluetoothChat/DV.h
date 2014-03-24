

#import <Foundation/Foundation.h>

@interface DV : NSObject{
    NSMutableDictionary *Table;
    NSMutableDictionary *NextHop;
    NSString *myName;
}
@property NSString *myName;

-(id)initWithName:(NSString *)name;
-(void)createTable:(NSMutableDictionary *)aDictionary;
-(void)updateTable:(NSMutableDictionary *)aDictionary From:(NSString *)neighbor;
-(NSString *)selectNextHopTo:(NSString *)destination;
-(void)cleanOfflinePoints:(NSArray *)aOfflinePointArray;
-(NSMutableDictionary *)Table;
-(NSArray *)getContact;

@end
