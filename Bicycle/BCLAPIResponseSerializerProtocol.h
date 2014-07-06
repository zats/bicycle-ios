//
//  BCLAPIResponseSerializerProtocol.h
//  Bicycle
//
//  Created by Sasha Zats on 7/5/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^BCLAPIResponseSerializerCondition)(NSHTTPURLResponse *response, id data);

@protocol BCLAPIResponseSerializerProtocol <NSObject>

- (void)registerClass:(Class)resopnseModelClass
 withConditionalBlock:(BCLAPIResponseSerializerCondition)block;

@end
