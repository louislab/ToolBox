//
//  OpenAIView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

import SwiftUI
import Alamofire

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
    
    func fetchContent() {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let parameters: Parameters = [
            "prompt": "\(settings.prompt)",
            "max_tokens": settings.max_tokens,
            "temperature": settings.temperature,
            "top_p": settings.top_p,
            "n": settings.n,
            "stream": settings.stream,
            "logprobs": NSNull(),
            "stop": "\(settings.stop)"
        ]
        
        struct ServerResponse: Decodable {
            let id: String?
            let object: String?
            let created: Int?
            let model: String?
            let choices: [Choice]?
            let error: Err?

            struct Choice: Decodable {
                let text: String?
                let index: Int?
                let logprobs: JSONNull?
                let finish_reason: String?
            }
            
            struct Err: Decodable {
                let code: JSONNull?
                let message: String?
                let param: JSONNull?
                let type: String?
            }
        }
        
        AF.request(
            "https://api.openai.com/v1/engines/\(settings.engine)/completions",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: ServerResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("Response: \(String(describing: value.choices?.first?.text))")
                let content = value.choices?.first?.text ?? ""
                settings.content = "\(settings.prompt)\(content)"
            case .failure(let error):
                debugPrint("Error: \(error)")
            }
        }
        
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
                .font(Font.custom("RobotoMono-Light", size: 15))
                .disableAutocorrection(true)
                .padding()
                .modifier(InnerShadowModifier())
                .padding([.leading, .bottom, .trailing])
                .onAppear {
                    if inited == false {
                        settings.initSettings()
                        inited = true
                    }
                }
            HStack {
                Spacer()
                Button(action: {
                    settings.content = ""
                }) {
                    Text("Clear")
                        .fontWeight(.bold)
                }
                    .buttonStyle(MonoStyle())
                Spacer()
                Button(action: {
                    settings.prompt = settings.content
                    fetchContent()
                    hideKeyboard()
                }) {
                    Text("Generate")
                        .fontWeight(.bold)
                }
                    .buttonStyle(MonoStyle())
                Spacer()
            }
        }
        .navigationTitle("Completions")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: {
            settings.saveSettings()
        })
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
                Button(action: {
                    settings.content = "Once upon a time"
                    settings.engine = "davinci"
                    settings.prompt = ""
                    settings.max_tokens = 10
                    settings.temperature = 1
                    settings.top_p = 1
                    settings.n = 1
                    settings.stream = false
                    settings.stop = "\\n"
                },
                       label: {
                    Text("Reset")
                })
                    .padding()
            }
        }
        .navigationTitle("Configuration")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear(perform: {
            settings.saveSettings()
        })
    }
}

// MARK: - Completion settings class

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
    
    // used for data saving, since codable and observable cannot stand together
    struct CompletionModel: Codable {
        var content: String
        var engine: String
        var prompt: String
        var max_tokens: Int
        var temperature: Double
        var top_p: Double
        var n: Int
        var stream: Bool
        var stop: String
    }
    
    func initSettings() {
        
        let reader = FilesManager()
        var rdata: Data
        do {
            try rdata = reader.read(fileNamed: "completion_model_settings.json")
        } catch {
            print(error)
            self.content = "Once upon a time"
            self.engine = "davinci"
            self.prompt = ""
            self.max_tokens = 10
            self.temperature = 1
            self.top_p = 1
            self.n = 1
            self.stream = false
            self.stop = "\\n"
            print("Data loaded from template.")
            return
        }
        
        let data = try! JSONDecoder().decode(CompletionModel.self, from: rdata)
        
        self.content = data.content
        self.engine = data.engine
        self.prompt = data.prompt
        self.max_tokens = data.max_tokens
        self.temperature = data.temperature
        self.top_p = data.top_p
        self.n = data.n
        self.stream = data.stream
        self.stop = data.stop
        
    }
    
    func saveSettings() {
        
        let writer = FilesManager()
        let wdata = CompletionModel(
            content: self.content,
            engine: self.engine,
            prompt: self.prompt,
            max_tokens: self.max_tokens,
            temperature: self.temperature,
            top_p: self.top_p,
            n: self.n,
            stream: self.stream,
            stop: self.stop
        )
        
        let data = try! JSONEncoder().encode(wdata)
        
        do {
            try writer.save(fileNamed: "completion_model_settings.json", data: data)
        } catch {
            print(error)
        }
        
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

// MARK: - JSONNull encode/decode helper

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

// MARK: - Modded fileManager for save / read data

class FilesManager {
    
    enum Error: Swift.Error {
        case fileAlreadyExists // not used
        case invalidDirectory
        case writtingFailed
        case fileNotExists
        case readingFailed
    }
    
    // create a real fileManage
    let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    // streamlined processing, enhanced error handling
    func save(fileNamed: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        do {
            try data.write(to: url)
            print("Data saved to local storage.")
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }
    
    func read(fileNamed: String) throws -> Data {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        guard fileManager.fileExists(atPath: url.path) else {
            throw Error.fileNotExists
        }
        do {
            let result = try Data(contentsOf: url)
            print("Data loaded from local storage.")
            return result
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
    // sub-function for file name processing
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
}

// MARK: - Extensions

// option to dismiss the keyboard when user tapped specific area
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
