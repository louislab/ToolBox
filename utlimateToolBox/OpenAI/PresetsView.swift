//
//  PresetsView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 18/12/2021.
//

import SwiftUI

enum Presets: CaseIterable {
    case completion
    case chat
    case qanda
    case grammarCorrection
    case summarizeForA2ndGrader
    case naturalLanguageToOpenAIAPI
    case textToCommand
    case englishToFrench
    case naturalLanguageToStripeAPI
    case sqlTranslate
    case parseUnstructuredData
    case classification
    case pythonToNaturalLanguage
    case movieToEmoji
    case calculateTimeComplexity
    case translateProgrammingLanguages
    case advancedTweetClassifier
    case explainCode
    case keywords
    case factualAnswering
    case adFromProductDescription
    case productNameGenerator
    case tldrSummarization
    case pythonBugFixer
    case spreadSheetGenerator
    case javaScriptHelperChatbot
    case MLAILanguageModelTutor
    case scienceFictionBookListMaker
    case tweetClassifier
    case airportCodeExtractor
    case sqlRequest
    case extractContactInformation
    case javaScriptToPython
    case friendChat
    case moodToColor
    case writeAPythonDocstring
    case analogyMaker
    case javaScriptOneLineFunction
    case microHorrorStoryCreator
    case thirdPersonConverter
    case notesToSummary
    case VRFitnessIdeaGenerator
    case ESRBRating
    case essayOutline
    case recipeGenerator
    case marvTheSarcasticChatbot
    case turnByTurnDirections
    case restaurantReviewCreator
    case createStudyNotes
    case interviewQuestions
}

func genColor() -> Color {
    let randomInt = Int.random(in: 1...3)
    switch randomInt {
    case 1:
        return Color(red: 0.905, green: 0.969, blue: 1.0, opacity: 1.0) // blue
    case 2:
        return Color(red: 0.875, green: 1, blue: 0.93, opacity: 1.0) // green
    case 3:
        return Color(red: 0.945, green: 0.939, blue: 1.0, opacity: 1.0) // pink
    default:
        return genColor()
    }
}

struct NeumorphicButtonStyle: ButtonStyle {
    var col: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary)
            .animation(.spring(), value: 0)
            .frame(width: 150, height: 150)
            .background(
                ZStack {
                    Color(red: 0.811, green: 0.904, blue: 0.989, opacity: 1.0)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundColor(Color.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [col, Color.white]),  startPoint: .topLeading,  endPoint: .bottomTrailing)
                        )
                        .padding(2)
                        .blur(radius: 2)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: col, radius: configuration.isPressed ? 15: 20, x: configuration.isPressed ? 25: 20, y: configuration.isPressed ? 25: 20)
            .shadow(color: Color(red: 0.992, green: 0.992, blue: 0.992, opacity: 1.0), radius: configuration.isPressed ? 15: 20, x: configuration.isPressed ? -25: -20, y: configuration.isPressed ? -25: -20)
            .scaleEffect(configuration.isPressed ? 0.95: 1)
    }
}

struct PresetsView: View {
    @Binding var preset: Presets
    @Binding var presetStyle: [Color]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: CompletionSettings

