import SwiftUI
import CoreML
import Vision

struct PracticeView: View {
    let targetNumber: Int
    @State private var drawing: UIImage? = nil
    @State private var points: [CGPoint] = []
    @State private var resultMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Draw the number \(targetNumber)")
                .font(.title)

            DrawingPad(drawing: $drawing, points: $points)
                .frame(width: 300, height: 300)
                .padding()

            HStack(spacing: 20) {
                Button("Clear") {
                    points = []
                    drawing = nil
                    resultMessage = nil
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Check") {
                    if let image = drawing {
                        predictNumber(from: image)
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            if let message = resultMessage {
                Text(message)
                    .font(.headline)
                    .foregroundColor(message == "Correct!" ? .green : .red)
            }
        }
        .navigationTitle("Practice \(targetNumber)")
    }

    private func invertImage(_ image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        let context = CIContext()
        if let output = filter?.outputImage,
           let cgimg = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgimg)
        }

        return image
    }

    private func predictNumber(from image: UIImage) {
        let invertedImage = invertImage(image)
        guard let cgImage = invertedImage.cgImage else { return }

        do {
            let model = try VNCoreMLModel(for: MNISTClassifier().model)

            let request = VNCoreMLRequest(model: model) { request, _ in
                if let result = request.results?.first as? VNClassificationObservation,
                   let predictedInt = Int(result.identifier) {
                    if predictedInt == targetNumber {
                        resultMessage = "Correct!"
                    } else {
                        resultMessage = "Incorrect. That looks like a \(predictedInt)"
                    }
                } else {
                    resultMessage = "Could not recognize the number"
                }
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
        } catch {
            resultMessage = "Prediction failed"
        }
    }
}
