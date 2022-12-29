import SwiftUI
import Alamofire

struct SigninView: View {
    @EnvironmentObject var sceneFlowState: SceneFlowState
    @State var email = ""
    @State var password = ""
    @State var isError = false
    @State var toastMessage = ""

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

            VStack(spacing: 20) {
                irdTextField("이메일를 입력해주세요", text: $email)

                irdTextField("비밀번호를 입력해주세요", text: $password, isSecure: true)
            }

            Button {
                signinButtonDidTap()
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
            .disabled(email.isEmpty || password.isEmpty)
            .padding(.top, 48)
            .padding(.bottom, 32)
            .padding(.horizontal, 16)

            Spacer()
        }
        .irdToast(isShowing: $isError, message: toastMessage, style: .error)
    }
    
    func signinButtonDidTap() {
        let url = "https://server.gauth.co.kr/oauth/code"
        UserDefaults.standard.setValue(email, forKey: UserDefaultsKeys.email.rawValue)
        AF.request(
            URL(string: url)!,
            method: .post,
            parameters: [
                "email": email,
                "password": password
            ],
            encoding: JSONEncoding.default
        )
        .responseDecodable(
            of: CodeDTO.self
        ) { response in
            switch response.result {
            case let .success(code):
                let code = code.code
                print(code)
                self.codeSend(code: code)
                
            case let .failure(err):
                print(err)
                isError = true
                toastMessage = "이메일 혹은 비밀번호가 일치하지 않습니다"

            default:
                return
            }
        }
    }

    func codeSend(code: String) {
        let url = "http://10.82.20.103:8080/auth/login"
        AF.request(
            URL(string: url)!,
            method: .get,
            parameters: [
                "code": code
            ],
            encoding: URLEncoding.queryString
        ).responseDecodable(of: TokenDTO.self) { response in
            switch response.result {
            case let .success(token):
                print(token)
                Keychain.shared.save(type: .accessToken, value: token.accessToken)
                Keychain.shared.save(type: .refreshToken, value: token.refreshToken)
                sceneFlowState.sceneFlow = .home
                
            case let .failure(error):
                print(error)
                isError = true
                toastMessage = "로그인 및 회원가입이 실패했습니다!"
            }
        }
    }

    @ViewBuilder
    func irdTextField(
        _ placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }
        }
        .frame(height: 44)
        .padding(4)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black)
        }
        .padding(.horizontal, 16)
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
