//
//  LocalAuthView.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 27.11.2021.
//

import SwiftUI

private struct NumberView: View {

    let values: ResultModel
    let value: String

    var body: some View {
        GeometryReader { g in
            Text(value)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: g.size.width / 2.5,
                              weight: .light,
                              design: .default))
                .onTapGesture {
                    values.insert(value)
                }
        }
    }
}

private struct KeyboardView: View {

    let values: ResultModel

    private static let keyboards = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"]
    ]

    private static let biometricImage: UIImage = biometricType.isFaceId ? R.image.faceId_icon()! : R.image.touchId_icon()!

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 8) {
                ForEach(Self.keyboards, id: \.self) { i in
                    HStack {
                        ForEach(i, id: \.self) { j in
                            NumberView(values: values, value: j)
                        }
                    }
                }
                HStack {
                    Image(uiImage: Self.biometricImage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            values.loginWithBiometric()
                        }
                    NumberView(values: values, value: "0")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Image(uiImage: R.image.delete_icon()!)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            values.removeLast()
                        }
                }
            }
            .padding(g.size.width / 10)
            .frame(minWidth: g.size.width)


        }
    }
}

final class ResultModel: ObservableObject, DISupportable {
    @Published private(set) var values: [Int] = [] {
        didSet {
            print(values)
        }
    }

    @Published private(set) var needsToAnimate = false
    private(set) var isFailed = false

    private lazy var localAuthManager = diContainer.resolve(LocalAuthManagerProtocol.self)!

    func insert(_ value: String) {
        guard values.count - 1 < ResultView.symbolsCount.upperBound else {
            Vibration.error.vibrate()
            return
        }
        guard let intValue = Int(value) else { return }
        values.append(intValue)
        needsToAnimate = true
        Vibration.light.vibrate()
        if ResultView.symbolsCount.upperBound == values.count - 1 {
            switch localAuthManager.login(with: values) {
            case true:
                Vibration.success.vibrate()

            case false:
                Vibration.error.vibrate()
                isFailed = true
                values.removeAll()
            }
        }
    }

    func getNeedsToAnimate(index: Int) -> Bool {
        if isFailed { return true }
        guard needsToAnimate else { return false }
        return values.count - 1 == index
    }

    func animated() {
        isFailed = false
        needsToAnimate = false
    }

    func removeLast() {
        guard values.isEmpty == false else {
            Vibration.error.vibrate()
            return
        }
        values.popLast()
        Vibration.medium.vibrate()
    }

    func loginWithBiometric() {
        localAuthManager.authWithBiometric()
    }

    var insertedRange: Range<Int> { values.indices }
}
private struct ResultView: View {

    private static let borderColor: Color = .init(UIColor(rgb: 0x838487))
    private static let selectedColor: Color = .init(UIColor(rgb: 0x505051))

    static let symbolsCount = 0...3
    @ObservedObject var values: ResultModel

    var body: some View {
        GeometryReader { g in
            VStack {
                Text(R.string.localizable.localAuthEnterPin())
                HStack(alignment: .top, spacing: 24) {
                    ForEach(Self.symbolsCount, id: \.self) { i in
                        let _ = print("hi!", i, values.insertedRange.contains(i), values.insertedRange)
                        let isActive = values.insertedRange.contains(i)
                        let notActiveColor = values.isFailed ? Color.red : .clear
                        let bgColor: Color = isActive && values.isFailed == false ? Self.selectedColor : notActiveColor
                        let needsToAnimate = values.getNeedsToAnimate(index: i)
                        let scaleUpDuration: Double = 0.2
                        let d = DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(scaleUpDuration * 1000))) {
                            guard needsToAnimate else { return }
                            values.animated()
                        }
                        Circle()
                            .strokeBorder(Self.borderColor)
                            .background(Circle().fill(bgColor))
                            .frame(width: 25, height: 25)
                            .scaleEffect(needsToAnimate ? 1.5 : 1)
                            .animation(.easeInOut(duration: scaleUpDuration), value: needsToAnimate)
                    }
                }
                .padding(EdgeInsets(top: 24,
                                    leading: .zero,
                                    bottom: .zero,
                                    trailing: .zero))
//                .background(Color.green)
            }
            .padding(g.size.width / 4)
            .frame(maxWidth: .infinity)
        }
    }
}

struct LocalAuthView: View {

    @ObservedObject private var values: ResultModel = .init()

    var body: some View {
        VStack {
            ResultView(values: values)
            KeyboardView(values: values)
            Text(R.string.localizable.localAuthDontRemember())
            Spacer(minLength: .zero)
        }
//        .background(Color(Colors.homeScreenBg).edgesIgnoringSafeArea(.all))
        .onAppear {
            values.loginWithBiometric()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocalAuthView()
    }
}
