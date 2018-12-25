//
//  MovieDTO.swift
//
//  Created by Trai on 12/20/18
//  Copyright (c) NexleSoft. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MovieDTO: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let posterPath = "poster_path"
    static let releaseDate = "release_date"
    static let id = "id"
    static let presaleFlag = "presale_flag"
    static let genreIds = "genre_ids"
    static let ageCategory = "age_category"
    static let descriptionValue = "description"
    static let title = "title"
    static let rate = "rate"
  }

  // MARK: Properties
  public var posterPath: String?
  public var releaseDate: Int?
  public var id: String?
  public var presaleFlag: Bool?
  public var genreIds: [GenreIdsDTO]?
  public var ageCategory: String?
  public var descriptionValue: String?
  public var title: String?
  public var rate: Float?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    posterPath = json[SerializationKeys.posterPath].string
    releaseDate = json[SerializationKeys.releaseDate].int
    id = json[SerializationKeys.id].string
    presaleFlag = json[SerializationKeys.presaleFlag].boolValue
    if let items = json[SerializationKeys.genreIds].array { genreIds = items.map { GenreIdsDTO(json: $0) } }
    ageCategory = json[SerializationKeys.ageCategory].string
    descriptionValue = json[SerializationKeys.descriptionValue].string
    title = json[SerializationKeys.title].string
    rate = json[SerializationKeys.rate].float
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
    if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = presaleFlag { dictionary[SerializationKeys.presaleFlag] = value }
    if let value = genreIds { dictionary[SerializationKeys.genreIds] = value.map { $0.dictionaryRepresentation() } }
    if let value = ageCategory { dictionary[SerializationKeys.ageCategory] = value }
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = rate { dictionary[SerializationKeys.rate] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.posterPath = aDecoder.decodeObject(forKey: SerializationKeys.posterPath) as? String
    self.releaseDate = aDecoder.decodeObject(forKey: SerializationKeys.releaseDate) as? Int
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.presaleFlag = aDecoder.decodeObject(forKey: SerializationKeys.presaleFlag) as? Bool
    self.genreIds = aDecoder.decodeObject(forKey: SerializationKeys.genreIds) as? [GenreIdsDTO]
    self.ageCategory = aDecoder.decodeObject(forKey: SerializationKeys.ageCategory) as? String
    self.descriptionValue = aDecoder.decodeObject(forKey: SerializationKeys.descriptionValue) as? String
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.rate = aDecoder.decodeObject(forKey: SerializationKeys.rate) as? Float
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(posterPath, forKey: SerializationKeys.posterPath)
    aCoder.encode(releaseDate, forKey: SerializationKeys.releaseDate)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(presaleFlag, forKey: SerializationKeys.presaleFlag)
    aCoder.encode(genreIds, forKey: SerializationKeys.genreIds)
    aCoder.encode(ageCategory, forKey: SerializationKeys.ageCategory)
    aCoder.encode(descriptionValue, forKey: SerializationKeys.descriptionValue)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(rate, forKey: SerializationKeys.rate)
  }

}
