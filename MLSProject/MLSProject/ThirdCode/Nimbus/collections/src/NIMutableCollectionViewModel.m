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

#import "NIMutableCollectionViewModel.h"

#import "NICollectionViewModel.h"
#import "NICollectionViewModel+Private.h"
#import "NIMutableCollectionViewModel+Private.h"
#import "NimbusCore.h"


#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "Nimbus requires ARC support."
#endif


@implementation NIMutableCollectionViewModel
@dynamic delegate;

#pragma mark - Public


- (NSArray *)addObject:(id)object {
  NICollectionViewModelSection* section = self.sections.count == 0 ? [self _appendSection] : self.sections.lastObject;
  [section.mutableRows addObject:object];
  return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                     inSection:self.sections.count - 1]];
}

- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex {
  NIDASSERT(sectionIndex >= 0 && sectionIndex < self.sections.count);
  NICollectionViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
  [section.mutableRows addObject:object];
  return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                     inSection:sectionIndex]];
}

- (NSArray *)addObjectsFromArray:(NSArray *)array {
  NSMutableArray* indices = [NSMutableArray array];
  for (id object in array) {
    [indices addObject:[[self addObject:object] objectAtIndex:0]];
  }
  return indices;
}
- (NSArray *)addObjectsFromArray:(NSArray *)array toSection:(NSUInteger)section
{
        NSMutableArray* indices = [NSMutableArray array];
        for (id object in array) {
                [indices addObject:[[self addObject:object toSection:section] objectAtIndex:0]];
        }
        return indices;
}

- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)sectionIndex {
  NIDASSERT(sectionIndex >= 0 && sectionIndex < self.sections.count);
  NICollectionViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
  [section.mutableRows insertObject:object atIndex:row];
  return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
}

- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
  NIDASSERT(indexPath.section < (NSInteger)self.sections.count);
  if (indexPath.section >= (NSInteger)self.sections.count) {
    return nil;
  }
  NICollectionViewModelSection* section = [self.sections objectAtIndex:indexPath.section];
  NIDASSERT(indexPath.row < (NSInteger)section.mutableRows.count);
  if (indexPath.row >= (NSInteger)section.mutableRows.count) {
    return nil;
  }
  [section.mutableRows removeObjectAtIndex:indexPath.row];
  return [NSArray arrayWithObject:indexPath];
}
- (NSArray *)removeObjectAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths inSection:(NSUInteger)sectionIndex
{
        NIDASSERT(sectionIndex < (NSInteger)self.sections.count);
        if (sectionIndex >= (NSInteger)self.sections.count) {
                return nil;
        }
        NICollectionViewModelSection* section = [self.sections objectAtIndex:sectionIndex];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NIDASSERT(obj.row < (NSInteger)section.mutableRows.count);
                if (obj.row < (NSInteger)section.mutableRows.count)
                {
                        [indexSet addIndex:obj.row];
                }
        }];
        [section.mutableRows removeObjectsAtIndexes:indexSet];
        return indexPaths;
}
- (NSArray *)removeObjectAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths
{
        NSMutableDictionary <NSNumber*,NSMutableArray <NSIndexPath *>*>* removeSectionDict = [NSMutableDictionary dictionaryWithCapacity:indexPaths.count];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NIDASSERT(obj.section < (NSInteger)self.sections.count);
                if (obj.section < (NSInteger)self.sections.count)
                {
                        NSMutableArray *removeIndex = [removeSectionDict objectForKey:@(obj.section)];
                        if (removeIndex) {
                                [removeIndex addObject:obj];
                        } else {
                                [removeSectionDict setObject:[NSMutableArray arrayWithObject:obj] forKey:@(obj.section)];
                        }
                }
        }];
        [removeSectionDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<NSIndexPath *> * _Nonnull obj, BOOL * _Nonnull stop) {
                [self removeObjectAtIndexPaths:obj inSection:key.integerValue];
        }];
        return indexPaths;
}
- (NSInteger)countInSection:(NSUInteger)sectionIndex
{
        NIDASSERT(sectionIndex < (NSInteger)self.sections.count);
        if (sectionIndex >= (NSInteger)self.sections.count) {
                return 0;
        }
        NICollectionViewModelSection* section = [self.sections objectAtIndex:sectionIndex];
        return section.rows.count;
}
- (NSInteger)sectionCount
{
        return self.sections.count;
}
- (NSArray *)objectsInSection:(NSUInteger)sectionIndex
{
        NIDASSERT(sectionIndex < (NSInteger)self.sections.count);
        if (sectionIndex >= (NSInteger)self.sections.count) {
                return nil;
        }
        NICollectionViewModelSection* section = [self.sections objectAtIndex:sectionIndex];
        return section.mutableRows;
}
- (NSArray *)removeObjectsInSection:(NSInteger)sec
{
        NIDASSERT(sec < (NSInteger)self.sections.count);
        if (sec >= (NSInteger)self.sections.count) {
                return nil;
        }
        NICollectionViewModelSection* section = [self.sections objectAtIndex:sec];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [section.mutableRows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:[NSIndexPath indexPathForItem:idx inSection:sec]];
        }];
        [section.mutableRows removeAllObjects];
        return array;
}
- (void)removeAll
{
        [self.sections removeAllObjects];
}
- (NSIndexSet *)addSectionWithTitle:(NSString *)title {
  NICollectionViewModelSection* section = [self _appendSection];
  section.headerTitle = title;
  return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}

