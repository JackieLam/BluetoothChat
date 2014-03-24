
#import "DV.h"
#import "Node.h"
@implementation DV
@synthesize myName;
-(id)initWithName:(NSString *) name{
    self=[super init];
    if(self){
        Table=[[NSMutableDictionary alloc] initWithCapacity:15];
        NextHop=[[NSMutableDictionary alloc] initWithCapacity:15];
        myName=name;
    }
    return self;
}
-(void)createTable:(NSMutableDictionary *)aDictionary{
    Node *temp;
    for(id key in aDictionary){
        temp=[aDictionary objectForKey:key];
        [Table setObject:temp forKey:[temp NodeName]];
        [NextHop setObject:[temp NodeName] forKey:[temp NodeName]];
    }
}
-(void)updateTable:(NSMutableDictionary *)aDictionary From:(NSString *)neighbor{
    NSMutableDictionary *shareTable=[[NSMutableDictionary alloc] init];
    Node *myNeighbor=[Table objectForKey:neighbor];
    int costToNeighbor=myNeighbor.Cost;
    //往本节点的路由表加入新的节点
    for(id key in aDictionary){
        if([Table objectForKey:key]==nil){
            Node *temp=[aDictionary objectForKey:key];
            if ([[temp NodeName] isEqualToString:myName]) {
                continue;
            }
            temp.Cost+=costToNeighbor;
            [Table setObject:temp forKey:[temp NodeName]];
            [NextHop setObject:neighbor forKey:[temp NodeName]];
        }else{
            [shareTable setObject:[aDictionary objectForKey:key] forKey:key];
        }
    }
    for(id key in shareTable){
        if ([key isEqualToString:neighbor]) {
            continue;
        }
        int costFromNeighbor=[[aDictionary objectForKey:key]Cost];
        Node *temp=[Table objectForKey:key];
        int cost=[temp Cost];
        if((costToNeighbor+costFromNeighbor)<cost){
            temp.Cost=costToNeighbor+costFromNeighbor;
            [NextHop setObject:neighbor forKey:[temp NodeName]];
        }
    }
    
}

-(NSString *)selectNextHopTo:(NSString *)destination{
    return [NextHop objectForKey:destination];
}

-(void)cleanOfflinePoints:(NSArray *)aOfflinePointArray{
    for(id key in aOfflinePointArray){
        [Table removeObjectForKey:key];
        [NextHop removeObjectForKey:key];
    }
}

-(NSArray *)getContact{
    NSMutableArray *contact=[[NSMutableArray alloc] init];
    [contact setValuesForKeysWithDictionary:Table];
    return (NSArray *)contact;
}

-(NSMutableDictionary *)Table{
    return Table;
}

@end
