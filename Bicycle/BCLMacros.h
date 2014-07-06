//
//  BCLMacros.h
//  Bicycle
//
//  Created by Sasha Zats on 7/6/14.
//  Copyright (c) 2014 Sash Zats. All rights reserved.
//

#ifdef DEBUG
    // https://gist.github.com/kyleve/8213806
    /**
     Provides the ability to verify key paths at compile time.
     
     If "keyPath" does not exist, a compile-time error will be generated.
     
     Example:
     // Verifies "isFinished" exists on "operation".
     NSString *key = SQKeyPath(operation, isFinished);
     
     // Verifies "isFinished" exists on self.
     NSString *key = SQSelfKeyPath(isFinished);
     
     // Verifies "isFinished" exists on instances of NSOperation.
     NSString *key = SQTypedKeyPath(NSOperation, isFinished);
     */
    #define SQKeyPath(object, keyPath) ({ if (NO) { (void)((object).keyPath); } @#keyPath; })
#else
    #define SQKeyPath(object, keyPath) ({ @#keyPath; })
#endif

#define SQSelfKeyPath(keyPath) SQKeyPath(self, keyPath)
#define SQTypedKeyPath(ObjectClass, keyPath) SQKeyPath(((ObjectClass *)nil), keyPath)
#define SQProtocolKeyPath(Protocol, keyPath) SQKeyPath(((id <Protocol>)nil), keyPath)
