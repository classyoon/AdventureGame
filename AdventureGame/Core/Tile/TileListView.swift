//
//  TileListView.swift
//  AdventureGame
//
//  Created by Conner Yoon on 11/17/24.
//

import SwiftUI
import SwiftData

struct Location: Codable {
    var x: Int = 0
    var y: Int = 0
}

@Model
class Tile {
    var id = UUID()
    var title = ""
    var desript = ""
    var location: Location = Location()
    init(id: UUID = UUID(), title: String = "", desript: String = "", location: Location = Location()) {
        self.id = id
        self.title = title
        self.desript = desript
        self.location = location
    }
}

@Observable
class TileGridVM {
    private(set) var tiles: [Tile] = []
    func add(tile: Tile) {
        tiles.append(tile)
    }
    func delete(tile: Tile) {
        guard let index = tiles.firstIndex(where: {$0.id == tile.id}) else { return }
        tiles.remove(at: index)
    }
    func update(tile: Tile) {
        guard let index = tiles.firstIndex(where: {$0.id == tile.id}) else { return }
        tiles[index] = tile
    }
}

struct TileEditView: View {
    @Bindable var tile: Tile
    var save: (Tile)->()
    var delete: (Tile)->()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Title", text: $tile.title)
            TextField("Desription", text: $tile.desript)
            Button {
                save(tile)
                dismiss()
            } label: {
                Text("Save")
            }
            Button {
                delete(tile)
                dismiss()
            } label: {
                Text("Delete")
            }

        }
    }
}
struct TileRowView : View {
    var tile : Tile
    var body: some View {
        VStack{
            Text(tile.title)
            Text(tile.desript)
        }
    }
}
struct TileListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tiles: [Tile]
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tiles) { tile in
                    NavigationLink {
                        TileEditView(tile: tile, save: update, delete: delete)
                    } label: {
                        TileRowView(tile: tile)
                    }
                }
            }
            .toolbar {
                Button {
                    isShowingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                NavigationStack {
                    @State var tile = Tile()
                    TileEditView(tile: tile, save: add, delete: {_ in})
                        .navigationTitle("Add Tile")
                }
            }
            .navigationTitle("Tiles")
        }
    }
    func add(_ tile: Tile) {
        modelContext.insert(tile)
    }
    func delete(_ tile: Tile ) {
        modelContext.delete(tile)
    }
    func update(_ tile: Tile) {
        try? modelContext.save()
    }
}

#Preview {
    TileListView()
        .modelContainer(for: Tile.self, inMemory: true)
}
