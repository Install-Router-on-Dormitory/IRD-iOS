import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 0) {
                    Text("2118")
                        .font(.headline)

                    Text("변찬우")
                }

                Spacer()
            }
            .padding(4)
            .background {
                Color.white
                    .cornerRadius(12)
            }
            .shadow(radius: 6)

            Spacer()

            Button {
                
            } label: {
                VStack {
                    HStack {
                        Image(systemName: "iphone.homebutton.radiowaves.left.and.right")

                        Text("누르지마시오")
                    }
                    .foregroundColor(.red)
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "ffffff"))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.4), radius: 4)
                }
                .padding(.top, 16)
            }

            Spacer()
        }
        .padding(16)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
