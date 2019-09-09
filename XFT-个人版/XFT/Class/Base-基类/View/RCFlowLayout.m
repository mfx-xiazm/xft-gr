//
//  RCFlowLayout.m
//  TextFlow
//
//  Created by 夏增明 on 2019/9/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCFlowLayout.h"

@interface RCFlowLayout ()
@property (strong, nonatomic) NSMutableArray * attrubutesArray;   //所有元素的布局信息

@end
@implementation RCFlowLayout
//Subclasses should always call super if they override.

//CollectionView会在初次布局时首先调用该方法
//CollectionView会在布局失效后、重新查询布局reloaddata之前调用此方法
//子类中必须重写该方法并调用超类的方法

/**
 在这里计算cell的布局；前提：cell的位置是固定不变的
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.minimumInteritemSpacing = 0.f;
    
    NSInteger itemNum = [self.collectionView numberOfItemsInSection:0];
    //初始化首个item位置
    _attrubutesArray = [NSMutableArray array];
    //得到每个item属性并存储
    for (NSInteger i = 0; i < itemNum; i++) {
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        //        布局
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexpath];
        
        //        总宽
        //CGFloat contentW = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        //        item宽
        CGFloat itemW = self.itemSize.width;
        //        获取item高
        CGFloat itemH = self.itemSize.height;
        
        //        itemX
        CGFloat itemX = self.sectionInset.left + (itemW + self.minimumInteritemSpacing)*i-self.offsetX*i;
        //        itemY
        CGFloat itemY = self.sectionInset.top;
        
        attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        [self.attrubutesArray addObject:attr];
    }
    
}
/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获取当前显示的cell的布局
    //NSArray *atts = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    
    return self.attrubutesArray;
}
//当Bounds改变时，也就是在滚动的时候，返回YES使CollectionView重新查询几何信息的布局，也就是允许重新布局
/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
//默认为NO,一般情况下如果有动效或者cell尺寸改变需要返回YES，会调用prepareLayout和layoutAttributesForElementsInRect重新布局
    return NO;
}
/**
 * 此方法会在用户松开手指的时候调用，这个方法的返回值，就决定了collectionView停止滚动时的最终的偏移量
   作用：返回值决定了collectionView停止滚动时最终的偏移量（contentOffset）
   参数：
   proposedContentOffset：原本情况下，collectionView停止滚动时最终的偏移量
   velocity：滚动速率，通过这个参数可以了解滚动的方向
 */
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    // 最终的偏移量不等于手指离开时的偏移量
//}
//子类必须重写此方法。
//并使用它来返回CollectionView视图内容的宽高，
//这个值代表的是所有的内容的宽高，并不是当前可见的部分。
//CollectionView将会使用该值配置内容的大小来促进滚动。
- (CGSize)collectionViewContentSize
{
   NSInteger itemNum = [self.collectionView numberOfItemsInSection:0];
   return CGSizeMake(itemNum*self.itemSize.width-self.offsetX*(itemNum-1)+self.sectionInset.left+self.sectionInset.right, 0);
}

@end
