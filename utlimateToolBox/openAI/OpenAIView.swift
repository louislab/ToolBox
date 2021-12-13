//
//  OpenAIView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

import SwiftUI

let apiKey: String = "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"

struct OpenAIView: View {
    
    var body: some View {
        List {
            NavigationLink(destination: CompletionsView(),
                label: {
                Text("Completions")
            })
            NavigationLink(destination: SearchesView(),
                label: {
                Text("Searches")
            })
            NavigationLink(destination: ClassificationsView(),
                label: {
                Text("Classifications")
            })
            NavigationLink(destination: AnswersView(),
                label: {
                Text("Answers")
            })
            NavigationLink(destination: CodexView(),
                label: {
                Text("Codex")
            })
            NavigationLink(destination: ContentFilterView(),
                label: {
                Text("Content Filter")
            })
        }
        .navigationTitle("Open AI")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Completion view

struct CompletionsView: View {
    @State var inited = false
    @StateObject var settings = Settings()
    
    func initSettings() {
        settings.content = "Once upon a time"
        settings.engine = "davinci"
        settings.prompt = ""
        settings.max_tokens = 5
        settings.temperature = 1
        settings.top_p = 1
        settings.n = 1
        settings.stream = false
        settings.stop = "\\n"
        inited = true
    }
    
    func getContent() {
        
        struct RawServerResponse: Decodable {
            let id: String
            let object: String
            let created: Int
            let model: String
            let choices: [Choice]
            
            struct Choice: Decodable {
                let text: String
                let index: Int
                let logprobs: JSONNull?
                let finish_reason: String
            }
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/engines/\(settings.engine)/completions"),
            let payload = """
                {
                    "prompt": "\(settings.prompt)",
                    "max_tokens": \(settings.max_tokens),
                    "temperature": \(settings.temperature),
                    "top_p": \(settings.top_p),
                    "n": \(settings.n),
                    "stream": \(settings.stream),
                    "logprobs": null,
                    "stop": "\(settings.stop)"
                }
                """.data(using: .utf8) else
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let jsonData = data else { print("Empty data"); return }

            let serverResponse = try! JSONDecoder().decode(RawServerResponse.self, from: jsonData)
            
            let content = serverResponse.choices.first!.text
            
            DispatchQueue.main.async {
                self.settings.content = self.settings.prompt + content
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Playground")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                NavigationLink(destination: CompletionsView_menu()
                                .environmentObject(settings),
                    label: {
                    Image(systemName: "slider.horizontal.3")
                        .aspectRatio(contentMode: .fit)
                })
                    .padding()
                    .buttonStyle(MonoStyle_s())
            }
            TextEditor(text: $settings.content)
                .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                .padding()
                .modifier(InnerShadowModifier())
                .padding([.leading, .bottom, .trailing])
                .onAppear {
                    if inited == false {
                        initSettings()
                    }
                }
            Button(action: {
                settings.prompt = settings.content
                getContent()
                hideKeyboard()
            }) {
                Text("Generate")
                    .fontWeight(.bold)
            }
            .buttonStyle(MonoStyle())
        }
        .navigationTitle("Completions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Completion view (menu)

struct CompletionsView_menu: View {
    @EnvironmentObject var settings: Settings

    let engines = ["davinci", "curie", "babbage", "ada", "davinci-instruct-beta-v3", "curie-instruct-beta-v2", "babbage-instruct-beta", "ada-instruct-beta", "davinci-codex", "cushman-codex"]
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            return formatter
        }()

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                VStack {
                    Text("Engine")
                        .padding([.top, .leading, .trailing])
                    Picker("Pick an Engine", selection: $settings.engine) {
                        ForEach(engines, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                }
                VStack {
                    HStack {
                        Text("Temperature")
                            .padding(.trailing)
                        TextField("", value: $settings.temperature, formatter: formatter)
                            .frame(width: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    .padding([.top, .leading, .trailing])
                    Slider(value: $settings.temperature, in: 0...1, step: 0.01)
                        .padding([.leading, .bottom, .trailing])
                        .frame(width: 220.0, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                }
                VStack {
                    HStack {
                        Text("Response length")
                            .padding(.trailing)
                        TextField("", value: $settings.max_tokens, formatter: formatter)
                            .frame(width: 60.0, height: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    .padding([.top, .leading, .trailing])
                    Slider(value: settings.max_tokens_double, in: 1...2048, step: 1)
                        .padding([.leading, .bottom, .trailing])
                        .frame(width: 220.0, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                }
                HStack {
                    Text("Stop sign")
                        .padding(.trailing)
                    TextField("", text: $settings.stop)
                        .frame(width: 60.0, height: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .onSubmit {}
                        .submitLabel(.done)
                }
                .padding()
                VStack {
                    HStack {
                        Text("Top P")
                            .padding(.trailing)
                        TextField("", value: $settings.top_p, formatter: formatter)
                            .frame(width: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    .padding([.top, .leading, .trailing])
                    Slider(value: $settings.top_p, in: 0...1, step: 0.01)
                        .padding([.leading, .bottom, .trailing])
                        .frame(width: 220.0, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .navigationTitle("Configuration")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - Shared settings

class Settings: ObservableObject {
    @Published var content = ""
    @Published var engine = ""
    @Published var prompt = ""
    @Published var max_tokens = 1
    @Published var temperature = 1.0
    @Published var top_p = 1.0
    @Published var n = 1
    @Published var stream = false
    @Published var stop = ""
    
    var max_tokens_double: Binding<Double>{
        Binding<Double>(get: {
            //returns the Int as a Double
            return Double(self.max_tokens)
        }, set: {
            //rounds the Double to an Int
            self.max_tokens = Int($0)
        })
    }
}

// MARK: - Searches view

struct SearchesView: View {
    var body: some View {
        Text("Placeholder")
        .navigationTitle("Searches")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ClassificationsView: View {
    var body: some View {
        Text("Placeholder")
        .navigationTitle("Classifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AnswersView: View {
    var body: some View {
        Text("Placeholder")
        .navigationTitle("Answers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentFilterView: View {
    var body: some View {
        Text("Placeholder")
        .navigationTitle("Content Filter")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CodexView: View {
    var body: some View {
        Text("Placeholder")
        .navigationTitle("Codex")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Button styles

struct MonoStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.black)
            .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white)
                            .shadow(color: Color.white, radius: 4, x: -4, y: -4)
                            .shadow(color: Color.gray, radius: 4, x: 4, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct MonoStyle_s: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10.0)
            .foregroundColor(.black)
            .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .shadow(color: Color.white, radius: 2, x: -2, y: -2)
                            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

// MARK: - Inner shadows

struct InnerShadowModifier: ViewModifier {
    @State var radius: CGFloat = 10
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.white, lineWidth: 4)
                    .shadow(color: Color.gray, radius: 3, x: 3, y: 3)
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                    .shadow(color: Color.white, radius: 3, x: -3, y: -3)
                    .clipShape(RoundedRectangle(cornerRadius: radius)
                              )
                )
        }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// MARK: - Extensions

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

// MARK: - Preview section

struct OpenAIView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionsView()
    }
}
