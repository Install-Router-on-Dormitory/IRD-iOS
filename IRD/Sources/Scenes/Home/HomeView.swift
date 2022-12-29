import SwiftUI
import Alamofire

struct HomeView: View {
    @EnvironmentObject var sceneFlowState: SceneFlowState
    @State var profileURL: String = ""
    @State var grade: Int = 0
    @State var classNum = 0
    @State var num = 0
    @State var name = ""
    let reader = NFCReader()

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: profileURL)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image(systemName: "person")
                        .resizable()
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 0) {
                    Text("\(grade)\(classNum)\(num > 10 ? "\(num)" : "0\(num)")")
                        .font(.headline)

                    Text(name)
                }

                Spacer()

                Button {
                    Keychain.shared.delete(type: .accessToken)
                    Keychain.shared.delete(type: .refreshToken)
                    sceneFlowState.sceneFlow = .signin
                } label: {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(.red)
                }
                .padding(.trailing, 4)
            }
            .padding(4)
            .background {
                Color.white
                    .cornerRadius(12)
            }
            .shadow(radius: 6)

            Spacer()

            Button {
                guard let email = UserDefaults.standard.string(
                    forKey: UserDefaultsKeys.email.rawValue
                ) else {
                    return
                }
                reader.scan(data: "sucuess\(email)") {
                    print($0)
                }
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
        .onAppear {
            fetchMyProfile()
        }
        .padding(16)
    }

    func fetchMyProfile() {
        let url = "http://10.82.20.103:8080/user"
        AF.request(
            URL(string: url)!,
            method: .get,
            headers: [
                "Authorization": "Bearer \(Keychain.shared.load(type: .accessToken))"
            ]
        ).responseDecodable(of: MyProfileDTO.self) { response in
            print(String(data: response.data ?? .init(), encoding: .utf8))
            switch response.result {
            case let .success(profile):
                self.profileURL = profile.profileUri ?? ""
                self.grade = profile.grade
                self.classNum = profile.classNum
                self.num = profile.num
                self.name = profile.name

            case let .failure(err):
                print(err)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
