import SwiftUI

class SudokuViewModel: ObservableObject {
    @Published var board: SudokuBoard
    @Published var selectedCell: SudokuCell? = nil
    
    init() {
        let (puzzle, solution) = SudokuBoard.generatePuzzle()
        self.board = SudokuBoard(puzzle: puzzle, solution: solution)
    }
    
    func selectCell(_ cell: SudokuCell) {
        selectedCell = cell
    }
    
    func enterValue(_ value: Int) {
        guard let selectedCell = selectedCell, selectedCell.isEditable else { return }
        
        if let index = board.cells.firstIndex(where: { $0.id == selectedCell.id }) {
            // Vérifier si la valeur est correcte
            if board.solution[selectedCell.row][selectedCell.col] == value {
                board.cells[index].value = value
                board.cells[index].isValid = true
            } else {
                board.cells[index].value = value
                board.cells[index].isValid = false
            }
        }
        
        self.selectedCell = nil
    }
    
    func generateNewPuzzle() {
        let (puzzle, solution) = SudokuBoard.generatePuzzle()
        self.board = SudokuBoard(puzzle: puzzle, solution: solution)
    }
}
