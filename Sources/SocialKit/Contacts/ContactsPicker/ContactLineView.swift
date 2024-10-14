//
//  ContactsKit.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import SwiftUI

struct ContactLineView: View {
    
    var photos: [Photo]
    var title: String
    var subtitle: String?
    var actionKind: ContactActionKind
    var isSelected: Bool
    var hasMultipleNumbers: Bool = false
    var action: (() -> Void)?
    private let photoWidth = 50.0
    @EnvironmentObject var colors: ContactsPickerColors

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                if photos.count == 0 {
                    photoView(for: .none)
                        .frame(width: photoWidth, height: photoWidth)
                }
                if photos.count == 1 {
                    photoView(for: photos[0])
                        .frame(width: photoWidth, height: photoWidth)
                }
                else if photos.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -photoWidth / 2) {
                            ForEach(Array(photos.enumerated()), id: \.offset) { index, photo in
                                VStack(alignment: .center) {
                                    photoView(for: photo)
                                        .frame(width: photoWidth, height: photoWidth)
                                }
                            }
                        }
                    }
                }
            }
            
            if photos.count < 2 {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(colors.primaryForeground)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
            
            switch actionKind {
            case .none:
                EmptyView()
            case .select(let title):
                Text(actionKind.title)
                    .font(.caption)
                    .foregroundStyle(colors.primaryForeground)
                RadioCheckButton(isSelected: isSelected)

            case .tap(let title), .sendMessage(title: let title, _):
                Button {
                    action?()
                } label: {
                    Text(actionKind.title)
                        .font(.caption)
                        .foregroundStyle(colors.primaryAccent)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
    
    @ViewBuilder
    private func photoView(for photo: Photo) -> some View {
        switch photo {
        case .image(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .background {
                    Circle()
                        .stroke(colors.primaryForeground, lineWidth: 1.0)
                }
        case .data(let data):
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .background {
                    Circle()
                        .stroke(colors.primaryForeground, lineWidth: 1.0)
                }
            
        case .url(let url):
            AsyncImage(url: url)
                .scaledToFill()
                .clipShape(Circle())
                .background {
                    Circle()
                        .stroke(colors.primaryForeground, lineWidth: 1.0)
                }

        case .none:
            Image(systemName: "person.circle")
                .font(.system(size: 40))
                .foregroundStyle(colors.secondaryForeground)
                .clipShape(Circle())
                .background {
                    Circle()
                        .stroke(colors.primaryForeground, lineWidth: 1.0)
                }
        case .asset(let ressourceName):
            Image(ressourceName, bundle: .main)
        }
    }
}

#Preview {
    ContactLineView(photos: [], title: "", actionKind: ContactActionKind.select(), isSelected: false)
}


struct LoadingContactLineView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
                .padding(5)
            
            VStack(alignment: .leading, spacing: 5) {
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: 100)
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: 60)
            }
            .padding(10)
            
            Spacer()
            
            Circle()
                .frame(width: 20, height: 20)
        }
        .frame(height: 50)
    }
}
