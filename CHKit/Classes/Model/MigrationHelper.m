//
//  MigrationHelper.m
//  chihuahua
//
//  Created by wbitos on 2019/3/1.
//  Copyright © 2019 wbitos. All rights reserved.
//

#import "MigrationHelper.h"
#import <objc/runtime.h>
#import "BaseModel.h"

@implementation MigrationHelper
+ (NSArray <Class> *)models {
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    NSMutableArray *models = [NSMutableArray array];
    
    if (numClasses > 0 ) {
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i ++) {
            Class cls = classes[i];
            if (class_respondsToSelector(cls, @selector(isKindOfClass:))) {
                if ([cls isKindOfClass:[BaseModel class]]) {
                    [models addObject:cls];
                }
            }
        }
        free(classes);
    }
    return models;
}
@end
