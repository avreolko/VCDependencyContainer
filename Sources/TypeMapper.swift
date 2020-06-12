//
//  TypeMapper.swift
//  
//
//  Created by Valentin Cherepyanko on 12.06.2020.
//

/// resolves one type as set of types, each succeptible as separate abstraction
/// example: Foo & Bar -> (Foo, Bar, Foo & Bar, Foo?, Bar?, (Foo & Bar)?)
internal final class TypeMapper {
    func registrationKeys(for type: Any.Type) -> Set<String> {
        let typeName = "\(type)"

        if typeName.contains("Optional<") {
            return Set([typeName])
        }

        var typeNames = typeName
            .split(separator: "&")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        typeNames.append(typeName)

        let otherTypesAsOptional = typeNames.compactMap { typeNamePart in
            return typeNamePart.contains("Optional<") == false
            ? "Optional<\(typeNamePart)>"
            : nil
        }

        typeNames.append(contentsOf: otherTypesAsOptional)

        return Set(typeNames)
    }
}
