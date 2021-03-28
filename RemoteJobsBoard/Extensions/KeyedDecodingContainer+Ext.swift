import Foundation

extension KeyedDecodingContainer {

    func decodeCollectionSafely<Element>(forKey key: KeyedDecodingContainer.Key) throws -> [Element] where Element: Decodable {
        let collection = try decode([SafeDecodable<Element>].self, forKey: key)
        return collection.compactMap { $0.value }
    }
    func decodeCollectionSafelyIfPresent<Element>(forKey key: KeyedDecodingContainer.Key) throws -> [Element] where Element: Decodable {
        guard let collection = try decodeIfPresent([SafeDecodable<Element>].self, forKey: key) else { return [] }
        return collection.compactMap { $0.value }
    }

    func decodeNotEmptyString(forKey key: KeyedDecodingContainer.Key) throws -> String {
        let string = try decode(String.self, forKey: key)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !string.isEmpty else {
            let debugDescription = "Decoded string should not be empty"
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: debugDescription)
        }
        return string
    }

    func decodeNotEmptyStringIfPresent(forKey key: KeyedDecodingContainer.Key) throws -> String? {
        let rawString = try decodeIfPresent(String.self, forKey: key)
        guard let string = rawString?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }

        guard !string.isEmpty else {
            let debugDescription = "Decoded string should not be empty"
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: debugDescription)
        }
        return string
    }

    func decodeISO8601Date(forKey key: KeyedDecodingContainer.Key) throws -> Date {
        let dateString = try decodeNotEmptyString(forKey: key)
        guard let date = ISO8601DateFormatter().date(from: dateString) else {
            let debugDescription = "Expected ISO8601 date string"
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: debugDescription)
        }
        return date
    }

    func decodeISO8601DateIfPresent(forKey key: KeyedDecodingContainer.Key) throws -> Date? {
        guard let dateString = try decodeNotEmptyStringIfPresent(forKey: key) else { return nil }
        guard let date = ISO8601DateFormatter().date(from: dateString) else {
            let debugDescription = "Expected ISO8601 date string"
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: debugDescription)
        }
        return date
    }

    func decodeDate(forKey key: KeyedDecodingContainer.Key) throws -> Date {
        guard let dateString = try decodeNotEmptyStringIfPresent(forKey: key) else {
            let debugDescription = "Expected date string"
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: debugDescription)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            let debugDescription = "Expected date format"
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: debugDescription)
        }
        return date
    }

}

// MARK: - SafeDecodable

private struct SafeDecodable<Base: Decodable>: Decodable {

    let value: Base?

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Base.self)
        } catch {
            value = nil
        }
    }

}
