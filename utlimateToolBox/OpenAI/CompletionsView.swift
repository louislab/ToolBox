//
//  OpenAIView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

import SwiftUI
import Alamofire

// MARK: - Completion view

struct CompletionsView: View {
    @StateObject var settings = CompletionSettings()
    @StateObject var api = OpenAI()
    @State private var showingAlert = false
    @State private var savingAlert = false
    @State private var isHidden = true
    @State private var showingPresets = false
    @State var preset: Presets = .completion
    @State var presetStyle: [Color] = []
    @Binding var rootIsActive : Bool
    
    func fetchContent() {
        
        if api.KEY.isEmpty {
            showingAlert.toggle()
            return
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
            "echo": false,
            "stop": settings.stop.isEmpty ? NSNull() : settings.stop,
            "presence_penalty": settings.presence_penalty,
            "frequency_penalty": settings.frequency_penalty,
            "best_of": settings.best_of
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
        
        isHidden = false
        
        AF.request(
            "https://api.openai.com/v1/engines/\(settings.engine)/completions",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: ServerResponse.self) { response in
            switch response.result {
            case .success(let value):
                isHidden = true
                print("Response: \(String(describing: value.choices?.first?.text))")
                if let content = value.choices?.first?.text {
                    settings.content = "\(settings.prompt)\(content)"
                } else {
                    showingAlert.toggle()
                }
            case .failure(let error):
                isHidden = true
                debugPrint(error)
            }
        }
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Playground")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .top])
                Spacer()
                ProgressView()
                    .isHidden(isHidden)
                    .padding(.top)
                Spacer()
                Button(action: {
                    hideKeyboard()
                    settings.saveSettings()
                    savingAlert.toggle()
                }, label: {
                    Text("Save")
                        .font(.system(size: 15))
                        .frame(width: 70, height: 35)
                })
                    .buttonStyle(OpenAIStyle())
                    .padding(.top)
                Spacer()
                Button(action: {
                    presetStyle.removeAll()
                    for _ in 1...Presets.allCases.count {
                        presetStyle.append(genColor())
                    }
                    showingPresets.toggle()
                }, label: {
                    Text("Presets")
                        .font(.system(size: 15))
                        .frame(width: 75, height: 35)
                })
                    .buttonStyle(OpenAIStyle())
                    .padding(.top)
                Spacer()
                NavigationLink(destination: CompletionsView_menu(shouldPopToRootView: self.$rootIsActive, preset: $preset, presetStyle: $presetStyle)
                                .environmentObject(settings).environmentObject(api), label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 15))
                        .frame(width: 35, height: 35)
                })
                    .isDetailLink(false)
                    .buttonStyle(OpenAIStyle())
                    .padding([.trailing, .top])
            }
            TextEditor(text: $settings.content)
                .font(Font.custom("RobotoMono-Light", size: 15))
                .disableAutocorrection(true)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                .padding([.leading, .trailing])
            HStack {
                Spacer()
                Button(action: {
                    if !settings.reverseCard.isEmpty {
                        settings.content = settings.reverseCard.removeLast()
                    }
                }, label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 15))
                        .frame(width: 40, height: 40)
                })
                    .buttonStyle(OpenAIStyle())
                    .padding()
                Spacer()
                Button(action: {
                    settings.reverseCard.append(settings.content)
                    settings.content = ""
                }, label: {
                    Text("Clear")
                        .font(.system(size: 15))
                        .frame(width: 70, height: 40)
                })
                    .buttonStyle(OpenAIStyle())
                    .padding()
                Spacer()
                Button(action: {
                    settings.prompt = settings.content
                    settings.reverseCard.append(settings.content)
                    fetchContent()
                    hideKeyboard()
                }, label: {
                    Text("Generate")
                        .font(.system(size: 15))
                        .frame(width: 90, height: 40)
                })
                    .buttonStyle(OpenAIStyle())
                    .padding()
                Spacer()
            }
        }
        .sheet(isPresented: $showingPresets) {
            PresetsView(preset: $preset, presetStyle: $presetStyle).environmentObject(settings)
                }
        .alert("Settings Saved", isPresented: $savingAlert) {
            Button("Dismiss", role: .cancel) {}
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("API Key not properly configured"), message: Text("Please edit your API Key in settings"), dismissButton: .default(Text("Dismiss")))
        }
        .navigationTitle("Completions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Completion view (menu)

struct CompletionsView_menu: View {
    @EnvironmentObject var settings: CompletionSettings
    @EnvironmentObject var api: OpenAI
    @State private var showingAlert = false
    @State private var confirmationDialog = false
    @State private var alertMsg = ""
    @Binding var shouldPopToRootView : Bool
    @Binding var preset: Presets
    @Binding var presetStyle: [Color]
    

    let engines = ["davinci", "curie", "babbage", "ada", "davinci-instruct-beta-v3", "curie-instruct-beta-v2", "babbage-instruct-beta", "ada-instruct-beta", "davinci-codex", "cushman-codex"]
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            return formatter
        }()

    var body: some View {
        List {
            Section {
                Picker("Pick an Engine", selection: $settings.engine) {
                    ForEach(engines, id: \.self) {
                        Text($0)
                    }
                }
                VStack {
                    HStack {
                        Text("Temperature")
                        Spacer()
                        TextField("", value: $settings.temperature, formatter: formatter)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    Slider(value: $settings.temperature, in: 0...1, step: 0.01)
                        .frame(width: UIScreen.main.bounds.size.width * 0.8)
                }
                VStack {
                    HStack {
                        Text("Response length")
                        Spacer()
                        TextField("", value: $settings.max_tokens, formatter: formatter)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    Slider(value: settings.max_tokens_double, in: 1...2048, step: 1)
                        .frame(width: UIScreen.main.bounds.size.width * 0.8)
                }
                VStack {
                    HStack {
                        Text("Top P")
                        Spacer()
                        TextField("", value: $settings.top_p, formatter: formatter)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    Slider(value: $settings.top_p, in: 0...1, step: 0.01)
                        .frame(width: UIScreen.main.bounds.size.width * 0.8)
                }
                VStack {
                    HStack {
                        Text("Presence penalty")
                        Spacer()
                        TextField("", value: $settings.presence_penalty, formatter: formatter)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    Slider(value: $settings.presence_penalty, in: 0...2, step: 0.01)
                        .frame(width: UIScreen.main.bounds.size.width * 0.8)
                }
                VStack {
                    HStack {
                        Text("Frequency penalty")
                        Spacer()
                        TextField("", value: $settings.frequency_penalty, formatter: formatter)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    Slider(value: $settings.frequency_penalty, in: 0...2, step: 0.01)
                        .frame(width: UIScreen.main.bounds.size.width * 0.8)
                }
                HStack {
                    Text("Stop sign")
                    Spacer()
                    TextField("", text: settings.stopString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .submitLabel(.done)
                }
            }
            Section {
                NavigationLink(destination: OpenAIDeepView().environmentObject(api), label: {
                    Text("Configure API Key")
                })
                    .isDetailLink(false)
                Button(action: {
                    let content = settings.content
                    PresetsView(preset: $preset, presetStyle: $presetStyle, settings: _settings).build(preset: preset)
                    settings.content = content
                }, label: {
                    Text("Reset parameters")
                        .foregroundColor(Color.accentColor)
                })
                Button(action: {
                    confirmationDialog.toggle()
                }, label: {
                    Text("Erase all OpenAI saved settings")
                        .foregroundColor(Color.red)
                })
            }
        }
        .listStyle(InsetGroupedListStyle())
        .alert(isPresented: $confirmationDialog) {
            Alert(
                title: Text("Are you sure you want to erase all settings?"),
                message: Text("There is no undo"),
                primaryButton: .destructive(Text("Delete")) {
                    let r = FilesManager()
                    do {
                        try r.remove(fileNamed: "OpenAI")
                    } catch {
                        print(error)
                    }
                    showingAlert.toggle()
                    alertMsg = "Settings erased successfully"
                },
                secondaryButton: .cancel()
            )
        }
        .alert(alertMsg, isPresented: $showingAlert) {
            if alertMsg == "Settings erased successfully" {
                Button("Dismiss", role: .cancel) {
                    self.shouldPopToRootView = false
                }
            } else {
                Button("Dismiss", role: .cancel) {}
            }
        }
        .navigationTitle("Configuration")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - API Key setting view

struct OpenAIDeepView: View {
    @EnvironmentObject var api: OpenAI

    var body: some View {
        VStack {
            Text("OpenAI API Key")
                .padding(.top, 30)
                .padding([.leading, .trailing])
            SecureField("Paste your API Key here", text: $api.KEY)
                .padding([.leading, .trailing])
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
        }
        .onDisappear(perform: {
            api.config()
        })
    }
}

// MARK: - Completion settings class

class CompletionSettings: ObservableObject {
    @Published var content: String
    @Published var engine: String
    @Published var prompt: String
    @Published var max_tokens: Int
    @Published var temperature: Double
    @Published var top_p: Double
    @Published var n: Int
    @Published var stream: Bool
    @Published var stop: [String]
    @Published var presence_penalty: Double
    @Published var frequency_penalty: Double
    @Published var best_of: Int
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

    var stopString: Binding<String>{
        Binding<String>(get: {
            return self.stop.joined(separator: ", ").replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\\t", with: "\t").replacingOccurrences(of: "\\r", with: "\r")
        }, set: {
            self.stop = $0.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t").replacingOccurrences(of: "\\r", with: "\r").components(separatedBy: ", ")
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
        var stop: [String]
        var presence_penalty: Double
        var frequency_penalty: Double
        var best_of: Int
    }
    
    init() {
        
        let reader = FilesManager()
        var rdata: Data
        do {
            try rdata = reader.read(fileNamed: "OpenAI/completion_model_settings.json")
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
            self.stop = ["\n"]
            self.presence_penalty = 0
            self.frequency_penalty = 0
            self.best_of = 1
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
        self.presence_penalty = data.presence_penalty
        self.frequency_penalty = data.frequency_penalty
        self.best_of = data.best_of
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
            stop: self.stop,
            presence_penalty: self.presence_penalty,
            frequency_penalty: self.frequency_penalty,
            best_of: self.best_of
        )
        
        let data = try! JSONEncoder().encode(wdata)
        
        do {
            try writer.save(fileNamed: "OpenAI/completion_model_settings.json", data: data)
        } catch {
            do {
                try writer.createDir(dirPath: "OpenAI")
                try writer.save(fileNamed: "OpenAI/completion_model_settings.json", data: data)
            } catch {
                print(error)
            }
        }
        
    }
}

// MARK: - API key

class OpenAI: ObservableObject {
    @Published var KEY = ""

    init() {

        let reader = FilesManager()
        var rdata: Data
        do {
            try rdata = reader.read(fileNamed: "OpenAI/.env")
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
            try writer.save(fileNamed: "OpenAI/.env", data: data!)
        } catch {
            do {
                try writer.createDir(dirPath: "OpenAI")
                try writer.save(fileNamed: "OpenAI/.env", data: data!)
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

// MARK: - Button styles

struct OpenAIStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color(red: 60 / 255, green: 125 / 255, blue: 102 / 255) : Color(red: 74 / 255, green: 160 / 255, blue: 129 / 255))
            .cornerRadius(5)
    }
}

// MARK: - Extensions

// option to dismiss the keyboard when user tapped outside the textfield
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}

// MARK: - Preview section

struct CompletionsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
