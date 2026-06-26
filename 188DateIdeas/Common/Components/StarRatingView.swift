import SwiftUI

struct StarRatingView: View {
    let rating: Int
    let maxRating: Int
    var onRatingChanged: ((Int) -> Void)?

    init(rating: Int, maxRating: Int = 5, onRatingChanged: ((Int) -> Void)? = nil) {
        self.rating = rating
        self.maxRating = maxRating
        self.onRatingChanged = onRatingChanged
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.title3)
                    .foregroundColor(index <= rating ? Color(hex: "FDCB6E") : AppColor.textSecondary.opacity(0.3))
                    .scaleEffect(index <= rating ? 1.05 : 1.0)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            onRatingChanged?(index)
                        }
                    }
            }
        }
    }
}
