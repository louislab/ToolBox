//
//  OpenAIView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

import SwiftUI
import Alamofire

struct OpenAIView: View {
    @StateObject fileprivate var api = OPENAI()
    
    var body: some View {
        List {
            NavigationLink(destination: CompletionsView().environmentObject(api),
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
            NavigationLink(destination: SettingsView().environmentObject(api),
                label: {
                Text("Settings")
            })
        }
        .navigationTitle("Open AI")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var alertMsg = ""
    @EnvironmentObject fileprivate var api: OPENAI
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack() {
                Spacer()
                VStack() {
                    Text("OPENAI API Key")
                        .padding([.leading, .top, .trailing])
                    TextField("", text: $api.KEY)
                        .padding([.leading, .bottom, .trailing])
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
                Button(action: {
                    let r = FilesManager()
                    do {
                        try r.remove(fileNamed: "OPENAI")
                        showingAlert = true
                        alertMsg = "Settings erased successfully."
                    } catch {
                        showingAlert = true
                        alertMsg = "Settings is empty."
                    }
                    api.KEY = ""
                }, label: {
                    Text("Erase all OPENAI settings")
                        .foregroundColor(Color.red)
                })
                    .padding(.bottom, 50.0)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertMsg), dismissButton: .default(Text("Dismiss")))
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: {
            api.config()
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - Completion view

struct CompletionsView: View {
    @StateObject fileprivate var settings = CompletionSettings()
    @EnvironmentObject fileprivate var api: OPENAI
    @State private var showingAlert = false
    
    func fetchContent() throws {
        
        enum Error: Swift.Error {
            case noAPIKeyDetected
        }
        
        if api.KEY.isEmpty {
            throw Error.noAPIKeyDetected
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(api.KEY)"
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
                let logprobs: Double?
                let finish_reason: String?
            }
            
            struct Err: Decodable {
                let code: String?
                let message: String?
                let param: String?
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
            HStack {
                Spacer()
                Button(action: {
                    if !settings.reverseCard.isEmpty {
                        settings.content = settings.reverseCard.removeLast()
                    }
                },
                       label: {
                    Image(systemName: "arrow.uturn.backward")
                        .aspectRatio(contentMode: .fit)
                })
                    .padding()
                    .buttonStyle(MonoStyle())
                Spacer()
                Button(action: {
                    settings.reverseCard.append(settings.content)
                    settings.content = ""
                },
                       label: {
                    Text("Clear")
                        .fontWeight(.bold)
                })
                    .buttonStyle(MonoStyle())
                Spacer()
                Button(action: {
                    settings.prompt = settings.content
                    settings.reverseCard.append(settings.content)
                    do {
                        try fetchContent()
                    } catch {
                        showingAlert = true
                    }
                    hideKeyboard()
                },
                       label: {
                    Text("Generate")
                        .fontWeight(.bold)
                })
                    .buttonStyle(MonoStyle())
                Spacer()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("API Key not found."), message: Text("Please config your API Key in settings"), dismissButton: .default(Text("Dismiss")))
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
    @EnvironmentObject fileprivate var settings: CompletionSettings

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
                    settings.max_tokens = 20
                    settings.temperature = 1.0
                    settings.top_p = 1.0
                    settings.n = 1
                    settings.stream = false
                    settings.stop = "\\n"
                    settings.reverseCard = []
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

fileprivate class CompletionSettings: ObservableObject {
    @Published var content: String
    @Published var engine: String
    @Published var prompt: String
    @Published var max_tokens: Int
    @Published var temperature: Double
    @Published var top_p: Double
    @Published var n: Int
    @Published var stream: Bool
    @Published var stop: String
    @Published var reverseCard: [String] // a stack for undo movement
    
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
    
    init() {
        
        let reader = FilesManager()
        var rdata: Data
        do {
            try rdata = reader.read(fileNamed: "OPENAI/completion_model_settings.json")
        } catch {
            print(error)
            self.content = "Once upon a time"
            self.engine = "davinci"
            self.prompt = ""
            self.max_tokens = 20
            self.temperature = 1.0
            self.top_p = 1.0
            self.n = 1
            self.stream = false
            self.stop = "\\n"
            self.reverseCard = []
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
        self.reverseCard = []
        
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
            try writer.save(fileNamed: "OPENAI/completion_model_settings.json", data: data)
        } catch {
            do {
                try writer.createDir(dirPath: "OPENAI")
                try writer.save(fileNamed: "OPENAI/completion_model_settings.json", data: data)
            } catch {
                print(error)
            }
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

// MARK: - API key class

fileprivate class OPENAI: ObservableObject {
    @Published var KEY = ""

    init() {

        let reader = FilesManager()
        var rdata: Data
        do {
            try rdata = reader.read(fileNamed: "OPENAI/.env")
        } catch {
            print(error)
            return
        }
        
        let data = String(data: rdata, encoding: .utf8)!
        self.KEY = data
        
    }

    func config() {

        let writer = FilesManager()
        let data: Data? = self.KEY.data(using: .utf8)

        do {
            try writer.save(fileNamed: "OPENAI/.env", data: data!)
        } catch {
            do {
                try writer.createDir(dirPath: "OPENAI")
                try writer.save(fileNamed: "OPENAI/.env", data: data!)
            } catch {
                print(error)
            }
        }

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
        case removingFailed
        case createDirFailed
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
            print("Data saved under \(url.path)")
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }
    
    func createDir(dirPath: String) throws {
        guard let url = makeURL(forFileNamed: dirPath) else {
            throw Error.invalidDirectory
        }
        do {
            try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            print("Directory created under \(url.path)")
        } catch {
            debugPrint(error)
            throw Error.createDirFailed
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
    
    func remove(fileNamed: String) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        guard fileManager.fileExists(atPath: url.path) else {
            throw Error.fileNotExists
        }
        do {
            try fileManager.removeItem(atPath: url.path)
            print("Removed data under \(url.path)")
        } catch {
            debugPrint(error)
            throw Error.removingFailed
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
        SettingsView()
    }
}
