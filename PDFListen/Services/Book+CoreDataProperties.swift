//
//  Book+CoreDataProperties.swift
//  PDFListen
//
//  Created by Connor Auyong on 11/22/24.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var filePath: String?

}

extension Book : Identifiable {

}