- (NSIndexSet *)insertSectionWithTitle:(NSString *)title atIndex:(NSUInteger)index {
  NICollectionViewModelSection* section = [self _insertSectionAtIndex:index];
  section.headerTitle = title;
  return [NSIndexSet indexSetWithIndex:index];
}

- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)index {
  NIDASSERT(index >= 0 && index < self.sections.count);
  [self.sections removeObjectAtIndex:index];
  return [NSIndexSet indexSetWithIndex:index];
}

#pragma mark - Private


- (NICollectionViewModelSection *)_appendSection {
  if (nil == self.sections) {
    self.sections = [NSMutableArray array];
  }
  NICollectionViewModelSection* section = nil;
  section = [[NICollectionViewModelSection alloc] init];
  section.rows = [NSMutableArray array];
  [self.sections addObject:section];
  return section;
}

- (NICollectionViewModelSection *)_insertSectionAtIndex:(NSUInteger)index {
  if (nil == self.sections) {
    self.sections = [NSMutableArray array];
  }
  NICollectionViewModelSection* section = nil;
  section = [[NICollectionViewModelSection alloc] init];
  section.rows = [NSMutableArray array];
  NIDASSERT(index >= 0 && index <= self.sections.count);
  [self.sections insertObject:section atIndex:index];
  return section;
}

- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
  if ([sectionsArray isKindOfClass:[NSMutableArray class]]) {
    self.sections = (NSMutableArray *)sectionsArray;
  } else {
    self.sections = [sectionsArray mutableCopy];
  }
}

- (void)updateSectionIndex {
        [self _compileSectionIndex];
}
- (NSString *)headerTitleForSection:(NSUInteger)section
{
        NIDASSERT(index >= 0 && section < self.sections.count);
        return [(NICollectionViewModelSection *)[self.sections objectAtIndex:section] headerTitle];
}
- (NSString *)footerTitleForSection:(NSUInteger)section
{
        NIDASSERT(index >= 0 && section < self.sections.count);
        return [(NICollectionViewModelSection *)[self.sections objectAtIndex:section] footerTitle];
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
        if ([self.delegate respondsToSelector:@selector(collectionViewModel:canMoveObject:atIndexPath:incollectionView:)]) {
                id object = [self objectAtIndexPath:indexPath];
                return [self.delegate collectionViewModel:self canMoveObject:object atIndexPath:indexPath incollectionView:collectionView];
        } else {
                return NO;
        }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
        if ([self.delegate respondsToSelector:@selector(collectionViewModel:moveObject:fromIndexPath:toIndexPath:incollectionView:)]) {
                id object = [self objectAtIndexPath:sourceIndexPath];
                [self.delegate collectionViewModel:self moveObject:object fromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath incollectionView:collectionView];
        }
}

/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView
{
        return self.sectionIndexTitles;
}

/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
/// Return an index path with a single index to indicate an entire section, instead of a specific item.
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
        NSString* letter = [title substringToIndex:1];
        NSNumber* sectionIndex = [self.sectionPrefixToSectionIndex objectForKey:letter];
        NSInteger section = (nil != sectionIndex) ? [sectionIndex intValue] : -1;
        return [NSIndexPath indexPathForItem:0 inSection:section];
}
@end


@implementation NICollectionViewModelSection (Mutable)


- (NSMutableArray *)mutableRows {
  NIDASSERT([self.rows isKindOfClass:[NSMutableArray class]] || nil == self.rows);

  self.rows = nil == self.rows ? [NSMutableArray array] : self.rows;
  return (NSMutableArray *)self.rows;
}

@end
