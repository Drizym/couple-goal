import SwiftUI

struct GamesView: View {
    let games = ["Tic Tac Toe", "Memory", "Quiz de couple", "Sudoku"]
    
    var body: some View {
        NavigationView {
            List(games, id: \.self) { game in
                NavigationLink(destination: GameDetailView(gameName: game)) {
                    Text(game)
                }
            }
            .navigationTitle("Jeux")
        }
    }
}

