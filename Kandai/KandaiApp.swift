import SwiftUI

// 음료 모델
struct Drink: Identifiable {
    let id = UUID()
    let name: String
    let caffeineMg: Int
    let emoji: String
}

// 메인 콘텐츠 뷰
struct ContentView: View {
    @State private var totalCaffeineMg: Int = 0
    @State private var drinkHistory: [Drink] = []

    var caffeineMessage: String {
        switch totalCaffeineMg {
        case 0:
            return "まだカフェインを摂取していません ☕️"
        case 1..<100:
            return "適度なカフェイン摂取量です ✅"
        case 100..<200:
            return "良いコンディションを保っています 💪"
        case 200..<300:
            return "摂取量が少し多くなっています ⚠️"
        case 300..<400:
            return "カフェイン摂取量が多いです 🚨"
        default:
            return "カフェイン過多！今日はもうやめましょう 🛑"
        }
    }
    
    var messageColor: Color {
        switch totalCaffeineMg {
        case 0..<100: return .green
        case 100..<200: return .blue
        case 200..<300: return .orange
        default: return .red
        }
    }
    
    private var progressValue: Double {
        min(Double(totalCaffeineMg), 400.0)
    }
    
    private var progressColor: Color {
        switch totalCaffeineMg {
        case 0..<200: return .green
        case 200..<300: return .orange
        default: return .red
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // 헤더
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.title2)
                                .foregroundColor(.brown)
                            Text("Caffeine Checker")
                                .font(.title).bold()
                        }
                        Text("今日のカフェイン摂取量を管理してみましょう")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // 카페인 수치 카드
                    VStack(spacing: 16) {
                        Text("\(totalCaffeineMg)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(progressColor)
                        + Text(" mg")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        // 프로그레스 바
                        VStack(spacing: 8) {
                            ProgressView(value: progressValue, total: 400)
                                .tint(progressColor)
                                .frame(height: 12)
                                .background(.gray.opacity(0.2))
                                .clipShape(Capsule())
                            
                            HStack {
                                Text("0mg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("推奨量: 400mg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(caffeineMessage)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(messageColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // 네비게이션 버튼
                    VStack(spacing: 12) {
                        NavigationLink {
                            AddDrinkView(totalCaffeineMg: $totalCaffeineMg,
                                         drinkHistory: $drinkHistory)
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("ドリンクを追加")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding(16)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        NavigationLink {
                            CustomBlendView(totalCaffeineMg: $totalCaffeineMg,
                                            drinkHistory: $drinkHistory)
                        } label: {
                            HStack {
                                Image(systemName: "flask.fill")
                                Text("オリジナルブレンドを作成")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.blue)
                            .padding(16)
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    // 오늘 마신 음료 목록
                    if !drinkHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("今日飲んだドリンク")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("\(drinkHistory.count)杯")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            LazyVStack(spacing: 8) {
                                ForEach(drinkHistory.reversed()) { drink in
                                    HStack(spacing: 12) {
                                        Text(drink.emoji)
                                            .font(.title2)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(drink.name)
                                                .fontWeight(.medium)
                                            Text("カフェイン \(drink.caffeineMg)mg")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("+\(drink.caffeineMg)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(progressColor)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(progressColor.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                    .padding(12)
                                    .background(.gray.opacity(0.05))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    // 리셋 버튼 (개발/테스트용)
                    if !drinkHistory.isEmpty {
                        Button {
                            withAnimation {
                                totalCaffeineMg = 0
                                drinkHistory.removeAll()
                            }
                        } label: {
                            Text("今日の記録をリセット")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.top)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

// 음료 추가 뷰
struct AddDrinkView: View {
    @Binding var totalCaffeineMg: Int
    @Binding var drinkHistory: [Drink]
    @Environment(\.dismiss) private var dismiss

    let drinks: [Drink] = [
        Drink(name: "アメリカーノ", caffeineMg: 95, emoji: "☕️"),
        Drink(name: "コールドブリュー", caffeineMg: 150, emoji: "🧊"),
        Drink(name: "カフェラテ", caffeineMg: 75, emoji: "🥛"),
        Drink(name: "エスプレッソ", caffeineMg: 65, emoji: "☕️"),
        Drink(name: "緑茶", caffeineMg: 30, emoji: "🍵"),
        Drink(name: "紅茶", caffeineMg: 40, emoji: "🫖"),
        Drink(name: "エナジードリンク", caffeineMg: 80, emoji: "⚡️"),
        Drink(name: "コーラ", caffeineMg: 34, emoji: "🥤"),
        Drink(name: "ダークチョコレート", caffeineMg: 25, emoji: "🍫")
    ]

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(drinks) { drink in
                        Button {
                            withAnimation(.spring(response: 0.5)) {
                                totalCaffeineMg += drink.caffeineMg
                                drinkHistory.append(drink)
                            }
                            
                            // 햅틱 피드백 추가
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            dismiss()
                        } label: {
                            HStack(spacing: 16) {
                                Text(drink.emoji)
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(drink.name)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    Text("カフェイン \(drink.caffeineMg)mg")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .imageScale(.large)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("飲んだドリンクを選択してください")
                }
            }
            .navigationTitle("ドリンク追加")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 커스텀 블렌딩 뷰
struct CustomBlendView: View {
    @Binding var totalCaffeineMg: Int
    @Binding var drinkHistory: [Drink]
    @Environment(\.dismiss) private var dismiss

    @State private var blendName: String = ""
    @State private var selectedIngredients: Set<UUID> = []

    let ingredients: [Drink] = [
        Drink(name: "エスプレッソショット", caffeineMg: 65, emoji: "☕️"),
        Drink(name: "紅茶", caffeineMg: 40, emoji: "🍂"),
        Drink(name: "緑茶", caffeineMg: 30, emoji: "🍵"),
        Drink(name: "ミント", caffeineMg: 0, emoji: "🌿"),
        Drink(name: "ミルク/クリーム", caffeineMg: 0, emoji: "🥛"),
        Drink(name: "モカシロップ", caffeineMg: 5, emoji: "🍫"),
        Drink(name: "バニラシロップ", caffeineMg: 0, emoji: "🍦"),
        Drink(name: "レモン", caffeineMg: 0, emoji: "🍋"),
        Drink(name: "ハチミツ", caffeineMg: 0, emoji: "🍯")
    ]

    var blendCaffeine: Int {
        ingredients
            .filter { selectedIngredients.contains($0.id) }
            .map(\.caffeineMg)
            .reduce(0, +)
    }
    
    var selectedIngredientsNames: String {
        let names = ingredients
            .filter { selectedIngredients.contains($0.id) }
            .map(\.name)
        return names.isEmpty ? "材料を選択してください" : names.joined(separator: ", ")
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("例: ミント レモン ラテ", text: $blendName)
                        .textFieldStyle(.roundedBorder)
                } header: {
                    Text("ブレンド名")
                }
                
                Section {
                    ForEach(ingredients) { ingredient in
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if selectedIngredients.contains(ingredient.id) {
                                        selectedIngredients.remove(ingredient.id)
                                    } else {
                                        selectedIngredients.insert(ingredient.id)
                                    }
                                }
                            } label: {
                                Image(systemName: selectedIngredients.contains(ingredient.id)
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(selectedIngredients.contains(ingredient.id) ? .blue : .gray)
                                .imageScale(.large)
                            }
                            .buttonStyle(.plain)
                            
                            Text(ingredient.emoji)
                                .font(.title3)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ingredient.name)
                                    .fontWeight(.medium)
                                if ingredient.caffeineMg > 0 {
                                    Text("カフェイン \(ingredient.caffeineMg)mg")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                } header: {
                    Text("材料選択")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("総カフェイン:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(blendCaffeine) mg")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(blendCaffeine > 0 ? .blue : .gray)
                        }
                        
                        Text("選択した材料: \(selectedIngredientsNames)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("ブレンド情報")
                }
                
                Section {
                    Button {
                        guard !blendName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        
                        withAnimation {
                            totalCaffeineMg += blendCaffeine
                            let newDrink = Drink(name: blendName, caffeineMg: blendCaffeine, emoji: "🧪")
                            drinkHistory.append(newDrink)
                        }
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "flask.fill")
                            Text("ブレンド完成 & 飲む")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(canCreateBlend ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(!canCreateBlend)
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("オリジナルブレンド")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var canCreateBlend: Bool {
        !blendName.trimmingCharacters(in: .whitespaces).isEmpty && !selectedIngredients.isEmpty
    }
}

@main
struct KandaiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
