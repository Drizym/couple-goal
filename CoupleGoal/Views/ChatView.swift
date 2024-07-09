import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            List(chatViewModel.messages) { message in
                MessageBubble(message: message, currentUserID: authViewModel.userId ?? "")
            }
            HStack {
                TextField("Message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    guard let userId = authViewModel.userId else { return }
                    chatViewModel.sendMessage(content: messageText, senderID: userId)
                    messageText = ""
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
    }
}