    func build(preset: Presets) {
        switch preset {
        case .completion:
            self.preset = .completion
            settings.content = "Once upon a time"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 20
            settings.temperature = 1.0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.best_of = 1
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .chat:
            self.preset = .chat
            settings.content = "The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.\n\nHuman: Hello, who are you?\nAI: I am an AI created by OpenAI. How can I help you today?\nHuman: I'd like to cancel my subscription.\nAI:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 150
            settings.temperature = 0.9
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n", "Human:", "AI:"]
            settings.presence_penalty = 0.6
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .qanda:
            self.preset = .qanda
            settings.content = "I am a highly intelligent question answering bot. If you ask me a question that is rooted in truth, I will give you the answer. If you ask me a question that is nonsense, trickery, or has no clear answer, I will respond with \"Unknown\".\n\nQ: What is human life expectancy in the United States?\nA: Human life expectancy in the United States is 78 years.\n\nQ: Who was president of the United States in 1955?\nA: Dwight D. Eisenhower was president of the United States in 1955.\n\nQ: Which party did he belong to?\nA: He belonged to the Republican Party.\n\nQ: What is the square root of banana?\nA: Unknown\n\nQ: How does a telescope work?\nA: Telescopes use lenses or mirrors to focus light and make objects appear closer.\n\nQ: Where were the 1992 Olympics held?\nA: The 1992 Olympics were held in Barcelona, Spain.\n\nQ: How many squigs are in a bonk?\nA: Unknown\n\nQ: Where is the Valley of Kings?\nA:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 100
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .grammarCorrection:
            self.preset = .grammarCorrection
            settings.content = "Original: She no went to the market.\nStandard American English:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .summarizeForA2ndGrader:
            self.preset = .summarizeForA2ndGrader
            settings.content = "My second grader asked me what this passage means:\n\"\"\"\nJupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun, but two-and-a-half times that of all the other planets in the Solar System combined. Jupiter is one of the brightest objects visible to the naked eye in the night sky, and has been known to ancient civilizations since before recorded history. It is named after the Roman god Jupiter.[19] When viewed from Earth, Jupiter can be bright enough for its reflected light to cast visible shadows,[20] and is on average the third-brightest natural object in the night sky after the Moon and Venus.\n\"\"\"\nI rephrased it for him, in plain language a second grader can understand:\n\"\"\"\n"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\"\"\""]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .naturalLanguageToOpenAIAPI:
            self.preset = .naturalLanguageToOpenAIAPI
            settings.content = "\"\"\"\nUtil exposes the following:\nutil.openai() -> authenticates & returns the openai module, which has the following functions:\nopenai.Completion.create(\n    prompt=\"<my prompt>\", # The prompt to start completing from\n    max_tokens=123, # The max number of tokens to generate\n    temperature=1.0 # A measure of randomness\n    echo=True, # Whether to return the prompt in addition to the generated completion\n)\n\"\"\"\nimport util\n\"\"\"\nCreate an OpenAI completion starting from the prompt \"Once upon an AI\", no more than 5 tokens. Does not include the prompt.\n\"\"\"\n"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\"\"\""]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .textToCommand:
            self.preset = .textToCommand
            settings.content = "Q: Ask Constance if we need some bread\nA: send-msg `find constance` Do we need some bread?\nQ: Send a message to Greg to figure out if things are ready for Wednesday.\nA: send-msg `find greg` Is everything ready for Wednesday?\nQ: Ask Ilya if we're still having our meeting this evening\nA: send-msg `find ilya` Are we still having a meeting this evening?\nQ: Contact the ski store and figure out if I can get my skis fixed before I leave on Thursday\nA: send-msg `find ski store` Would it be possible to get my skis fixed before I leave on Thursday?\nQ: Thank Nicolas for lunch\nA: send-msg `find nicolas` Thank you for lunch!\nQ: Tell Constance that I won't be home before 19:30 tonight — unmovable meeting.\nA: send-msg `find constance` I won't be home before 19:30 tonight. I have a meeting I can't move.\nQ: Let Jessie know I'll be at the meeting.\nA:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 100
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.2
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .englishToFrench:
            self.preset = .englishToFrench
            settings.content = "English: I do not speak French.\nFrench: Je ne parle pas français.\n\nEnglish: See you later!\nFrench: À tout à l'heure!\n\nEnglish: Where is a good restaurant?\nFrench: Où est un bon restaurant?\n\nEnglish: What rooms do you have available?\nFrench: Quelles chambres avez-vous de disponible?\n\nEnglish: What time is breakfast?\nFrench:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 100
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .naturalLanguageToStripeAPI:
            self.preset = .naturalLanguageToStripeAPI
            settings.content = "\"\"\"\nUtil exposes the following:\n\nutil.stripe() -> authenticates & returns the stripe module; usable as stripe.Charge.create etc\n\"\"\"\nimport util\n\"\"\"\nCreate a Stripe token using the users credit card: 5555-4444-3333-2222, expiration date 12 / 28, cvc 521\n\"\"\""
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 100
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\"\"\""]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .sqlTranslate:
            self.preset = .sqlTranslate
            settings.content = "### Postgres SQL tables, with their properties:\n#\n# Employee(id, name, department_id)\n# Department(id, name, address)\n# Salary_Payments(id, employee_id, amount, date)\n#\n### A query to list the names of the departments which employed more than 10 employees in the last 3 months\nSELECT"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 150
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["#", ";"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .parseUnstructuredData:
            self.preset = .parseUnstructuredData
            settings.content = "There are many fruits that were found on the recently discovered planet Goocrux. There are neoskizzles that grow there, which are purple and taste like candy. There are also loheckles, which are a grayish blue fruit and are very tart, a little bit like a lemon. Pounits are a bright green color and are more savory than sweet. There are also plenty of loopnovas which are a neon pink flavor and taste like cotton candy. Finally, there are fruits called glowls, which have a very sour and bitter taste which is acidic and caustic, and a pale orange tinge to them.\n\nPlease make a table summarizing the fruits from Goocrux\n| Fruit | Color | Flavor |\n| Neoskizzles | Purple | Sweet |\n| Loheckles | Grayish blue | Tart |\n"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 100
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .classification:
            self.preset = .classification
            settings.content = "The following is a list of companies and the categories they fall into\n\nFacebook: Social media, Technology\nLinkedIn: Social media, Technology, Enterprise, Careers\nUber: Transportation, Technology, Marketplace\nUnilever: Conglomerate, Consumer Goods\nMcdonalds: Food, Fast Food, Logistics, Restaurants\nFedEx:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 6
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .pythonToNaturalLanguage:
            self.preset = .pythonToNaturalLanguage
            settings.content = "# Python 3 \ndef remove_common_prefix(x, prefix, ws_prefix): \n    x[\"completion\"] = x[\"completion\"].str[len(prefix) :] \n    if ws_prefix: \n        # keep the single whitespace as prefix \n        x[\"completion\"] = \" \" + x[\"completion\"] \nreturn x \n\n# Explanation of what the code does\n\n#"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["#"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .movieToEmoji:
            self.preset = .movieToEmoji
            settings.content = "Back to Future: 👨👴🚗🕒\nBatman: 🤵🦇\nTransformers: 🚗🤖\nWonder Woman: 👸🏻👸🏼👸🏽👸🏾👸🏿\nWinnie the Pooh: 🐻🐼🐻\nThe Godfather: 👨👩👧🕵🏻‍♂️👲💥\nGame of Thrones: 🏹🗡🗡🏹\nSpider-Man:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.8
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .calculateTimeComplexity:
            self.preset = .calculateTimeComplexity
            settings.content = "def foo(n, k):\naccum = 0\nfor i in range(n):\n    for l in range(k):\n        accum += i\nreturn accum\n\"\"\"\nThe time complexity of this function is"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .translateProgrammingLanguages:
            self.preset = .translateProgrammingLanguages
            settings.content = "##### Translate this function  from Python into Haskell\n### Python\n    \n    def predict_proba(X: Iterable[str]):\n        return np.array([predict_one_probas(tweet) for tweet in X])\n    \n### Haskell"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 54
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .advancedTweetClassifier:
            self.preset = .advancedTweetClassifier
            settings.content = "This is a tweet sentiment classifier\nTweet: \"I loved the new Batman movie!\"\nSentiment: Positive\n###\nTweet: \"I hate it when my phone battery dies\"\nSentiment: Negative\n###\nTweet: \"My day has been 👍\"\nSentiment: Positive\n###\nTweet: \"This is the link to the article\"\nSentiment: Neutral\n###\nTweet text\n\n\n1. \"I loved the new Batman movie!\"\n2. \"I hate it when my phone battery dies\"\n3. \"My day has been 👍\"\n4. \"This is the link to the article\"\n5. \"This new music video blew my mind\"\n\n\nTweet sentiment ratings:\n1: Positive\n2: Negative\n3: Positive\n4: Neutral\n5: Positive\n\n\n###\nTweet text\n\n\n1. \"I can't stand homework\"\n2. \"This sucks. I'm bored 😠\"\n3. \"I can't wait for Halloween!!!\"\n4. \"My cat is adorable ❤️❤️\"\n5. \"I hate chocolate\"\n\n\nTweet sentiment ratings:\n1."
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .explainCode:
            self.preset = .explainCode
            settings.content = "class Log:\n    def __init__(self, path):\n        dirname = os.path.dirname(path)\n        os.makedirs(dirname, exist_ok=True)\n        f = open(path, \"a+\")\n\n        # Check that the file is newline-terminated\n        size = os.path.getsize(path)\n        if size > 0:\n            f.seek(size - 1)\n            end = f.read(1)\n            if end != \"\\n\":\n                f.write(\"\\n\")\n        self.f = f\n        self.path = path\n\n    def log(self, event):\n        event[\"_event_id\"] = str(uuid.uuid4())\n        json.dump(event, self.f)\n        self.f.write(\"\\n\")\n\n    def state(self):\n        state = {\"complete\": set(), \"last\": None}\n        for line in open(self.path):\n            event = json.loads(line)\n            if event[\"type\"] == \"submit\" and event[\"success\"]:\n                state[\"complete\"].add(event[\"id\"])\n                state[\"last\"] = event\n        return state\n\n\"\"\"\nHere's what the above class is doing:\n1."
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\"\"\""]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .keywords:
            self.preset = .keywords
            settings.content = "Text: Black-on-black ware is a 20th- and 21st-century pottery tradition developed by the Puebloan Native American ceramic artists in Northern New Mexico. Traditional reduction-fired blackware has been made for centuries by pueblo artists. Black-on-black ware of the past century is produced with a smooth surface, with the designs applied through selective burnishing or the application of refractory slip. Another style involves carving or incising designs and selectively polishing the raised areas. For generations several families from Kha'po Owingeh and P'ohwhóge Owingeh pueblos have been making black-on-black ware with the techniques passed down from matriarch potters. Artists from other pueblos have also produced black-on-black ware. Several contemporary artists have created works honoring the pottery of their ancestors.\n\nKeywords:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.8
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .factualAnswering:
            self.preset = .factualAnswering
            settings.content = "Q: Who is Batman?\nA: Batman is a fictional comic book character.\n###\nQ: What is torsalplexity?\nA: ?\n###\nQ: What is Devz9?\nA: ?\n###\nQ: Who is George Lucas?\nA: George Lucas is American film director and producer famous for creating Star Wars.\n###\nQ: What is the capital of California?\nA: Sacramento.\n###\nQ: What orbits the Earth?\nA: The Moon.\n###\nQ: Who is Fred Rickerson?\nA: ?\n###\nQ: What is an atom?\nA: An atom is a tiny particle that makes up everything.\n###\nQ: Who is Alvan Muntz?\nA: ?\n###\nQ: What is Kozar-09?\nA: ?\n###\nQ: How many moons does Mars have?\nA: Two, Phobos and Deimos.\n###\nQ: What's a language model?\nA:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .adFromProductDescription:
            self.preset = .adFromProductDescription
            settings.content = "Write a creative ad for the following product to run on Facebook:\n\"\"\"\"\"\"\nAiree is a line of skin-care products for young women with delicate skin. The ingredients are all-natural.\n\"\"\"\"\"\"\nThis is the ad I wrote for Facebook aimed at teenage girls:\n\"\"\"\"\"\""
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\"\"\"\"\"\""]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .productNameGenerator:
            self.preset = .productNameGenerator
            settings.content = "This is a product name generator\n\nProduct description: A home milkshake maker\nSeed words: fast, healthy, compact\nProduct names: HomeShaker, Fit Shaker, QuickShake, Shake Maker\n\nProduct description: A pair of shoes that can fit any foot size.\nSeed words: adaptable, fit\nProduct names:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .tldrSummarization:
            self.preset = .tldrSummarization
            settings.content = "A neutron star is the collapsed core of a massive supergiant star, which had a total mass of between 10 and 25 solar masses, possibly more if the star was especially metal-rich.[1] Neutron stars are the smallest and densest stellar objects, excluding black holes and hypothetical white holes, quark stars, and strange stars.[2] Neutron stars have a radius on the order of 10 kilometres (6.2 mi) and a mass of about 1.4 solar masses.[3] They result from the supernova explosion of a massive star, combined with gravitational collapse, that compresses the core past white dwarf star density to that of atomic nuclei.\n\ntl;dr:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .pythonBugFixer:
            self.preset = .pythonBugFixer
            settings.content = "##### Fix bugs in the below function\n \n### Buggy Python\nimport Random\na = random.randint(1,12)\nb = random.randint(1,12)\nfor i in range(10):\n    question = \"What is \"+a+\" x \"+b+\"? \"\n    answer = input(question)\n    if answer = a*b\n        print (Well done!)\n    else:\n        print(\"No.\")\n    \n### Fixed Python"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 182
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .spreadSheetGenerator:
            self.preset = .spreadSheetGenerator
            settings.content = "A single column spreadsheet of industry names:\n\n\nIndustry|\nAccounting/Finance\nAdvertising/Public Relations\nAerospace/Aviation\nArts/Entertainment/Publishing\nAutomotive\nBanking/Mortgage\nBusiness Development\nBusiness Opportunity\nClerical/Administrative\nConstruction/Facilities\nConsumer Goods\nCustomer Service\nEducation/Training\nEnergy/Utilities\nEngineering\nGovernment/Military\nGreen\n\n\n###\n\n\nA spreadsheet of top science fiction movies and the year of release:\n\n\nTitle|Year\nStar Wars|1977\nJaws|1975\nThe Exorcist|1973\nET|1982\nAliens|1986\nTerminator|1984\nBlade Runner|1982\nThe Thing|1982\nJurassic Park|1993\nThe Matrix|1999\n\n\n###\n\n\nA spreadsheet of hurricane and tropical storm counts with 13 columns:\n\n\n\"Month\"| \"Average\"| \"2005\"| \"2006\"| \"2007\"| \"2008\"| \"2009\"| \"2010\"| \"2011\"| \"2012\"| \"2013\"| \"2014\"| \"2015\"\n\"May\"|  0.1|  0|  0| 1| 1| 0| 0| 0| 2| 0|  0|  0  \n\"Jun\"|  0.5|  2|  1| 1| 0| 0| 1| 1| 2| 2|  0|  1\n\"Jul\"|  0.7|  5|  1| 1| 2| 0| 1| 3| 0| 2|  2|  1\n\"Aug\"|  2.3|  6|  3| 2| 4| 4| 4| 7| 8| 2|  2|  3\n\"Sep\"|  3.5|  6|  4| 7| 4| 2| 8| 5| 2| 5|  2|  5\n\"Oct\"|  2.0|  8|  0| 1| 3| 2| 5| 1| 5| 2|  3|  0\n\"Nov\"|  0.5|  3|  0| 0| 1| 1| 0| 1| 0| 1|  0|  1\n\"Dec\"|  0.0|  1|  0| 1| 0| 0| 0| 0| 0| 0|  0|  1\n    \n###\n\n\nA single column spreadsheet of days of the week:\n\n\nDay|\nMonday\nTuesday\nWednesday\nThursday\nFriday\nSaturday\nSunday\n\n\n###\n\n\nA two column spreadsheet of computer languages and their difficulty level:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .javaScriptHelperChatbot:
            self.preset = .javaScriptHelperChatbot
            settings.content = "JavaScript chatbot\n\n\nYou: How do I combine arrays?\nJavaScript chatbot: You can use the concat() method.\nYou: How do make an alert appear after 10 seconds?\nJavaScript chatbot:"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["You:"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .MLAILanguageModelTutor:
            self.preset = .MLAILanguageModelTutor
            settings.content = "ML/AI language model tutor\n\n\nYou: What is a language model?\nML Tutor: A language model is a statistical model that describes the probability of a word given the previous words.\nYou: What is a statistical model?\nML Tutor:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["You:"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .scienceFictionBookListMaker:
            self.preset = .scienceFictionBookListMaker
            settings.content = "Science fiction books\n\n\n1. Dune by Frank Herbert\n2."
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 200
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["11."]
            settings.presence_penalty = 0.5
            settings.frequency_penalty = 0.52
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .tweetClassifier:
            self.preset = .tweetClassifier
            settings.content = "This is a tweet sentiment classifier\n\n\nTweet: \"I loved the new Batman movie!\"\nSentiment: Positive\n###\nTweet: \"I hate it when my phone battery dies.\"\nSentiment: Negative\n###\nTweet: \"My day has been 👍\"\nSentiment: Positive\n###\nTweet: \"This is the link to the article\"\nSentiment: Neutral\n###\nTweet: \"This new music video blew my mind\"\nSentiment:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .airportCodeExtractor:
            self.preset = .airportCodeExtractor
            settings.content = "Airport code extractor:\n\nText: \"I want to fly form Los Angeles to Miami.\"\nAirport codes: LAX, MIA\n\nText: \"I want to fly from Orlando to Boston\"\nAirport codes:"
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .sqlRequest:
            self.preset = .sqlRequest
            settings.content = "Create a SQL request to find all users who live in California and have over 1000 credits:\n\nSELECT"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .extractContactInformation:
            self.preset = .extractContactInformation
            settings.content = "Extract the mailing address from this email:\n\nDear Kelly,\n\nIt was great to talk to you at the seminar. I thought Jane's talk was quite good.\n\nThank you for the book. Here's my address 2111 Ash Lane, Crestview CA 92002\n\nBest,\n\nMaya\n\nName and address:\n"
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .javaScriptToPython:
            self.preset = .javaScriptToPython
            settings.content = "#JavaScript to Python:\nJavaScript: \ndogs = [\"bill\", \"joe\", \"carl\"]\ncar = []\ndogs.forEach((dog) {\n    car.push(dog);\n});\n\nPython:\n"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .friendChat:
            self.preset = .friendChat
            settings.content = "You: What have you been up to?\nFriend: Watching old movies.\nYou: Did you watch anything interesting?\nFriend:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.4
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["You:"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .moodToColor:
            self.preset = .moodToColor
            settings.content = "The CSS code for a color like a blue sky at dusk:\n\nbackground-color: #"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = [";"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .writeAPythonDocstring:
            self.preset = .writeAPythonDocstring
            settings.content = "# Python 3.7\n \ndef randomly_split_dataset(folder, filename, split_ratio=[0.8, 0.2]):\n    df = pd.read_json(folder + filename, lines=True)\n    train_name, test_name = \"train.jsonl\", \"test.jsonl\"\n    df_train, df_test = train_test_split(df, test_size=split_ratio[1], random_state=42)\n    df_train.to_json(folder + train_name, orient='records', lines=True)\n    df_test.to_json(folder + test_name, orient='records', lines=True)\nrandomly_split_dataset('finetune_data/', 'dataset.jsonl')\n    \n# An elaborate, high quality docstring for the above function:\n\"\"\""
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 150
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["#", "\"\"\""]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .analogyMaker:
            self.preset = .analogyMaker
            settings.content = "Ideas are like balloons in that: they need effort to realize their potential.\n\nQuestions are arrows in that:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .javaScriptOneLineFunction:
            self.preset = .javaScriptOneLineFunction
            settings.content = "Use list comprehension to convert this into one line of JavaScript:\n\ndogs.forEach((dog) => {\n    car.push(dog);\n});\n\nJavaScript one line version:"
            settings.engine = "davinci-codex"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = [";"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .microHorrorStoryCreator:
            self.preset = .microHorrorStoryCreator
            settings.content = "Topic: Breakfast\nTwo-Sentence Horror Story: He always stops crying when I pour the milk on his cereal. I just have to remember not to let him see his face on the carton.\n###\nTopic: Wind\nTwo-Sentence Horror Story:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.5
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["###"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .thirdPersonConverter:
            self.preset = .thirdPersonConverter
            settings.content = "First-person to third-person\n\nInput: I decided to make a movie about Ada Lovelace.\nOutput: He decided to make a movie about Ada Lovelace.\n\nInput: My biggest fear was that I wasn't able to write the story adequately.\nOutput: His biggest fear was that he wouldn't be able to write the story adequately.\n\nInput: I started researching my biology project last week.\nOutput:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .notesToSummary:
            self.preset = .notesToSummary
            settings.content = "Convert my short hand into a first-hand account of the meeting:\n\nTom: Profits up 50%\nJane: New servers are online\nKjel: Need more time to fix software\nJane: Happy to help\nParkman: Beta testing almost done\n\nSummary:"
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0.7
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .VRFitnessIdeaGenerator:
            self.preset = .VRFitnessIdeaGenerator
            settings.content = "Video game ideas involving fitness and virtual reality\n\n1. Alien Yoga\nUse VR to practice yoga as an alien with extra arms and legs.\n\n2. Speed Run\nExercise like your favorite video game characters reenacting games like Sonic and Mario Bros.\n\n3. Space Ballet"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.7
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0.5
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .ESRBRating:
            self.preset = .ESRBRating
            settings.content = "Provide an ESRB rating for the following text:\n\n\"i'm going to blow your brains out with my ray gun then stomp on your guts.\"\n\nESRB rating:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.7
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .essayOutline:
            self.preset = .essayOutline
            settings.content = "Create an outline for an essay about Walt Disney and his contributions to animation:\n\nI: Introduction"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.7
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .recipeGenerator:
            self.preset = .recipeGenerator
            settings.content = "Write a recipe based on these ingredients and instructions:\n\nFrito Pie\n\nIngredients:\nFritos\nChili\nShredded cheddar cheese\nSweet white or red onions, diced small\nSour cream\n\nDirections:"
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 120
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .marvTheSarcasticChatbot:
            self.preset = .marvTheSarcasticChatbot
            settings.content = "Marv is a chatbot that reluctantly answers questions.\nYou: How many pounds are in a kilogram?\nMarv: This again? There are 2.2 pounds in a kilogram. Please make a note of this.\nYou: What does HTML stand for?\nMarv: Was Google too busy? Hypertext Markup Language. The T is for try to ask better questions in the future.\nYou: When did the first airplane fly?\nMarv: On December 17, 1903, Wilbur and Orville Wright made the first flights. I wish they’d come and take me away.\nYou: What is the meaning of life?\nMarv: I’m not sure. I’ll ask my friend Google.\nYou: Why is the sky blue?\nMarv:"
            settings.engine = "davinci"
            settings.prompt = ""
            settings.max_tokens = 60
            settings.temperature = 0.3
            settings.top_p = 0.3
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0.5
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .turnByTurnDirections:
            self.preset = .turnByTurnDirections
            settings.content = "Create turn-by-turn directions from this text:\n\nGo south on 95 unto you hit Sunrise boulevard then take it east to us 1 and head south. Tom Jenkins bbq will be on the left after several miles.\n\n1."
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .restaurantReviewCreator:
            self.preset = .restaurantReviewCreator
            settings.content = "Write a restaurant review based on these notes:\n\nName: The Blue Wharf\nLobster great, noisy, service polite, prices good.\n\nReview:"
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0.3
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .createStudyNotes:
            self.preset = .createStudyNotes
            settings.content = "What are some key points I should know when studying Ancient Rome?\n\n1."
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 1
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = []
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        case .interviewQuestions:
            self.preset = .interviewQuestions
            settings.content = "Create a list of questions for my interview with a science fiction author:\n\n1."
            settings.engine = "davinci-instruct-beta-v3"
            settings.prompt = ""
            settings.max_tokens = 64
            settings.temperature = 0.8
            settings.top_p = 1.0
            settings.n = 1
            settings.stream = false
            settings.stop = ["\n\n"]
            settings.presence_penalty = 0
            settings.frequency_penalty = 0
            settings.reverseCard = []
            settings.reverseCard.append(settings.content)
        }
    }

    var body: some View {
        ScrollView {
            Button(action: {
                dismiss()
            }, label: {
                Text("Dismiss")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            VStack(spacing: 35) {
                VStack(spacing: 35) {
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .completion)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "paragraphsign")
                                    .font(.system(size: 40))
                                Text("Completion")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[0]))
                        Spacer()
                        Button(action: {
                            build(preset: .chat)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "ellipsis.bubble.fill")
                                    .font(.system(size: 40))
                                Text("Chat")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[1]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .qanda)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 40))
                                Text("Q&A")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[2]))
                        Spacer()
                        Button(action: {
                            build(preset: .grammarCorrection)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "graduationcap.fill")
                                    .font(.system(size: 40))
                                Text("Grammar correction")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[3]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .summarizeForA2ndGrader)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "forward.fill")
                                    .font(.system(size: 40))
                                Text("Summarize for 2nd grader")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[4]))
                        Spacer()
                        Button(action: {
                            build(preset: .naturalLanguageToOpenAIAPI)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "text.bubble.fill")
                                    .font(.system(size: 40))
                                Text("Natural language to OpenAI API")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 2)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[5]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .textToCommand)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "terminal.fill")
                                    .font(.system(size: 40))
                                Text("Text to command")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[6]))
                        Spacer()
                        Button(action: {
                            build(preset: .englishToFrench)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "globe")
                                    .font(.system(size: 40))
                                Text("English to French")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[7]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .naturalLanguageToStripeAPI)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 40))
                                Text("Natural language to Stripe API")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[8]))
                        Spacer()
                        Button(action: {
                            build(preset: .sqlTranslate)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "number")
                                    .font(.system(size: 40))
                                Text("SQL translate")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[9]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .parseUnstructuredData)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "tablecells")
                                    .font(.system(size: 40))
                                Text("Parse unstructured data")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[10]))
                        Spacer()
                        Button(action: {
                            build(preset: .classification)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 40))
                                Text("Classification")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[11]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .pythonToNaturalLanguage)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "chevron.left.forwardslash.chevron.right")
                                    .font(.system(size: 40))
                                Text("Python to natural language")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[12]))
                        Spacer()
                        Button(action: {
                            build(preset: .movieToEmoji)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 40))
                                Text("Movie to Emoji")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[13]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .calculateTimeComplexity)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 40))
                                Text("Calculate Time Complexity")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[14]))
                        Spacer()
                        Button(action: {
                            build(preset: .translateProgrammingLanguages)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "character.cursor.ibeam")
                                    .font(.system(size: 40))
                                Text("Translate programming languages")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[15]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .advancedTweetClassifier)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "scale.3d")
                                    .font(.system(size: 40))
                                Text("Advanced tweet classifier")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[16]))
                        Spacer()
                        Button(action: {
                            build(preset: .explainCode)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "rectangle.inset.filled.and.person.filled")
                                    .font(.system(size: 40))
                                Text("Explain code")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[17]))
                        Spacer()
                    }
                }
                VStack(spacing: 35) {
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .keywords)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "key.fill")
                                    .font(.system(size: 40))
                                Text("Keywords")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[18]))
                        Spacer()
                        Button(action: {
                            build(preset: .factualAnswering)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "quote.bubble.fill")
                                    .font(.system(size: 40))
                                Text("Factual answering")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[19]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .adFromProductDescription)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "wallet.pass.fill")
                                    .font(.system(size: 40))
                                Text("Create Ad from product description")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[20]))
                        Spacer()
                        Button(action: {
                            build(preset: .productNameGenerator)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 40))
                                Text("Product name generator")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[21]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .tldrSummarization)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 40))
                                Text("TL;DR summarization")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[22]))
                        Spacer()
                        Button(action: {
                            build(preset: .pythonBugFixer)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "ladybug.fill")
                                    .font(.system(size: 40))
                                Text("Python bug fixer")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 2)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[23]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .spreadSheetGenerator)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "rectangle.split.3x3")
                                    .font(.system(size: 40))
                                Text("Spreadsheet generator")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[24]))
                        Spacer()
                        Button(action: {
                            build(preset: .javaScriptHelperChatbot)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "cube.transparent.fill")
                                    .font(.system(size: 40))
                                Text("JavaScript helper chatbot")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[25]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .MLAILanguageModelTutor)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "text.book.closed.fill")
                                    .font(.system(size: 40))
                                Text("ML/AI language model tutor")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[26]))
                        Spacer()
                        Button(action: {
                            build(preset: .scienceFictionBookListMaker)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "books.vertical.fill")
                                    .font(.system(size: 40))
                                Text("Science fiction book list maker")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[27]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .tweetClassifier)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "archivebox.fill")
                                    .font(.system(size: 40))
                                Text("Tweet classifier")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[28]))
                        Spacer()
                        Button(action: {
                            build(preset: .airportCodeExtractor)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 40))
                                Text("Airport code extractor")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[29]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .sqlRequest)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "terminal.fill")
                                    .font(.system(size: 40))
                                Text("SQL request")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[30]))
                        Spacer()
                        Button(action: {
                            build(preset: .extractContactInformation)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                Text("Extract contact information")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[31]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .javaScriptToPython)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "curlybraces.square.fill")
                                    .font(.system(size: 40))
                                Text("JavaScript to Python")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[32]))
                        Spacer()
                        Button(action: {
                            build(preset: .friendChat)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 40))
                                Text("Friend chat")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[33]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .moodToColor)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "face.smiling.fill")
                                    .font(.system(size: 40))
                                Text("Mood to color")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[34]))
                        Spacer()
                        Button(action: {
                            build(preset: .writeAPythonDocstring)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "doc.fill")
                                    .font(.system(size: 40))
                                Text("Write a Python docstring")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[35]))
                        Spacer()
                    }
                }
                VStack(spacing: 35) {
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .analogyMaker)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 40))
                                Text("Analogy maker")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[36]))
                        Spacer()
                        Button(action: {
                            build(preset: .javaScriptOneLineFunction)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "terminal.fill")
                                    .font(.system(size: 40))
                                Text("JavaScript one line function")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[37]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .microHorrorStoryCreator)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "applepencil")
                                    .font(.system(size: 40))
                                Text("Micro horror story creator")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[38]))
                        Spacer()
                        Button(action: {
                            build(preset: .thirdPersonConverter)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "captions.bubble.fill")
                                    .font(.system(size: 40))
                                Text("Third-person converter")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[39]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .notesToSummary)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "ellipsis.bubble.fill")
                                    .font(.system(size: 40))
                                Text("Notes to summary")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[40]))
                        Spacer()
                        Button(action: {
                            build(preset: .VRFitnessIdeaGenerator)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "sportscourt.fill")
                                    .font(.system(size: 40))
                                Text("VR fitness idea generator")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 2)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[41]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .ESRBRating)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 40))
                                Text("ESRB rating")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[42]))
                        Spacer()
                        Button(action: {
                            build(preset: .essayOutline)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "doc.append.fill")
                                    .font(.system(size: 40))
                                Text("Essay outline")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[43]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .recipeGenerator)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .font(.system(size: 40))
                                Text("Recipe generator")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[44]))
                        Spacer()
                        Button(action: {
                            build(preset: .marvTheSarcasticChatbot)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "character.bubble.fill")
                                    .font(.system(size: 40))
                                Text("Marv the sarcastic chat bot")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[45]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .turnByTurnDirections)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 40))
                                Text("Turn by turn directions")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[46]))
                        Spacer()
                        Button(action: {
                            build(preset: .restaurantReviewCreator)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 40))
                                Text("Restaurant review creator")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[47]))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            build(preset: .createStudyNotes)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "note.text")
                                    .font(.system(size: 40))
                                Text("Create study notes")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 5)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[48]))
                        Spacer()
                        Button(action: {
                            build(preset: .interviewQuestions)
                            dismiss()
                        }, label: {
                            VStack {
                                Image(systemName: "briefcase.fill")
                                    .font(.system(size: 40))
                                Text("Interview questions")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.top, 10)
                            }
                        })
                            .buttonStyle(NeumorphicButtonStyle(col: presetStyle[49]))
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .background(Color.white)
    }
}

struct PresetsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
