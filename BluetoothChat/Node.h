

#import <Foundation/Foundation.h>

@interface Node : NSObject{
    NSString *NodeName;
    int Cost;
}

@property(readonly)NSString *NodeName;
@property int Cost;
-(id)initWithName:(NSString *)name andCost:(int)cost;

@end