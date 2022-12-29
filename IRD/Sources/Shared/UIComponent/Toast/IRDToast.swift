import SwiftUI

struct IRDToast: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let style: IRDToastStyle

    init(
        isShowing: Binding<Bool>,
        message: String,
        style: IRDToastStyle
    ) {
        _isShowing = isShowing
        self.message = message
        self.style = style
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            dmsToastView()
        }
        .onChange(of: isShowing) { _ in
            if isShowing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func dmsToastView() -> some View {
        VStack {
            if isShowing {
                HStack(spacing: 10) {
                    style.icon
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: style.size.width, height: style.size.height)
                        .foregroundColor(style.iconForeground)

                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(style.textForeground)

                    Spacer()
                }
                .transition(.offset(y: -50).combined(with: AnyTransition.opacity.animation(.default)))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background {
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: .blue.opacity(0.3), radius: 4)
                }
                .padding(.horizontal, 12)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }
            }

            Spacer()
        }
        .animation(.default, value: isShowing)
    }
}

public extension View {
    func irdToast(
        isShowing: Binding<Bool>,
        message: String,
        style: IRDToastStyle
    ) -> some View {
        modifier(IRDToast(isShowing: isShowing, message: message, style: style))
    }
}
