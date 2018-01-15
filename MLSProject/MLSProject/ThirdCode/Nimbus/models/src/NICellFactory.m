//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NICellFactory.h"
#import "NICellFactory+Private.h"

#import "NimbusCore.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "Nimbus requires ARC support."
#endif

@interface NICellFactory()
@property (nonatomic, strong) NSMutableDictionary* objectToCellMap;
@property(nonatomic, strong) NSMutableDictionary *cellClassIdentifierMap;
@end


@implementation NICellFactory



- (id)init {
        if ((self = [super init])) {
                _objectToCellMap = [[NSMutableDictionary alloc] init];
                _cellClassIdentifierMap = [[NSMutableDictionary alloc] init];
        }
        return self;
}
- (UITableViewCell *)cellWithClass:(Class)cellClass
                         tableView:(UITableView *)tableView
                         indexPath:(NSIndexPath *)indexPath
                            object:(id)object {
        UITableViewCell* cell = nil;
        
        NSString* identifier = [self identifierForObj:object tableView:tableView];
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        // Allow the cell to configure itself with the object's information.
        if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
                [(id<NICell>)cell shouldUpdateCellWithObject:object];
        } else if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:atIndexPath:)]) {
                [(id<NICell>)cell shouldUpdateCellWithObject:object atIndexPath:indexPath];
        }
        
        return cell;
}
- (NSString *)identifierForObj:(id)object tableView:(UITableView *)tableView
{
        NSString *identifier = [self.cellClassIdentifierMap objectForKey:NSStringFromClass([object cellClass])];
        if (identifier)
        {
                return identifier;
        }
        identifier = NSStringFromClass([object cellClass]);
        // 快速创建的对象,拼接class
        if ([object conformsToProtocol:@protocol(NINibCellObject)])
        {
                id <NINibCellObject>cellObj = object;
                identifier = [identifier stringByAppendingString:NSStringFromClass([cellObj cellClass])];
                [tableView registerNib:[cellObj cellNib] forCellReuseIdentifier:identifier];
        }
        else if ([object conformsToProtocol:@protocol(NICellObject)]){
                id <NICellObject>cellObject = object;
                Class cellClass = [cellObject cellClass];
                if ([cellClass respondsToSelector:@selector(shouldAppendObjectClassToReuseIdentifier)]
                    && [cellClass shouldAppendObjectClassToReuseIdentifier])
                {
                        identifier = [identifier stringByAppendingFormat:@".%@", NSStringFromClass([object class])];
                }
                [tableView registerClass:cellClass forCellReuseIdentifier:identifier];
        }
        [self.cellClassIdentifierMap setObject:identifier forKey:NSStringFromClass([object cellClass])];
        return identifier;
}
- (UITableViewCell *)cellWithNib:(UINib *)cellNib
                       tableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath
                          object:(id)object {
        UITableViewCell* cell = nil;
        NSString* identifier = [self identifierForObj:object tableView:tableView];
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        // Allow the cell to configure itself with the object's information.
        if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
                [(id<NICell>)cell shouldUpdateCellWithObject:object];
        } else if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:atIndexPath:)]) {
                [(id<NICell>)cell shouldUpdateCellWithObject:object atIndexPath:indexPath];
        }
        
        return cell;
}

- (Class)cellClassFromObject:(id)object {
        if (nil == object) {
                return nil;
        }
        Class objectClass = [object class];
        Class cellClass = [self.objectToCellMap objectForKey:objectClass];
        
        BOOL hasExplicitMapping = (nil != cellClass && cellClass != [NSNull class]);
        
        if (!hasExplicitMapping && [object respondsToSelector:@selector(cellClass)]) {
                cellClass = [object cellClass];
        }
        
        if (nil == cellClass) {
                cellClass = [NIActions objectFromKeyClass:objectClass map:self.objectToCellMap];
        }
        
        return cellClass;
}

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object {
        UITableViewCell* cell = nil;
        
        Class cellClass = [self cellClassFromObject:object];
        if (nil != cellClass && [NSNull class] != cellClass) {
                cell = [self cellWithClass:cellClass tableView:tableView indexPath:indexPath object:object];
                
        } else if ([object respondsToSelector:@selector(cellNib)]) {
                UINib* nib = [object cellNib];
                cell = [self cellWithNib:nib tableView:tableView indexPath:indexPath object:object];
        }
        
        // If this assertion fires then your app is about to crash. You need to either add an explicit
        // binding in a NICellFactory object or implement the NICellObject protocol on this object and
        // return a cell class.
        NIDASSERT(nil != cell);
        
        return cell;
}

- (void)mapObjectClass:(Class)objectClass toCellClass:(Class)cellClass {
        [self.objectToCellMap setObject:cellClass forKey:(id<NSCopying>)objectClass];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(NITableViewModel *)model {
        CGFloat height = tableView.rowHeight;
        id object = [model objectAtIndexPath:indexPath];
        Class cellClass = [self cellClassFromObject:object];
        
        if ([cellClass respondsToSelector:@selector(heightForObject:identifier:atIndexPath:tableView:)]) {
                CGFloat cellHeight = [cellClass heightForObject:object
                                                     identifier:[self identifierForObj:object tableView:tableView]
                                                    atIndexPath:indexPath tableView:tableView];
                if (cellHeight > 0) {
                        height = cellHeight;
                }
        }
        return height;
}

@end



@implementation NICellObject



- (id)initWithCellClass:(Class)cellClass userInfo:(id)userInfo {
        if ((self = [super init])) {
                _cellClass = cellClass;
                _userInfo = userInfo;
        }
        return self;
}

- (id)initWithCellClass:(Class)cellClass {
        return [self initWithCellClass:cellClass userInfo:nil];
}

+ (id)objectWithCellClass:(Class)cellClass userInfo:(id)userInfo {
        return [[self alloc] initWithCellClass:cellClass userInfo:userInfo];
}

+ (id)objectWithCellClass:(Class)cellClass {
        return [[self alloc] initWithCellClass:cellClass userInfo:nil];
}

@end

@implementation NINibCellObject

// Designated initializer.
- (id)initWithCellNib:(UINib *)cellNib cellClass:(Class)cellClass userInfo:(id)userInfo
{
        if (self = [super init]) {
                _cellNib = cellNib;
                _cellClass = cellClass;
                _userInfo = userInfo;
        }
        return self;
}
- (id)initWithCellNib:(UINib *)cellNib cellClass:(Class)cellClass
{
        return [self initWithCellNib:cellNib cellClass:cellClass userInfo:nil];
}

+ (id)objectWithCellNib:(UINib *)cellNib cellClass:(Class)cellClass userInfo:(id)userInfo
{
        return [[self alloc] initWithCellNib:cellNib cellClass:cellClass userInfo:userInfo];
}
+ (id)objectWithCellNib:(UINib *)cellNib cellClass:(Class)cellClass
{
        return [[self alloc] initWithCellNib:cellNib cellClass:cellClass];
}
@end
