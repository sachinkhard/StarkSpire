//
//  CoreDataStack.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()

    private override init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "StarkSpire")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveDataInCoreData(model: RecordModel?) {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RecordModelEntity", in: context)
        let rmEntity : RecordModelEntity = RecordModelEntity.init(entity: entity!, insertInto: context)
        
        if let array = model?.categories {
            for mCategory in array {
                
                for mProduct in mCategory.products {
                    
                    let entity1 = NSEntityDescription.entity(forEntityName: "TaxEntity", in: context)
                    let tEntity : TaxEntity = TaxEntity.init(entity: entity1!, insertInto: context)
                    tEntity.name = mProduct.tax?.name
                    tEntity.value = mProduct.tax?.value ?? 0
                    
                    let entity2 = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)
                    let pEntity : ProductEntity = ProductEntity.init(entity: entity2!, insertInto: context)
                    pEntity.id = Int64(mProduct.id)
                    pEntity.name = mProduct.name
                    pEntity.date_added = mProduct.date_added
                    pEntity.tax = tEntity
                    
                    if let variantArray = mProduct.variants {
                        _ = variantArray.map({
                            if let vEntity = self.createVariantEntityFrom(mVariant: $0) {
                                pEntity.addToVariants(vEntity)
                            }
                        })
                    }
                }
                
                let entity4 = NSEntityDescription.entity(forEntityName: "CategoryEntity", in: context)
                let cEntity : CategoryEntity = CategoryEntity.init(entity: entity4!, insertInto: context)
                cEntity.id = Int64(mCategory.id)
                cEntity.name = mCategory.name
                cEntity.child_categories = mCategory.child_categories
                rmEntity.addToCategories(cEntity)
            }
        }
        
        if let array = model?.rankings {
            _ = array.map({
                if let rEntity = self.createRankEntityFrom(mRank: $0) {
                    rmEntity.addToRankings(rEntity)
                }
            })
        }
        
        do { try context.save() } catch let saveError {
            CommonUtils.printAnyResponse(string: "Error while persisting records : \(saveError)")
        }
    }
    
    private func createRankEntityFrom(mRank: Rank) -> RankEntity? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if let rEntity = NSEntityDescription.insertNewObject(forEntityName: "RankEntity", into: context) as? RankEntity {
            rEntity.ranking = mRank.ranking
            
            _ = mRank.products.map({
                if let pEntity = self.createRankProductEntityFrom(mProduct: $0.first!) {
                    rEntity.addToProducts(pEntity)
                }
            })
            
            return rEntity
        }
        return nil
    }
    
    private func createRankProductEntityFrom(mProduct: Product) -> ProductEntity? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if let pEntity = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: context) as? ProductEntity {
            pEntity.id = Int64(mProduct.id)
            pEntity.view_count = mProduct.view_count ?? 0
            return pEntity
        }
        return nil
    }
    
    private func createVariantEntityFrom(mVariant: Variant) -> VariantEntity? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if let vEntity = NSEntityDescription.insertNewObject(forEntityName: "VariantEntity", into: context) as? VariantEntity {
            vEntity.id = Int64(mVariant.id)
            vEntity.color = mVariant.color
            vEntity.size = mVariant.size ?? 0
            vEntity.price = mVariant.price ?? 0
            return vEntity
        }
        return nil
    }
}

