//
//  FavoritesStorage.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import CoreData

protocol IFavoritesStorage {
    func getAllFavorites() -> [Images]
    func toggleFavorite(_ image: Images)
    func isFavorite(id: String) -> Bool
    func getAllFavoritesIds() -> Set<String>
    
}

final class FavoritesStorage: IFavoritesStorage {
    
    private let context = CoreDataManager.shared.context
    private let favoritesKey = AppConstants.Strings.favoritesKey
    
    func getAllFavorites() -> [Images] {
        let fetchRequest: NSFetchRequest<FavoriteImage> = FavoriteImage.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.compactMap { entity -> Images? in
                guard let data = entity.jsonData else {return nil}
                return try? JSONDecoder().decode(Images.self, from: data)
            }
        } catch {
            print("CoreData fetch error: \(error)")
            return []
        }
    }
    
    func toggleFavorite(_ image: Images) {
        let fetchRequest: NSFetchRequest<FavoriteImage> = FavoriteImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", image.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let existing = result.first {
                context.delete(existing)
            } else {
                let entity = FavoriteImage(context: context)
                entity.id = image.id
                
                if let jsonData = try? JSONEncoder().encode(image) {
                    entity.jsonData = jsonData
                }
            }
            CoreDataManager.shared.saveContext()
        } catch {
            print("CoreData toggle error: \(error)")
        }
    }
    
    func isFavorite(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteImage> = FavoriteImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    func getAllFavoritesIds() -> Set<String> {
        let fetchRequest: NSFetchRequest<FavoriteImage> = FavoriteImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id != nil")
        
        do {
            let results = try context.fetch(fetchRequest)
            let ids = results.compactMap { $0.id as? String}
            return Set(ids)
        } catch {
            print ("CoreData fetch error: \(error)")
            return []
        }

    }
}
