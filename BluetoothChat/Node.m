

#import "Node.h"

@implementation Node
@synthesize NodeName;
@synthesize Cost;
-(id)initWithName:(NSString *)name andCost:(int)cost{
    self=[super init];
    if (self) {
        NodeName=name;
        Cost=cost;
    }
    return self;
}


@end
