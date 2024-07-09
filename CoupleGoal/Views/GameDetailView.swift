import SwiftUI

struct GameDetailView: View {
    let gameName: String
    
    var body: some View {
        switch gameName {
        case "Sudoku":
            SudokuView()
        default:
            Text("Ici sera le jeu : \(gameName)")
                .navigationTitle(gameName)
        }
    }
}

#Preview {
    GameDetailView(gameName: "String")
}
