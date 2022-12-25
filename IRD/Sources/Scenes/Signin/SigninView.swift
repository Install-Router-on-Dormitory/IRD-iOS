import SwiftUI

struct SigninView: View {
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Group {
                    Text("I")
                        .foregroundColor(Color(hex: "FF0000"))

                    Text("R")
                        .foregroundColor(Color(hex: "44FF57"))

                    Text("D")
                        .foregroundColor(Color(hex: "0029FF"))
                }
            }
            .opacity(0.6)
            .font(.custom("BlackHanSans-Regular", size: 120))
            .padding(.top, 32)

            Spacer()

            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 52)
                    .overlay {
                        ZStack {
                            HStack {
                                Image("SemiGAuth")
                                    .resizable()
                                    .frame(width: 30, height: 32)

                                Spacer()
                            }
                            .padding(.leading, 24)

                            Text("GAuth로 로그인")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
            }
            .padding(.bottom, 32)
            .padding(.horizontal, 16)
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
