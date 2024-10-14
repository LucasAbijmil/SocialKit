//
//  File.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import Foundation

extension Array where Element: Identifiable {
    func replaceByID(newElements: [Element]) -> [Element] {
        var updatedElements = self

        for newElement in newElements {
            if let index = updatedElements.firstIndex(where: { $0.id == newElement.id }) {
                updatedElements[index] = newElement
            } else {
                updatedElements.append(newElement)
            }
        }

        return updatedElements
    }

    func replaceById(element: Element) -> Self {
        guard let elementIndex = self.firstIndex(where: { $0.id == element.id }) else { return self }
        var mutatingSelf = self
        mutatingSelf[elementIndex] = element
        return mutatingSelf
    }

    mutating func remove(_ element: Element) where Element.ID: Hashable {
        self.removeAll(where: { $0.id.hashValue == element.id.hashValue })
    }
}

extension Array where Element: Hashable {
    func symetricDifference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension Sequence where Iterator.Element: Hashable {
    func intersects<S : Sequence>(with sequence: S) -> Bool
    where S.Iterator.Element == Iterator.Element
    {
        let sequenceSet = Set(sequence)
        return self.contains(where: sequenceSet.contains)
    }
}
