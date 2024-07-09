import SwiftUI

struct MessageBubble: View {
    let message: Message
    let currentUserID: String

    var body: some View {
        HStack {
            if message.senderID == currentUserID {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding([.top, .leading, .trailing])
    }
}
