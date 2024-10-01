import SwiftUI

struct ContentView: View {
    @State private var credits: Int = 1000
    @State private var reels: [Int] = [1, 1, 1]
    @State private var isSpinning: Bool = false
    @State private var winAmount: Int = 0
    @State private var showJackpot: Bool = false
    @State private var gameOver: Bool = false
    
    let spinCost: Int = 50
    let spinDuration: Double = 1.0
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Lucky Slots")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                // Credits Display
                Text("Credits: $\(credits)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .background(Capsule().fill(Color.white.opacity(0.2)))
                
                // Slot Reels
                HStack(spacing: 15) {
                    ForEach(0..<3) { index in
                        FruitReel(symbol: $reels[index])
                            .rotation3DEffect(.degrees(isSpinning ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                            .animation(isSpinning ? Animation.easeInOut(duration: spinDuration).repeatCount(1) : .default, value: isSpinning)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.2)))
                
                // Win Amount Display
                if winAmount > 0 {
                    Text("You won $\(winAmount)!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .transition(.scale)
                }
                
                // Spin Button
                Button(action: spin) {
                    Text("Spin! ($\(spinCost))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .background(Capsule().fill(Color.green))
                        .foregroundColor(.white)
                }
                .disabled(isSpinning || credits < spinCost || gameOver)
                .scaleEffect(isSpinning ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSpinning)
                
                // Jackpot Animation
                if showJackpot {
                    Text("JACKPOT!")
                        .font(.system(size: 60, weight: .heavy, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange, radius: 2, x: 0, y: 0)
                        .transition(.scale)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: showJackpot)
                }
                
                // Game Over
                if gameOver {
                    VStack {
                        Text("Game Over")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding()
                        
                        Button("Restart Game") {
                            resetGame()
                        }
                        .padding()
                        .background(Capsule().fill(Color.blue))
                        .foregroundColor(.white)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: gameOver)
                }
            }
            .padding()
        }
    }
    
    func spin() {
        isSpinning = true
        credits -= spinCost
        winAmount = 0
        showJackpot = false
        
        // Simulate spinning animation
        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration) {
            reels = reels.map { _ in Int.random(in: 1...5) }
            calculateWinnings()
            isSpinning = false
            
            if credits <= 0 {
                gameOver = true
            }
        }
    }
    
    func calculateWinnings() {
        let uniqueSymbols = Set(reels)
        
        switch uniqueSymbols.count {
        case 1: // All symbols match (Jackpot)
            winAmount = spinCost * 50
            showJackpot = true
        case 2: // Two symbols match
            winAmount = spinCost * 5
        default: // No matches
            winAmount = 0
        }
        
        credits += winAmount
    }
    
    func resetGame() {
        credits = 1000
        reels = [1, 1, 1]
        isSpinning = false
        winAmount = 0
        showJackpot = false
        gameOver = false
    }
}

struct FruitReel: View {
    @Binding var symbol: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 80, height: 80)
            
            Text(symbolEmoji)
                .font(.system(size: 50))
        }
    }
    
    var symbolEmoji: String {
        switch symbol {
        case 1: return "🍎"
        case 2: return "🍋"
        case 3: return "🍒"
        case 4: return "🍇"
        case 5: return "💎"
        default: return "❓"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
