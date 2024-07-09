import SwiftUI

struct SudokuView: View {
    @ObservedObject var viewModel = SudokuViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<9) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9) { col in
                            if let cell = self.viewModel.board.cells.first(where: { $0.row == row && $0.col == col }) {
                                SudokuCellView(cell: cell,
                                               isSelected: cell.id == self.viewModel.selectedCell?.id,
                                               onSelect: {
                                    self.viewModel.selectCell(cell)
                                })
                            }
                        }
                    }
                }
            }
            .background(Color.black)
            
            HStack {
                ForEach(1..<10) { number in
                    Button(action: {
                        self.viewModel.enterValue(number)
                    }) {
                        Text("\(number)")
                            .frame(width: 35, height: 35)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
            .padding()
            
            Button(action: {
                viewModel.generateNewPuzzle()
            }) {
                Text("Créer un nouveau Sudoku")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}



struct SudokuCellView: View {
    let cell: SudokuCell
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(isSelected ? Color.blue.opacity(0.3) : Color.white)
                .frame(width: 35, height: 35)
                .border(Color.black, width: 1)
                .onTapGesture {
                    onSelect()
                }
            
            if let value = cell.value {
                Text("\(value)")
                    .foregroundColor(cell.isEditable ? (cell.isValid ? Color.black : Color.red) : Color.black)
                    .fontWeight(cell.isEditable ? .regular : .bold)
            }
        }
    }
}
struct GridOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 9
            
            Path { path in
                for i in 0...9 {
                    let lineWidth: CGFloat = (i % 3 == 0) ? 2 : 1
                    path.move(to: CGPoint(x: CGFloat(i) * size, y: 0))
                    path.addLine(to: CGPoint(x: CGFloat(i) * size, y: geometry.size.height))
                    path.move(to: CGPoint(x: 0, y: CGFloat(i) * size))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: CGFloat(i) * size))
                }
            }
            .stroke(Color.black, lineWidth: 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    SudokuView()
}
